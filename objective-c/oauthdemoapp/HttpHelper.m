//
//  HttpHelper.m
//  SqliteStompConnector
//

#import "HttpHelper.h"

@implementation HttpHelper

+ (void)execHttpRequestWithUrl:(NSString *)url
                     andMethod:(NSString *)method
                    andHeaders:(NSDictionary *)headers
                   andUsername:(NSString *)username
                   andPassword:(NSString *)password
                   andToken:(NSString *)token
                  andAuthScope:(NSString *)authScope
                 andParameters:(NSDictionary *)parameters
                    andHandler:(HttpCallback)callback {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:method];
    
    for (NSString *key in headers)
        [request addValue:[headers valueForKey:key] forHTTPHeaderField:key];
    
    if ([authScope isEqualToString:@"Basic"])
    {
        NSData *authData = [[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"%@ %@", authScope, [authData base64EncodedStringWithOptions:0]];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    }
    else if ([authScope isEqualToString:@"Bearer"])
    {
        NSString *authValue = [NSString stringWithFormat:@"%@ %@", authScope, token];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    }
    
    if (parameters)
        [request setHTTPBody:[[parameters urlEncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setTimeoutInterval:10];
    [request setHTTPShouldHandleCookies:NO];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        callback([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], response, error);
    }];
    
    [dataTask resume];
}

static NSString *toString(id object) {
    return [NSString stringWithFormat: @"%@", object];
}

// helper function: get the url encoded string form of any object
static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}
@end

@implementation NSDictionary (UrlEncoding)

- (NSString *)urlEncodedString {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self) {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

@end
