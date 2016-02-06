//
//  SQServerManager.h
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

#import <Foundation/Foundation.h>

@class SQAuthResult;
@class SQToken;

@interface SQServerManager : NSObject

+ (instancetype)sharedInstance;     //designated initializer

- (void)registrateParametersCliendID:(NSString *)client_id
                        ClientSecret:(NSString *)client_secret
                         RedirectUri:(NSString *)redirect_uri
                               Scope:(NSString *)scope;

- (void)authorizeUser:(void(^)(SQAuthResult *authResult))result;

- (void)postForNewTokenWithRefreshToken:(SQToken *)token
                              onSuccess:(void(^)(SQToken *updatedToken))success
                              onFailure:(void(^)(NSError *error))failure;

- (void)getForSampleFilesWithToken:(SQToken *)token
                         onSuccess:(void(^)(NSArray *sampleFilesList))success
                         onFailure:(void(^)(NSError *error))failure;

- (void)getForOwnFilesWithToken:(SQToken *)token
                      onSuccess:(void(^)(NSArray *ownFilesList))success
                      onFailure:(void(^)(NSError *error))failure;

- (void)startActivityIndicatorWithTitle:(NSString *)title;

- (void)stopActivityIndicator;


@end
