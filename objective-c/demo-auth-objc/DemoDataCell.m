//
//  DemoDataCell.m
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

#import "DemoDataCell.h"

@implementation DemoDataCell

+ (CGFloat)heightForRow:(NSString *)text {
    UIFont *font = [UIFont systemFontOfSize:13.f];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                paragraph, NSParagraphStyleAttributeName,
                                shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(280, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    
    
    
    if (CGRectGetHeight(rect) < 42.960938f) {
        return 43.0f;
    } else {
        return CGRectGetHeight(rect) + 15;
    }
}



+ (NSString *)prepareText:(NSDictionary *)demoText {
    NSMutableString *preparedText = [[NSMutableString alloc] init];
    NSArray *keys = [NSArray arrayWithArray:[demoText allKeys]];
    NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString *key in sortedKeys) {
        id obj = [demoText objectForKey:key];
        NSString *tempString = [NSString stringWithFormat:@"%@: %@\n", key, obj];
        [preparedText appendString:tempString];
    }
    
    return preparedText;
}

+ (NSString *)prepareTextFromFile:(NSDictionary *)text AndFileType:(NSString *)fileType {
    NSMutableString *preparedText = [[NSMutableString alloc] init];
    
    if ([fileType containsString:@"Sample"]) {
        // working with sample file type
        NSString *friendlyDesk1 = [text objectForKey:@"FriendlyDesc1"];
        NSString *friendlyDesk2 = [text objectForKey:@"FriendlyDesc2"];
        NSString *tempString = [NSString stringWithFormat:@"%@\n%@", friendlyDesk1, friendlyDesk2];
        [preparedText appendString:tempString];
        
    } else {
        // working with own file type
        NSString *filename = [text objectForKey:@"Name"];
        NSString *tempString = [NSString stringWithFormat:@"%@", filename];
        [preparedText appendString:tempString];
        
    }
    
    return preparedText;
}

@end
