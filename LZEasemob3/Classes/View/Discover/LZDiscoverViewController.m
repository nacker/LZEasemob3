//
//  LZDiscoverViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZDiscoverViewController.h"
#import "LZMomentsViewController.h"

@interface LZDiscoverViewController ()

@end

@implementation LZDiscoverViewController

static NSString * const CellIdentifier = @"DiscoverIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"朋友圈";
    cell.imageView.image = [UIImage imageNamed:@"ff_IconShowAlbum"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LZMomentsViewController *vc = [[LZMomentsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
