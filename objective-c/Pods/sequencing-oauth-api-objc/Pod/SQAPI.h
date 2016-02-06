//
//  SQAPI.h
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

#import <Foundation/Foundation.h>
#import "SQAuthResult.h"
#import "SQToken.h"

@interface SQAPI : NSObject

// designated initializer
+ (instancetype)sharedInstance;

// load own files method
- (void)loadOwnFiles:(void(^)(NSArray *myFiles))files;

// load sample files method
- (void)loadSampleFiles:(void(^)(NSArray *sampleFiles))files;

@end
