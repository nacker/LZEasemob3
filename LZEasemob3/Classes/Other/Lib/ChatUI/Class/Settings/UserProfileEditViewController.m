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

#import "UserProfileEditViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "UserCacheManager.h"
#import "EditNicknameViewController.h"
#import "UIImageView+HeadImage.h"

@interface UserProfileEditViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *usernameLabel;

@end

@implementation UserProfileEditViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"setting.personalInfo", @"Profile");
    self.view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (UIImageView*)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.frame = CGRectMake(20, 10, 60, 60);
        _headImageView.contentMode = UIViewContentModeScaleToFill;
    }
    UserCacheInfo *user = [UserCacheManager getCurrUser];
    [_headImageView imageWithUsername:user.Id placeholderImage:nil];
    return _headImageView;
}

- (UILabel*)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10.f, 10, 200, 20);
        _usernameLabel.text = [UserCacheManager getCurrNickName];
        _usernameLabel.textColor = [UIColor lightGrayColor];
    }
    return _usernameLabel;
}

#pragma mark - getter

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = NSLocalizedString(@"setting.personalInfoUpload", @"Upload HeadImage");
        [cell.contentView addSubview:self.headImageView];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"username", @"username");
        cell.detailTextLabel.text = self.usernameLabel.text;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"setting.profileNickname", @"Nickname");
        cell.detailTextLabel.text = [UserCacheManager getCurrNickName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"setting.cameraUpload", @"Take photo"),NSLocalizedString(@"setting.localUpload", @"Photos"), nil];
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    } else if (indexPath.row == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (indexPath.row == 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"setting.editName", @"Edit NickName") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        //获取文本输入框
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        if(nameTextField.text.length > 0)
        {
            //设置推送设置
            [self showHint:NSLocalizedString(@"setting.saving", "saving...")];
            __weak typeof(self) weakSelf = self;
            [[EMClient sharedClient] setApnsNickname:nameTextField.text];
            // del by martin 0606
//            [[UserProfileManager sharedInstance] updateUserProfileInBackground:@{kPARSE_HXUSER_NICKNAME:nameTextField.text} completion:^(BOOL success, NSError *error) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (weakSelf) {
//                        UserProfileEditViewController *strongSelf = weakSelf;
//                        [strongSelf hideHud];
//                        if (success) {
//                            [strongSelf.tableView reloadData];
//                        } else {
//                            [strongSelf showHint:NSLocalizedString(@"setting.saveFailed", "save failed") yOffset:0];
//                        }
//                    }
//                });
//            }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"setting.uploading", @"uploading...")];
    
    __weak typeof(self) weakSelf = self;
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (orgImage) {
        // del by martin 0606
//        [[UserProfileManager sharedInstance] uploadUserHeadImageProfileInBackground:orgImage completion:^(BOOL success, NSError *error) {
//            [weakSelf hideHud];
//            if (success) {
//                UserProfileEntity *user = [[UserProfileManager sharedInstance] getCurUserProfile];
//                [weakSelf.headImageView imageWithUsername:user.username placeholderImage:orgImage];
//                [self showHint:NSLocalizedString(@"setting.uploadSuccess", @"uploaded successfully")];
//            } else {
//                [self showHint:NSLocalizedString(@"setting.uploadFail", @"uploaded failed")];
//            }
//        }];
    } else {
        [self hideHud];
        [self showHint:NSLocalizedString(@"setting.uploadFail", @"uploaded failed")];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
#if TARGET_IPHONE_SIMULATOR
        [self showHint:NSLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
            [self presentViewController:self.imagePicker animated:YES completion:NULL];
        } else {
        
        }
#endif
    } else if (buttonIndex == 1) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:self.imagePicker animated:YES completion:NULL];

    }
}



@end
