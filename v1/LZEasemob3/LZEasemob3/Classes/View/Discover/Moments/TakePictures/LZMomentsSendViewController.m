//
//  LZMomentsSendViewController.m
//  LZEasemob
//
//  Created by nacker on 16/4/1.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsSendViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import "DFPlainGridImageView.h"
#import "LZActionSheet.h"
#import "EMTextView.h"

#import "LZMomentsSendViewModel.h"
#import "MomentsPublishPictureCell.h"
#import "LZMomentsDefaultsCell.h"

#define ImageGridWidth [UIScreen mainScreen].bounds.size.width*0.7

@interface LZMomentsSendViewController()<UITextViewDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation LZMomentsSendViewController
{
    UIView *_headerView;
    EMTextView *_textView;
}
- (instancetype)initWithImages:(NSArray *)images
{
    if (self = [super init]) {
        _images = [NSMutableArray array];
        if (images != nil) {
            [_images addObjectsFromArray:images];
            [_images addObject:[UIImage imageNamed:@"AlbumAddBtn"]];
            self.viewModel.assets = _images;
        }
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor stringTOColor:@"#f2f2f2"];
    [self setupNavItem];
    [self setupUI];
    
    [self setupActionBinds];
}

#pragma mark - setupNavItem
- (void)setupNavItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send
{
    if (self.sendButtonClickedBlock) {
        self.sendButtonClickedBlock(_textView.text,_images);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setupUI
- (void)setupUI
{
    _textView = [[EMTextView alloc] init];
    _textView.placeholder = @"说点什么吧...";
    _textView.scrollEnabled = YES;
    _textView.delegate = self;
    _textView.bounces = YES;
    _textView.editable = YES;
    _textView.selectable = YES;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.showsVerticalScrollIndicator = YES;
    
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.backgroundColor = KRandomColor;
    [_headerView addSubview:_textView];
    self.tableView.tableHeaderView = _headerView;
    
//    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_headerView).with.insets(UIEdgeInsetsMake(0, 15.0, 5.0, 0));
//    }];
//    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.tableView);
        make.height.equalTo(@250);
    }];
}

- (void)setupActionBinds
{
    RAC(self.viewModel,textPlain) = _textView.rac_textSignal;
//    RAC(_textView.placehoderLabel, hidden) = [_textView.rac_textSignal
//                                          map:^id(NSString *text) {
//                                              
//                                              return @(text && text.length > 0);
//                                          }];
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:PhotoPickerPhotoTakeDoneNotification
       object:nil]
      deliverOnMainThread]
     subscribeNext:^(NSNotification *notification) {
         
         @strongify(self);
         
         NSArray *selectedAssets = notification.object;
         
         self.viewModel.assets = [[NSArray alloc] initWithArray:selectedAssets];
         [self.tableView reloadData];
     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return 2;
    }
    return 1;
}


static NSString * const locationCellIdentifier = @"locationCell";
static NSString * const remindCellIdentifier = @"remindCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0){
        MomentsPublishPictureCell *cell = [MomentsPublishPictureCell cellWithTableView:tableView];
//        cell.delegate = self;
        cell.viewModel = self.viewModel;
        
        return cell;
    }
    LZMomentsDefaultsCell *cell = [LZMomentsDefaultsCell cellWithTableView:tableView];
    if (indexPath.section == 1) {
        cell.textLabel.text = @"dshkjfhkd";
    }else {
        cell.textLabel.text = @"32423423";
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return [MomentsPublishPictureCell estimatedHeightWithViewModel:self.viewModel];
        }
    }
    
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1){
        return 20.0;
    }
    return .0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .0f;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
//    if (!view)
//    {
//        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
//        view.contentView.backgroundColor = tableView.backgroundColor;
//    }
//    
//    return view;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextViewDelegate


#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *) photos sourceAssets:(NSArray *)assets
{
    NSLog(@"%@", photos);
    for (UIImage *image in photos) {
        [_images insertObject:image atIndex:(_images.count - 1)];
    }

    self.viewModel.assets = _images;
//    [self refreshGridImageView];

}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *) photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos
{

}
@end
