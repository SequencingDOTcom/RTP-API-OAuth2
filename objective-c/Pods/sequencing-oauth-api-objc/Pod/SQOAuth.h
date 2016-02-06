//
//  SQOAuth.h
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

#import <Foundation/Foundation.h>
#import "SQAuthResult.h"
#import "SQToken.h"

@class SQAuthResult;
@class SQToken;

@interface SQOAuth : NSObject

// designated initializer
+ (instancetype)sharedInstance;

// method to set up allication registration parameters
- (void)registrateApplicationParametersCliendID:(NSString *)client_id
                                   ClientSecret:(NSString *)client_secret
                                    RedirectUri:(NSString *)redirect_uri
                                          Scope:(NSString *)scope;

// authorization method that return authResult object (include token within)
- (void)authorizeUser:(void(^)(SQAuthResult *result))result;

// authorization method that return token object directly
- (void)authorizeUserAndGetToken:(void (^)(SQToken *token))result;

@end
