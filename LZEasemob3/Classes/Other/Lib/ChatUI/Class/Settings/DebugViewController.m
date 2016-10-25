/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "DebugViewController.h"

@interface DebugViewController ()

@end

@implementation DebugViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"title.debug", @"Debug");
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    footerView.backgroundColor = [UIColor clearColor];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, footerView.frame.size.width - 10, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [footerView addSubview:line];
    }
    
    UIButton *uploadLogButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, footerView.frame.size.width - 80, 40)];
    [uploadLogButton setBackgroundColor:[UIColor colorWithRed:87 / 255.0 green:186 / 255.0 blue:205 / 255.0 alpha:1.0]];
    [uploadLogButton setTitle:NSLocalizedString(@"setting.uploadLog", @"upload run log") forState:UIControlStateNormal];
    [uploadLogButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadLogButton addTarget:self action:@selector(uploadLogAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:uploadLogButton];
    self.tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = NSLocalizedString(@"setting.sdkVersion", @"SDK version");
        NSString *ver = [[EMClient sharedClient] version];
        cell.detailTextLabel.text = ver;
    }
    
    return cell;
}

#pragma mark - action

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadLogAction
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] uploadLogToServer];
    });
}

@end
