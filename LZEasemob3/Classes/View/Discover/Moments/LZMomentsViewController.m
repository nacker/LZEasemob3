//
//  LZMomentsViewController.m
//  LZEasemob
//
//  Created by nacker on 16/3/11.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsViewController.h"
#import "LZMomentsHeaderView.h"
#import "SDTimeLineRefreshHeader.h"
#import "LZMomentsCell.h"
#import "LZMomentsListViewModel.h"
#import "LZMomentsViewModel.h"
#import "LZActionSheet.h"
#import "LZMomentsOriginalView.h"
#import "LZNavigationController.h"
#import "LZMoments.h"

#import "TZImagePickerController.h"
#import "LZMomentsSendViewController.h"
#import "LZMomentsTimeLineViewController.h"

@interface LZMomentsViewController ()<UITableViewDataSource,UITableViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LZMomentsCellDelegate,UITextFieldDelegate>//LZMomentsSendViewControllerDelegate
@property (nonatomic, strong) LZMomentsListViewModel *statusListViewModel;


@property (nonatomic, weak) LZMomentsHeaderView *headerView;
@end

@implementation LZMomentsViewController
{
    SDTimeLineRefreshHeader *_refreshHeader;
    
    CGFloat _lastScrollViewOffsetY;
    UITextField *_textField;
    CGFloat _totalKeybordHeight;
    NSIndexPath *_currentEditingIndexthPath;
}
// 键盘高度
static CGFloat textFieldH = 40;

static NSString * const CellIdentifier = @"LZMomentsCell";

- (LZMomentsListViewModel *)statusListViewModel {
    if (_statusListViewModel == nil) {
        _statusListViewModel = [[LZMomentsListViewModel alloc] init];
    }
    return _statusListViewModel;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_refreshHeader.superview) {
        
        _refreshHeader = [SDTimeLineRefreshHeader refreshHeaderWithCenter:CGPointMake(40, 45)];
        _refreshHeader.scrollView = self.tableView;
        __weak typeof(self) weakSelf = self;
        [_refreshHeader setRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf setupNewData];
            });
        }];
        [self.tableView.superview addSubview:_refreshHeader];
    } else {
        [self.tableView.superview bringSubviewToFront:_refreshHeader];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self setupNavBar];
    [self setupTableView];
    [self setupHeadView];
    [self setupNewData];
    
    [self setupFooterRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreButtonClick:) name:LZMoreButtonClickedNotification object:nil];
    // 键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)moreButtonClick:(NSNotification *)note
{
    NSIndexPath *indexPath = note.userInfo[LZMoreButtonClickedNotificationKey];
    LZMomentsViewModel *model = self.statusListViewModel.statusList[indexPath.row];
    model.isOpening = !model.isOpening;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - setupNavBar
- (void)setupNavBar
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"album_add_photo"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
}

#pragma mark - rightBarButtonItemClick
- (void)rightBarButtonItemClick
{
    typeof(self) __weak weakSelf = self;
    LZActionSheet *sheet = [[LZActionSheet alloc] initWithTitle:nil buttonTitles:@[@"小视频",@"拍照",@"从手机相册选择"] redButtonIndex:-1 cancelTextColor:[UIColor blackColor] clicked:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:
                [weakSelf takeVideo];
                break;
            case 1:
                [weakSelf takePictures];
                break;
            case 2:
                [weakSelf takeAlbum];
                break;
        }
    }];
    [sheet show];
}

#pragma mark - 小视频
- (void)takeVideo
{
    KLog(@"小视频");
}

#pragma mark - 拍照
- (void)takePictures
{
#if TARGET_IPHONE_SIMULATOR//模拟器
    
#elif TARGET_OS_IPHONE//真机
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:ipc animated:YES completion:nil];
#endif
}

#pragma mark - 从手机相册选择
- (void)takeAlbum
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - setupTableView
- (void)setupTableView {
    [self.tableView registerClass:[LZMomentsCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - setupHeadView
- (void)setupHeadView
{
    typeof(self) __weak weakSelf = self;
    
    LZMomentsHeaderView *headerView = [[LZMomentsHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0, self.view.width, 260);
    [headerView setIconButtonClick:^{
        LZMomentsTimeLineViewController *vc = [[LZMomentsTimeLineViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - setupRefresh
- (void)setupFooterRefresh
{
}

- (void)loadMoreData
{
    __weak typeof(self) weakSelf = self;
    [self.statusListViewModel loadMoreStatusWithCount:10 Completed:^(BOOL isSuccessed) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
        });
    }];
}

- (void)setupNewData
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(_refreshHeader) weakHeader = _refreshHeader;
    [weakSelf.statusListViewModel  loadStatusWithCount:10 Completed:^(BOOL isSuccessed) {
        [weakHeader endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusListViewModel.statusList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZMomentsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (cell.delegate == nil) {
        cell.delegate = self;
    }
    if (!cell.operationButtonClick) {
        [cell setOperationButtonClick:^(NSIndexPath *indexPath) {
            
        }];
    }
//    KLog(@"%@",self.statusListViewModel.statusList);
    LZMomentsViewModel *viewModel = self.statusListViewModel.statusList[indexPath.row];
    cell.viewModel = viewModel;

    return cell;
    
}

#pragma mark - LZMomentsCellDelegate
- (void)didClickLickButtonInCell:(LZMomentsCell *)cell
{
    KLog(@"---");
}

- (void)didClickcCommentButtonInCell:(LZMomentsCell *)cell
{
    KLog(@"---");
    [_textField becomeFirstResponder];
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    [self adjustTableViewToFitKeyboard];
}

- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [self.tableView setContentOffset:offset animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        
        LZMomentsViewModel *viewModel = self.statusListViewModel.statusList[_currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:viewModel.status.commentItemsArray];
        
        LZMomentsCellCommentItemModel *commentItemModel = [LZMomentsCellCommentItemModel new];
        commentItemModel.firstUserName = @"二哥";
        commentItemModel.commentString = textField.text;
        commentItemModel.firstUserId = @"二哥";
        [temp addObject:commentItemModel];
        
        viewModel.status.commentItemsArray = [temp copy];
        
        [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _textField.text = @"";
        
        return YES;
    }
    return NO;
}

#pragma mark - 键盘处理
- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _textField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *) photos sourceAssets:(NSArray *)assets
{
    KLog(@"%@", photos);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LZMomentsSendViewController *vc = [[LZMomentsSendViewController alloc] initWithImages:photos];
//        vc.delegate = self;
        [vc setSendButtonClickedBlock:^(NSString *text, NSArray *images) {
            KLog(@"%@,%@",text,images);
        }];
        LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    });
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *) photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos
{
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    LZMomentsSendViewController *vc = [[LZMomentsSendViewController alloc] initWithImages:@[image]];
    [vc setSendButtonClickedBlock:^(NSString *text, NSArray *images) {
        KLog(@"%@,%@",text,images);
    }];
    LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [_refreshHeader removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 测试用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_textField resignFirstResponder];
}
@end
