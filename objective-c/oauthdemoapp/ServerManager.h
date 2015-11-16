//
//  ServerManager.h
//  oauthdemoapp
//

#import <Foundation/Foundation.h>

@class Token;

@interface ServerManager : NSObject

+ (ServerManager *)sharedInstance;     //designated initializer

- (void)authorizeUser:(void(^)(NSArray *))completion;

- (void)getForDemoDataWithToken:(Token *)token
                      onSuccess:(void(^)(NSArray *demoData))success
                      onFailure:(void(^)(NSError *error))failure;


@end
