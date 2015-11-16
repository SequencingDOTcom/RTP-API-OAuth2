//
//  Token.h
//  oauthdemoapp
//

#import <Foundation/Foundation.h>

@interface Token : NSObject

@property (strong, nonatomic) NSString  *accessToken;
@property (strong, nonatomic) NSDate    *expirationDate;
@property (strong, nonatomic) NSString  *tokenType;
@property (strong, nonatomic) NSString  *scope;
@property (strong, nonatomic) NSString  *refreshToken;

@end
