//
//  ViewController.m
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

#import "StartViewController.h"
#import "FilesViewController.h"

// ADD THIS IMPORT
#import "SQOAuth.h"

// IMPORT THESE CLASSES IF YOU WANT TO USE TOKEN MANUALLY IN YOUR CODE
// #import "AuthResult.h" // AuthResult it's a singleton class that contains up-to-date token
// #import "Token.h"

// THESE ARE APPLICATION PARAMETERS (from App Registration - https://sequencing.com/developer-documentation/app-registration)
// SPECIFY THEM HERE
static NSString *const CLIENT_ID        = @"oAuth2 Demo ObjectiveC";
static NSString *const CLIENT_SECRET    = @"RZw8FcGerU9e1hvS5E-iuMb8j8Qa9cxI-0vfXnVRGaMvMT3TcvJme-Pnmr635IoE434KXAjelp47BcWsCrhk0g";
static NSString *const REDIRECT_URI     = @"authapp://Default/Authcallback";
static NSString *const SCOPE            = @"demo";

#define kMainQueue dispatch_get_main_queue()
static NSString *const FILES_CONTROLLER_SEGUE_ID = @"GET_FILES";


@interface StartViewController ()

@property (strong, nonatomic) UIBarButtonItem *loginButton;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // REGISTER APPLICATION PARAMETERS
    [[SQOAuth sharedInstance] registrateApplicationParametersCliendID:CLIENT_ID
                                                         ClientSecret:CLIENT_SECRET
                                                          RedirectUri:REDIRECT_URI
                                                                Scope:SCOPE];
    
    // add login button
    self.loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                        style:UIBarButtonItemStyleDone
                                                       target:self
                                                       action:@selector(loginButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:self.loginButton animated:YES];
    
    self.title = @"OAuthApp demo";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Actions

- (void)loginButtonPressed:(UIButton *)button {
    
    [[SQOAuth sharedInstance] authorizeUser:^(SQAuthResult *result) {
        dispatch_async(kMainQueue, ^{
            if (result) {
                self.loginButton.title = @"Logout";
                
                UIButton *buttonSample = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [buttonSample setTitle:@"My files" forState:UIControlStateNormal];
                [buttonSample sizeToFit];
                buttonSample.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 - 20);
                [buttonSample addTarget:self action:@selector(GetFiles:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:buttonSample];
                
                UIButton *buttonOwn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [buttonOwn setTitle:@"Sample files" forState:UIControlStateNormal];
                [buttonOwn sizeToFit];
                buttonOwn.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 + 20);
                [buttonOwn addTarget:self action:@selector(GetFiles:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:buttonOwn];
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Authorization"
                                                                               message:@"Can't authorize user"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *close = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:close];
                [self presentViewController:alert animated:YES completion:nil];
            };
        });
    }];
}


#pragma mark -
#pragma mark Navigation

- (void)GetFiles:(UIButton *)sender {
    [self performSegueWithIdentifier:FILES_CONTROLLER_SEGUE_ID sender:sender.titleLabel.text];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[FilesViewController class]]) {
        [segue.destinationViewController setFileTypeSelected:sender];
    }
}

@end
