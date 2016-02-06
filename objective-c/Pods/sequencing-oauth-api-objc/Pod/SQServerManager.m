//
//  SQServerManager.m
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

#import "SQServerManager.h"
#import "SQLoginViewController.h"
#import "SQToken.h"
#import "SQHttpHelper.h"
#import "SQAuthResult.h"
#import "SQRequestHelper.h"
#import "SQTokenUpdater.h"

#define kMainQueue dispatch_get_main_queue()

@interface SQServerManager ()

// activity indicator with label properties
@property (retain, nonatomic) UIView *messageFrame;
@property (retain, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) UILabel *strLabel;
@property (retain, nonatomic) UIViewController *mainVC;

// application parameters
@property (readwrite, strong, nonatomic) NSString *client_id;
@property (readwrite, strong, nonatomic) NSString *client_secret;
@property (readwrite, strong, nonatomic) NSString *redirect_uri;
@property (readwrite, strong, nonatomic) NSString *scope;

@end


@implementation SQServerManager

// parameters for authorization request
static NSString *authURL        = @"https://sequencing.com/oauth2/authorize";
static NSString *response_type  = @"code";

// parameters for token request
static NSString *tokenURL       = @"https://sequencing.com/oauth2/token";
static NSString *grant_type     = @"authorization_code";

// parameters for refresh token request
static NSString *refreshTokenURL    = @"https://sequencing.com/oauth2/token?q=oauth2/token";
static NSString *refreshGrant_type  = @"refresh_token";

// parameters for sample files request
static NSString *apiURL         = @"https://api.sequencing.com";
static NSString *demoPath       = @"/DataSourceList?sample=true";

// parameters for own files list request
static NSString *filesPath      = @"/DataSourceList?uploaded=true&shared=true";


+ (instancetype) sharedInstance {
    static SQServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SQServerManager alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.messageFrame = [UIView new];
        self.activityIndicator = [UIActivityIndicatorView new];
        self.strLabel = [UILabel new];
        self.mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    }
    return self;
}

- (void)registrateParametersCliendID:(NSString *)client_id
                        ClientSecret:(NSString *)client_secret
                         RedirectUri:(NSString *)redirect_uri
                               Scope:(NSString *)scope {
    self.client_id = client_id;
    self.client_secret = client_secret;
    self.redirect_uri = redirect_uri;
    self.scope = scope;
    [[SQRequestHelper sharedInstance] rememberRedirectUri:redirect_uri];
}


#pragma mark - 
#pragma mark Request fuctions

