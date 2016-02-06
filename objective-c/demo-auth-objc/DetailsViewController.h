//
//  DetailsViewController.h
//  Copyright © 2015-2016 Sequencing.com
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *fileDetails;
@property (strong, nonatomic) NSString      *nowSelectedFileType;
@property (strong, nonatomic) NSDictionary  *nowSelectedFile;

@end
