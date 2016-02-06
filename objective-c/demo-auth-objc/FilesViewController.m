//
//  FilesViewController.m
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

#import "FilesViewController.h"
#import "SQAPI.h"
#import "DemoDataCell.h"
#import "DetailsViewController.h"

#define kMainQueue dispatch_get_main_queue()
static NSString *const FILE_DETAILS_CONTROLLER_SEGUE_ID = @"SHOW_DETAILS";

@interface FilesViewController ()

@property (strong, nonatomic) UIBarButtonItem *showDetailsButton;
@property (strong, nonatomic) UIView        *segmentView;

// files source
@property (strong, nonatomic) NSArray       *filesArray;
@property (strong, nonatomic) NSArray       *sampleFilesArray;
@property (strong, nonatomic) NSArray       *ownFilesArray;

// file type selection and row selection
@property (strong, nonatomic) NSString      *nowSelectedFileType;
@property (strong, nonatomic) NSIndexPath   *nowSelectedFileIndexPath;

// activity indicator with label properties
@property (retain, nonatomic) UIView            *messageFrame;
@property (retain, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) UILabel           *strLabel;
@property (retain, nonatomic) UIViewController  *mainVC;

@end


@implementation FilesViewController

- (id)init {
    self = [super init];
    if (self) {
        self.filesArray = [[NSArray alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Select file";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView setEditing:YES animated:YES];
    
    
    // add login button
    self.showDetailsButton = [[UIBarButtonItem alloc] initWithTitle:@"Details"
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:@selector(showDetails)];
    [self.navigationItem setRightBarButtonItem:self.showDetailsButton animated:YES];
    self.showDetailsButton.enabled = NO;
    
    // Segmented Control init
    UISegmentedControl *fileTypeSelect = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"My files", @"Sample files", nil]];
    [fileTypeSelect addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    [fileTypeSelect sizeToFit];
    self.navigationItem.titleView = fileTypeSelect;
    // [(CustomNavigationBar *)self.navigationController.navigationBar setCustomSegmentedControl:fileTypeSelect];
    
    // select related segmentedIndex and load sample/own files
    if ([self.fileTypeSelected containsString:@"Sample"]) {
        fileTypeSelect.selectedSegmentIndex = 1;
        self.nowSelectedFileType = @"Sample";
        [self loadSampleFiles];
    } else {
        fileTypeSelect.selectedSegmentIndex = 0;
        self.nowSelectedFileType = @"My";
        [self loadOwnFiles];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Actions

- (void)segmentControlAction:(UISegmentedControl *)sender {
    self.nowSelectedFileIndexPath = nil;
    self.filesArray = nil;
    [self.tableView reloadData];
    
    if (sender.selectedSegmentIndex == 1) {
        self.nowSelectedFileType = @"Sample";
        if (self.sampleFilesArray != nil) {
            self.filesArray = self.sampleFilesArray;
            [self reloadTableDataWithAnimation];
        } else {
            [self loadSampleFiles];
        }
        
    } else {
        self.nowSelectedFileType = @"My";
        if (self.ownFilesArray != nil) {
            self.filesArray = self.ownFilesArray;
            [self reloadTableDataWithAnimation];
        } else {
            [self loadOwnFiles];
        }
    }
}


#pragma mark -
#pragma mark TableView source methods

- (void)loadSampleFiles {
    [self startActivityIndicatorWithTitle:@"Loading sample files."];
    
    [[SQAPI sharedInstance] loadSampleFiles:^(NSArray *sampleFiles) {
        dispatch_async(kMainQueue, ^{
            if (sampleFiles) {
                self.sampleFilesArray = sampleFiles;
                self.filesArray = self.sampleFilesArray;
                [self stopActivityIndicator];
                [self reloadTableDataWithAnimation];
            } else {
                [self stopActivityIndicator];
                [self showAlertWithMessage:(NSString *)@"Can't load sample files"];
            }
        });
    }];
}

- (void)loadOwnFiles {
    [self startActivityIndicatorWithTitle:@"Loading own files."];
    [[SQAPI sharedInstance] loadOwnFiles:^(NSArray *myFiles) {
        dispatch_async(kMainQueue, ^{
            if (myFiles) {
                self.ownFilesArray = myFiles;
                self.filesArray = self.ownFilesArray;
                [self stopActivityIndicator];
                [self reloadTableDataWithAnimation];
            } else {
                [self stopActivityIndicator];
                [self showAlertWithMessage:@"Can't load own files"];
            }
        });
    }];
}


#pragma mark -
#pragma mark TableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static DemoDataCell *cell = nil;
    static dispatch_once_t onceToken;
    static NSString *identifier = @"cell";
    
    dispatch_once(&onceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    });
    
    NSDictionary *demoText = [self.filesArray objectAtIndex:indexPath.row];
    NSString *text = [DemoDataCell prepareTextFromFile:demoText AndFileType:self.nowSelectedFileType];
    cell.demoTextLabel.text = text;
    cell.demoTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // return [self calculateHeightForConfiguredSizingCell:cell];
    
    return [DemoDataCell heightForRow:text];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    DemoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSDictionary *demoText = [self.filesArray objectAtIndex:indexPath.row];
    NSString *text = [DemoDataCell prepareTextFromFile:demoText AndFileType:self.nowSelectedFileType];
    
    cell.demoTextLabel.text = text;
    cell.demoTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.tintColor = [UIColor blueColor];
    
    return cell;
}

- (void)reloadTableDataWithAnimation {
    NSMutableArray *newPaths = [NSMutableArray array];
    for (int i = 0; i < [self.filesArray count]; i++) {
        [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}


#pragma mark -
#pragma mark Cells selection

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 3;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.nowSelectedFileIndexPath == nil) {
        self.nowSelectedFileIndexPath = indexPath;
    } else {
        if (self.nowSelectedFileIndexPath != indexPath) {
            [self.tableView deselectRowAtIndexPath:self.nowSelectedFileIndexPath animated:YES];
            self.nowSelectedFileIndexPath = indexPath;
        }
    }
    self.showDetailsButton.enabled = YES;
    // [self.tableView indexPathsForSelectedRows];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.nowSelectedFileIndexPath = nil;
    self.showDetailsButton.enabled = NO;
}


#pragma mark -
#pragma mark Navigation

- (void)showDetails {
    [self performSegueWithIdentifier:FILE_DETAILS_CONTROLLER_SEGUE_ID sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)indexPath {
    
    if ([segue.destinationViewController isKindOfClass:[DetailsViewController class]]) {
        [[segue destinationViewController] setNowSelectedFile:[self.filesArray objectAtIndex:self.nowSelectedFileIndexPath.row]];
    }
}


#pragma mark -
#pragma mark Activity Indicator

- (void)startActivityIndicatorWithTitle:(NSString *)title {
    dispatch_async(kMainQueue, ^{
        self.strLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 150, 50)];
        [self.strLabel setFont:[UIFont systemFontOfSize:12]];
        self.strLabel.text = title;
        self.strLabel.textColor = [UIColor grayColor];
        
        CGFloat xPos = self.tableView.frame.size.width / 2 - 100;
        CGFloat yPos = self.tableView.frame.size.height / 2 - 100;
        self.messageFrame = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, 250, 40)];
        self.messageFrame.layer.cornerRadius = 18;
        self.messageFrame.backgroundColor = [UIColor clearColor];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.frame = CGRectMake(0, 0, 50, 50);
        [self.activityIndicator startAnimating];
        
        [self.messageFrame addSubview:self.activityIndicator];
        [self.messageFrame addSubview:self.strLabel];
        [self.tableView addSubview:self.messageFrame];
    });
}

- (void)stopActivityIndicator {
    dispatch_async(kMainQueue, ^{
        [self.activityIndicator stopAnimating];
        [self.messageFrame removeFromSuperview];
    });
}


#pragma mark -
#pragma mark Alert message

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *close = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:close];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
