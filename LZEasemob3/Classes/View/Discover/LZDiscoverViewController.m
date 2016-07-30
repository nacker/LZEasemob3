//
//  LZDiscoverViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZDiscoverViewController.h"
#import "LZMomentsViewController.h"
#import "LZShakeViewController.h"

@interface LZDiscoverViewController ()

@end

@implementation LZDiscoverViewController

static NSString * const CellIdentifier = @"DiscoverIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.rowHeight = 46;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"朋友圈";
        cell.imageView.image = [UIImage imageNamed:@"ff_IconShowAlbum"];
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"摇一摇";
        cell.imageView.image = [UIImage imageNamed:@"ff_IconShake"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        LZMomentsViewController *vc = [[LZMomentsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        LZShakeViewController *vc = [[LZShakeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
