//
//  DemoDataCell.h
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

#import <UIKit/UIKit.h>

@interface DemoDataCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *demoTextLabel;

+ (CGFloat)heightForRow:(NSString *)text;
+ (NSString *)prepareText:(NSDictionary *)text;
+ (NSString *)prepareTextFromFile:(NSDictionary *)text AndFileType:(NSString *)fileType;

@end
