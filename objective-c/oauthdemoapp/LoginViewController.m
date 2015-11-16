//
//  LoginViewController.m
//  oauthdemoapp
//

#import "LoginViewController.h"

@interface LoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) LoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSURL *url;

@end

@implementation LoginViewController

- (id)initWithURL:(NSURL *)url andCompletionBlock:(LoginCompletionBlock)completionBlock {
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // add webView container
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:rect];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:webView];
    self.webView = webView;
    
    // add cancel button for viewController
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(actionCancel:)];
    [self.navigationItem setRightBarButtonItem:cancelButton animated:YES];
    
    // add activity indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.titleView = self.activityIndicator;
    
    // open login page from url with params 
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    webView.delegate = self;
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.webView.delegate = nil;
}


#pragma mark - Actions

- (void)actionCancel:(UIBarButtonItem *)sender {
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    
    // put here some variations to close current webView depending on the way it was shown
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // NSLog(@"%@", [request URL]);
    if ([[NSString stringWithFormat:@"%@", [request URL]] containsString:@"authapp://Default/Authcallback?"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSString *query = [[request URL] description];
        NSArray *array = [query componentsSeparatedByString:@"?"];
        if ([array count] > 1) {
            query = [array lastObject];
        }
        NSArray *params = [query componentsSeparatedByString:@"&"];
        for (NSString *param in params) {
            NSArray *elements = [param componentsSeparatedByString:@"="];
            if ([elements count] == 2) {
                NSString *key = [[elements firstObject] stringByRemovingPercentEncoding];
                NSString *val = [[elements lastObject] stringByRemovingPercentEncoding];
                [dict setObject:val forKey:key];
            }
        }
        
        self.webView.delegate = nil;
        if (self.completionBlock) {
            self.completionBlock(dict);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [self.activityIndicator stopAnimating];
}

@end