- (void)authorizeUser:(void (^)(SQAuthResult *))completion {
    NSString *randomState = [self randomStringWithLength:[self randomInt]];
    
    NSString *client_id_upd = [self.client_id stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSString *urlString = [NSString stringWithFormat:
                           @"%@?"
                           "redirect_uri=%@&"
                           "response_type=%@&"
                           "state=%@&"
                           "client_id=%@&"
                           "scope=%@",
                           authURL, self.redirect_uri, response_type, randomState, client_id_upd, self.scope];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // ===== authorizing user request =====
    SQLoginViewController *loginViewController =
    [[SQLoginViewController alloc] initWithURL:(NSURL *)url andCompletionBlock:^(NSMutableDictionary *response) {
        if (response) {
            
            // first, must check if "state" from response matches "state" in request
            if (![[response objectForKey:@"state"] isEqualToString:randomState]) {
                NSLog(@"state mismatch, response is being spoofed");
                if (completion) {
                    [[SQAuthResult sharedInstance] setIsAuthorized:NO];
                    completion([SQAuthResult sharedInstance]);
                }
            } else {
                
                // state matches - we can proceed with token request
                // ===== getting token request ======
                [self startActivityIndicatorWithTitle:@"Authorizing user"];
                [self postForTokenWithCode:[response objectForKey:@"code"] onSuccess:^(SQToken *token) {
                    if (token) {
                        [self stopActivityIndicator];
                        [[SQAuthResult sharedInstance] setToken:token];
                        [[SQAuthResult sharedInstance] setIsAuthorized:YES];
                        [[SQTokenUpdater sharedInstance] cancelTimer];
                        // THIS WILL START TIMER TO AUTOMATICALLY REFRESH ACCESS_TOKEN WHEN IT'S EXPIRED
                        [[SQTokenUpdater sharedInstance] startTimer];
                        completion([SQAuthResult sharedInstance]);
                    } else {
                        if (completion) {
                            [self stopActivityIndicator];
                            [[SQAuthResult sharedInstance] setIsAuthorized:NO];
                            completion([SQAuthResult sharedInstance]);
                        }
                    }
                } onFailure:^(NSError *error) {
                    NSLog(@"error = %@", [error localizedDescription]);
                    if (completion) {
                        [self stopActivityIndicator];
                        [[SQAuthResult sharedInstance] setIsAuthorized:NO];
                        completion([SQAuthResult sharedInstance]);
                    }
                }];
            }
        } else if (completion) {
            [self stopActivityIndicator];
            [[SQAuthResult sharedInstance] setIsAuthorized:NO];
            completion([SQAuthResult sharedInstance]);
        }
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    UIViewController *mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    [mainVC presentViewController:nav
                         animated:YES
                       completion:nil];
}


- (void)postForTokenWithCode:(NSString *)code
                   onSuccess:(void(^)(SQToken *token))success
                   onFailure:(void(^)(NSError *error))failure {
    NSDictionary *postParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                            grant_type, @"grant_type",
                            code, @"code",
                            self.redirect_uri, @"redirect_uri", nil];
    [SQHttpHelper execHttpRequestWithUrl:tokenURL
                             andMethod:@"POST"
                            andHeaders:nil
                           andUsername:self.client_id
                           andPassword:self.client_secret
                              andToken:nil
                          andAuthScope:@"Basic"
                         andParameters:postParameters
                            andHandler:^(NSString* responseText, NSURLResponse* response, NSError* error) {
        if (response) {
            NSError *jsonError;
            NSData *jsonData = [responseText dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                         options:0
                                                                           error:&jsonError];
            if (jsonError != nil) {
                if (success) {
                    success(nil);
                }
            } else {
                SQToken *token = [SQToken new];
                token.accessToken = [parsedObject objectForKey:@"access_token"];
                NSTimeInterval interval = [[parsedObject objectForKey:@"expires_in"] doubleValue] - 600;
                token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                token.tokenType = [parsedObject objectForKey:@"token_type"];
                token.scope = [parsedObject objectForKey:@"scope"];
                token.refreshToken = [parsedObject objectForKey:@"refresh_token"];
                if (success) {
                    success(token);
                }
            }
        } else if (failure) {
            failure(error);
        }
    }];
}

- (void)postForNewTokenWithRefreshToken:(SQToken *)token
                              onSuccess:(void(^)(SQToken *updatedToken))success
                              onFailure:(void(^)(NSError *error))failure {
    NSDictionary *postParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    refreshGrant_type,  @"grant_type",
                                    token.refreshToken, @"refresh_token", nil];
    [SQHttpHelper execHttpRequestWithUrl:refreshTokenURL
                             andMethod:@"POST"
                            andHeaders:nil
                           andUsername:self.client_id
                           andPassword:self.client_secret
                              andToken:nil
                          andAuthScope:@"Basic"
                         andParameters:postParameters
                            andHandler:^(NSString* responseText, NSURLResponse* response, NSError* error) {
                                if (response) {
                                    NSError *jsonError;
                                    NSData *jsonData = [responseText dataUsingEncoding:NSUTF8StringEncoding];
                                    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                                 options:0
                                                                                                   error:&jsonError];
                                    if (jsonError != nil) {
                                        if (success) {
                                            success(nil);
                                        }
                                    } else {
                                        SQToken *token = [SQToken new];
                                        token.accessToken = [parsedObject objectForKey:@"access_token"];
                                        NSTimeInterval interval = [[parsedObject objectForKey:@"expires_in"] doubleValue] - 600;
                                        token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                                        token.tokenType = [parsedObject objectForKey:@"token_type"];
                                        token.scope = [parsedObject objectForKey:@"scope"];
                                        if (success) {
                                            success(token);
                                        }
                                    }
                                } else if (failure) {
                                    failure(error);
                                }
                            }];
}

