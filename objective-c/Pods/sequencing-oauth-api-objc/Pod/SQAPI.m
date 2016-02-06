//
//  SQAPI.h
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

#import "SQAPI.h"
#import "SQServerManager.h"

@implementation SQAPI

+ (instancetype)sharedInstance {
    static SQAPI *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SQAPI alloc] init];
    });
    return instance;
}

#pragma mark -
#pragma mark API methods

- (void)loadOwnFiles:(void (^)(NSArray *))files {
    [[SQServerManager sharedInstance] getForOwnFilesWithToken:[[SQAuthResult sharedInstance] token] onSuccess:^(NSArray *ownFilesList) {
        if (ownFilesList) {
            files(ownFilesList);
        }
    } onFailure:^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        files(nil);
    }];
}

- (void)loadSampleFiles:(void (^)(NSArray *))files {
    [[SQServerManager sharedInstance] getForSampleFilesWithToken:[[SQAuthResult sharedInstance] token] onSuccess:^(NSArray *sampleFilesList) {
        if (sampleFilesList) {
            files(sampleFilesList);
        }
    } onFailure:^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        files(nil);
    }];
}

@end
