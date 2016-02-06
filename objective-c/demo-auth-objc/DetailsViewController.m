//
//  DetailsViewController.m
//  Copyright © 2015-2016 Sequencing.com
//

#import "DetailsViewController.h"
#import "DemoDataCell.h"

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"File details";
    
    self.fileDetails.lineBreakMode = NSLineBreakByWordWrapping;
    self.fileDetails.numberOfLines = 0;
    
    self.fileDetails.text = [DemoDataCell prepareText:self.nowSelectedFile];
    NSLog(@"%@", self.fileDetails.text);
    [self.fileDetails sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
