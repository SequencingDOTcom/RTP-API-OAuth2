//
//  HttpHelper.h
//  SqliteStompConnector
//

#import <Foundation/Foundation.h>

typedef void (^HttpCallback)(NSString *responseText, NSURLResponse *response, NSError *error);

/**
 * Provides various functionality for accessing HTTP resources
 */

@interface HttpHelper : NSObject

+ (void)execHttpRequestWithUrl:(NSString *)url
                     andMethod:(NSString *)method
                    andHeaders:(NSDictionary *)headers
                   andUsername:(NSString *)username
                   andPassword:(NSString *)password
                      andToken:(NSString *)token
                  andAuthScope:(NSString *)authScope
                 andParameters:(NSDictionary *)parameters
                    andHandler:(HttpCallback)callback;
@end

@interface NSDictionary (UrlEncoding)
- (NSString *)urlEncodedString;
@end
