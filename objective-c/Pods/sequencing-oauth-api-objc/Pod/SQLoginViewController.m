//
//  SQLoginViewController.m
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

#import "SQLoginViewController.h"
#import "SQServerManager.h"
#import "SQRequestHelper.h"

@interface SQLoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) LoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSURL *url;

@end

@implementation SQLoginViewController

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
}

- (void)dealloc {
    self.webView.delegate = nil;
}


#pragma mark - 
#pragma mark Actions

- (void)actionCancel:(UIBarButtonItem *)sender {
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    // put here some variations to close current webView depending on the way it was shown
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[SQRequestHelper sharedInstance] verifyRequestForRedirectBack:request]) {
        self.webView.delegate = nil;
        if (self.completionBlock) {
            self.completionBlock([[SQRequestHelper sharedInstance] parseRequest:request]);
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
