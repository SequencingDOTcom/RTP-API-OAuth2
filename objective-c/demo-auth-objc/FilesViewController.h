//
//  FilesViewController.h
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

#import <UIKit/UIKit.h>

@interface FilesViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *fileTypeSelected;

@end
