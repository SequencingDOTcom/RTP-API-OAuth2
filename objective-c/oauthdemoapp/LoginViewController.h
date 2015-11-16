//
//  LoginViewController.h
//  oauthdemoapp
//

#import <UIKit/UIKit.h>

typedef void(^LoginCompletionBlock)(NSMutableDictionary *response);

@interface LoginViewController : UIViewController

- (id)initWithURL:(NSURL *)url andCompletionBlock:(LoginCompletionBlock)completionBlock;

@end
