//
//  LZMomentsTimeLineViewController.m
//  LZEasemob
//
//  Created by nacker on 16/4/14.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsTimeLineViewController.h"

@interface LZMomentsTimeLineViewController ()

@end

@implementation LZMomentsTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (iOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

static NSString * const CellIdentifier = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %zd", self.title, indexPath.row];
    return cell;
    
}
@end
