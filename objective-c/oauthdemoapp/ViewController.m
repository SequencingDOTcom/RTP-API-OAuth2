//
//  ViewController.m
//  oauthdemoapp
//

#import "ViewController.h"
#import "ServerManager.h"
#import "Token.h"

#define kMainQueue dispatch_get_main_queue()
#define MY_CUSTOM_TAG 1234

@interface ViewController ()

@property (strong, nonatomic) NSArray *demoDataArray;
@property (strong, nonatomic) UIBarButtonItem *loginButton;
@property (strong, nonatomic) Token *token;

@end


@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        self.token = [Token new];
        self.demoDataArray = [[NSArray alloc] init];
        self.tableView.tag = MY_CUSTOM_TAG;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // add login button
    self.loginButton = [[UIBarButtonItem alloc] initWithTitle:@"login"
                                                        style:UIBarButtonItemStyleDone
                                                       target:self
                                                       action:@selector(loginButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:self.loginButton animated:YES];
    
    // set title
    self.title = @"OAuthApp demo";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (void)loginButtonPressed:(UIButton *)button {
    [[ServerManager sharedInstance] authorizeUser:^(NSArray *data) {
        self.demoDataArray = data;
        NSLog(@"%@", self.demoDataArray);
        
        dispatch_async(kMainQueue, ^{
            [self.tableView reloadData];
        });
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.demoDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.textLabel.text = [[self.demoDataArray objectAtIndex:indexPath.row] objectForKey:@"FriendlyDesc2"];
    
    return cell;
}




@end