- (void)getForSampleFilesWithToken:(SQToken *)token
                      onSuccess:(void(^)(NSArray *))success
                      onFailure:(void(^)(NSError *))failure {
    NSString *apiUrlForDemo = [[NSString alloc] initWithFormat:@"%@%@", apiURL, demoPath];
    [SQHttpHelper execHttpRequestWithUrl:apiUrlForDemo
                             andMethod:@"GET"
                            andHeaders:nil
                           andUsername:nil
                           andPassword:nil
                              andToken:token.accessToken
                          andAuthScope:@"Bearer"
                         andParameters:nil
                            andHandler:^(NSString* responseText, NSURLResponse* response, NSError* error) {
                                if (response) {
                                    NSError *jsonError;
                                    NSData *jsonData = [responseText dataUsingEncoding:NSUTF8StringEncoding];
                                    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                                 options:0
                                                                                                   error:&jsonError];
                                    if (jsonError != nil) {
                                        NSLog(@"Error: %@", jsonError);
                                        if (success) {
                                            success(nil);
                                        }
                                    } else {
                                        if (success) {
                                            success(parsedObject);
                                        }
                                    }
                                } else if (failure) {
                                    failure(error);
                                }
                            }];
}

- (void)getForOwnFilesWithToken:(SQToken *)token
                      onSuccess:(void (^)(NSArray *))success
                      onFailure:(void (^)(NSError *))failure {
    NSString *apiUrlForFiles = [[NSString alloc] initWithFormat:@"%@%@", apiURL, filesPath];
    [SQHttpHelper execHttpRequestWithUrl:apiUrlForFiles
                             andMethod:@"GET"
                            andHeaders:nil
                           andUsername:nil
                           andPassword:nil
                              andToken:token.accessToken
                          andAuthScope:@"Bearer"
                         andParameters:nil
                            andHandler:^(NSString* responseText, NSURLResponse* response, NSError* error) {
                                if (response) {
                                    NSError *jsonError;
                                    NSData *jsonData = [responseText dataUsingEncoding:NSUTF8StringEncoding];
                                    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                            options:0
                                                                                              error:&jsonError];
                                    if (jsonError != nil) {
                                        NSLog(@"Error: %@", jsonError);
                                        if (success) {
                                            success(nil);
                                        }
                                    } else {
                                        if (success) {
                                            success(parsedObject);
                                        }
                                    }
                                } else if (failure) {
                                    failure(error);
                                }
                            }];
}


#pragma mark -
#pragma mark Request helpers

- (int)randomInt {
    return arc4random_uniform(100);
}

- (NSString *)randomStringWithLength:(int)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: (NSUInteger) arc4random_uniform((u_int32_t)[letters length])]];
    }
    return randomString;
}


#pragma mark -
#pragma mark Activity indicator

- (void)startActivityIndicatorWithTitle:(NSString *)title {
    dispatch_async(kMainQueue, ^{
        self.strLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 150, 50)];
        self.strLabel.text = title;
        self.strLabel.textColor = [UIColor grayColor];
        
        CGFloat xPos = self.mainVC.view.frame.size.width / 2 - 100;
        CGFloat yPos = self.mainVC.view.frame.size.height / 2 - 25;
        self.messageFrame = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, 250, 40)];
        self.messageFrame.layer.cornerRadius = 15;
        self.messageFrame.backgroundColor = [UIColor clearColor];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.frame = CGRectMake(0, 0, 50, 50);
        [self.activityIndicator startAnimating];
        
        [self.messageFrame addSubview:self.activityIndicator];
        [self.messageFrame addSubview:self.strLabel];
        [self.mainVC.view addSubview:self.messageFrame];
    });
}

- (void)stopActivityIndicator {
    dispatch_async(kMainQueue, ^{
        [self.activityIndicator stopAnimating];
        [self.messageFrame removeFromSuperview];
    });
}

@end
