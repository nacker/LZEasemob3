//
//  LZMomentsCellCommentView.m
//  LZEasemob
//
//  Created by nacker on 16/3/30.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsCellCommentTableView.h"
#import "LZMomentsViewModel.h"
#import "LZMomentsCellCommentViewCell.h"
#import "LZMomentsCellLikeHeaderFooterView.h"
#import "MLLinkLabel.h"

@interface LZMomentsCellCommentTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *likeItemsArray;
@property (nonatomic, strong) NSMutableArray *commentItemsArray;

@property (nonatomic, strong) NSMutableArray *commentArray;
@end

@implementation LZMomentsCellCommentTableView

static NSString * const CellIdentifier = @"LZMomentsCellCommentViewCell";
static NSString * const HeaderFooterViewIdentifier = @"LZMomentsSectionHeaderView";

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray new];
    }
    return _commentArray;
}

- (void)setViewModel:(LZMomentsViewModel *)viewModel
{
    _viewModel = viewModel;
    
    self.likeItemsArray = (NSMutableArray *)viewModel.status.likeItemsArray;
    self.commentItemsArray = (NSMutableArray *)viewModel.status.commentItemsArray;
//        KLog(@"%@",likeItemsArray);
//        KLog(@"%@",commentItemsArray);
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.userInteractionEnabled = YES;
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image = [UIImage resizedImage:@"LikeCmtBg"];
//    [self setBackgroundView:imageView];
    
    [self registerClass:[LZMomentsCellCommentViewCell class] forCellReuseIdentifier:CellIdentifier];
//    [self registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderFooterViewIdentifier];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = NO;
    self.estimatedRowHeight = 60;
    self.rowHeight = UITableViewAutomaticDimension;
//    self.sectionHeaderHeight = UITableViewAutomaticDimension;
//    self.estimatedSectionHeaderHeight = 10;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZMomentsCellCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.status = self.commentItemsArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.likeItemsArray.count == 0){
        return nil;
    }
    
    LZMomentsCellLikeHeaderFooterView *header = [LZMomentsCellLikeHeaderFooterView cellWithTable:tableView];
    header.likeItemsArray = self.likeItemsArray;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.likeItemsArray.count == 0)return 0;
    
//    MLLinkLabel *label = [MLLinkLabel new];
//    label.numberOfLines = 0;
//    label.lineHeightMultiple = 1.1f;
//    label.font = [UIFont systemFontOfSize:14];
//    UIColor *highLightColor = [UIColor blueColor];
//    label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
//    label.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel};
//    
//    label.attributedText = self.viewModel.status.likesStr;
//    
//    CGFloat w = [UIScreen mainScreen].bounds.size.width - 70;
//    CGFloat h = [label preferredSizeWithMaxWidth:w].height;
//    label = nil;
//    return h + 2;
    
    return [UILabel heightForExpressionText:self.viewModel.status.likesStr width:[UIScreen mainScreen].bounds.size.width - 70];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    LZMomentsCellCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
////    LZMomentsCellCommentViewCell *cell = [LZMomentsCellCommentViewCell cellWithTableView:tableView];
//    cell.status = self.commentItemsArray[indexPath.row];
//    [cell layoutIfNeeded];
//    return cell.cellHeight;
//}
@end
