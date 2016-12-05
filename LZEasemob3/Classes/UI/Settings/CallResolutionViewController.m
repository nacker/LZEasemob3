//
//  CallResolutionViewController.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 9/19/16.
//  Copyright © 2016 XieYajie. All rights reserved.
//

#import "CallResolutionViewController.h"

#import "ChatDemoHelper.h"

@interface CallResolutionViewController ()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation CallResolutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Video Resolution";
    
#if DEMO_CALL == 1
    EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
    int row = options.videoResolution;
    self.selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#if DEMO_CALL == 1
    return 4;
#endif
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"默认 (352 * 288)";
            break;
        case 1:
            cell.textLabel.text = @"352 * 288";
            break;
        case 2:
            cell.textLabel.text = @"640 * 480";
            break;
        case 3:
            cell.textLabel.text = @"1280 * 720";
            break;
        case 4:
            cell.textLabel.text = @"1920 * 1080";
            break;
            
        default:
            break;
    }
    
    if (indexPath.row == self.selectedIndexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.selectedIndexPath || self.selectedIndexPath.row != indexPath.row) {
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        EMCallVideoResolution resolution = (EMCallVideoResolution)indexPath.row;
        EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
        options.videoResolution = resolution;
        [ChatDemoHelper updateCallOptions];
    }
    
    self.selectedIndexPath = indexPath;
}

@end
