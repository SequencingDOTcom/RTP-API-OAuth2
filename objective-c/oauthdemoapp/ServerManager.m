//
//  ServerManager.m
//  oauthdemoapp
//

#import "ServerManager.h"
#import "LoginViewController.h"
#import "Token.h"
#import "HttpHelper.h"

@interface ServerManager ()

// @property (strong, nonatomic) Token *token;

@end

@implementation ServerManager

// parameters for authorization request
static NSString *authURL        = @"https://sequencing.com/oauth2/authorize";
static NSString *redirect_uri   = @"authapp://Default/Authcallback";
static NSString *response_type  = @"code";
static NSString *state          = @"statecodecallbackmd5";
static NSString *clientID       = @"oAuth2 Demo ObjectiveC";
static NSString *scope          = @"demo";

// parameters for token request
static NSString *tokenURL       = @"https://sequencing.com/oauth2/token";
static NSString *client_secret  = @"RZw8FcGerU9e1hvS5E-iuMb8j8Qa9cxI-0vfXnVRGaMvMT3TcvJme-Pnmr635IoE434KXAjelp47BcWsCrhk0g";
static NSString *grant_type     = @"authorization_code";
static NSString *redirect_uritk = @"https://objectivec-oauth-demo.sequencing.com/Default/Authcallback";

// parameters for demo data request
static NSString *apiURL         = @"https://api.sequencing.com";
static NSString *demoPath       = @"/DataSourceList?sample=true";


+ (ServerManager *) sharedInstance {
    static ServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        //self.token = [Token new];
    }
    return self;
}

- (void)authorizeUser:(void(^)(NSArray *data))completion {
    
    NSString *client_id = [clientID stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSString *urlString = [NSString stringWithFormat:
                           @"%@?"
                           "redirect_uri=%@&"
                           "response_type=%@&"
                           "state=%@&"
                           "client_id=%@&"
                           "scope=%@",
                           authURL, redirect_uri, response_type, state, client_id, scope];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(@"===== 1st request (authorize user) =====");
    
    LoginViewController *loginViewController =
    [[LoginViewController alloc] initWithURL:(NSURL *)url andCompletionBlock:^(NSMutableDictionary *response) {
        if (response) {
            // NSLog(@"response %@", response);
            
            // first, must check if "state" from response matches "state" in request
            if (![[response objectForKey:@"state"] isEqualToString:state]) {
                NSLog(@"state mismatch, response is being spoofed");
                if (completion) {
                    completion(nil);
                }
            } else {
                
                // state matches - we can proceed with token request
                NSLog(@"===== 2nd request (getting token) =====");
    
                [self postForTokenWithCode:[response objectForKey:@"code"] onSuccess:^(Token *token) {
                    if (token) {
                        
                        NSLog(@"=== 3rd request (getting demo data) ===");
                        [self getForDemoDataWithToken:token onSuccess:^(NSArray *demoData) {
                            // NSLog(@"demodata: %@", demoData);
                            if (completion) {
                                completion(demoData);
                            }
                        } onFailure:^(NSError *error) {
                            NSLog(@"error: %@", error);
                            if (completion) {
                                completion(nil);
                            }
                        }];
                    } else {
                        if (completion) {
                            completion(nil);
                        }
                    }
                } onFailure:^(NSError *error) {
                    NSLog(@"error = %@", [error localizedDescription]);
                    if (completion) {
                        completion(nil);
                    }
                }];
            }
        } else if (completion) {
            completion(nil);
        }
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    UIViewController *mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    [mainVC presentViewController:nav
                         animated:YES
                       completion:nil];
}

- (void)postForTokenWithCode:(NSString *)code
                   onSuccess:(void(^)(Token *token))success
                   onFailure:(void(^)(NSError *error))failure {

    NSDictionary *postParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                            grant_type,     @"grant_type",
                            code,           @"code",
                            redirect_uri,   @"redirect_uri", nil];
    
    [HttpHelper execHttpRequestWithUrl:tokenURL
                             andMethod:@"POST"
                            andHeaders:nil
                           andUsername:clientID
                           andPassword:client_secret
                              andToken:nil
                          andAuthScope:@"Basic"
                         andParameters:postParameters
                            andHandler:^(NSString* responseText, NSURLResponse* response, NSError* error) {
        if (response) {
            // NSLog(@"response text: %@", responseText);
            NSError *jsonError;
            NSData *jsonData = [responseText dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                         options:0
                                                                           error:&jsonError];
            if (jsonError != nil) {
                // NSLog(@"Error: %@", jsonError);
                if (success) {
                    success(nil);
                }
            } else {
                // NSLog(@"%@", parsedObject);
                Token *token = [Token new];
                token.accessToken = [parsedObject objectForKey:@"access_token"];
                NSTimeInterval interval = [[parsedObject objectForKey:@"access_token"] doubleValue];
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

- (void)getForDemoDataWithToken:(Token *)token
                      onSuccess:(void(^)(NSArray *demoData))success
                      onFailure:(void(^)(NSError *error))failure {
    
    NSString *apiUrlForDemo = [[NSString alloc] initWithFormat:@"%@%@", apiURL, demoPath];
    
    [HttpHelper execHttpRequestWithUrl:apiUrlForDemo
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



@end
