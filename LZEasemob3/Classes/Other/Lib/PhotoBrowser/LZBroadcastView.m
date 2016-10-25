//
//  LZBroadcastView.m
//  teacher
/**
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */
//  Created by nacker on 15/8/6.
//  Copyright (c) 2015年 Shanghai Minlan Information & Technology Co ., Ltd. All rights reserved.
//

#import "LZBroadcastView.h"
#import "LZBroadcastViewCell.h"

#define kPadding 10

#define kCellTagOffset 1000
#define kCellIndex(cell) ([cell tag] - kCellTagOffset)

@interface LZBroadcastView()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) NSMutableSet *visibleCells;

@property(nonatomic,strong) NSMutableSet *reusableCells;

@property (nonatomic,assign) NSUInteger currentIndex;

@property(nonatomic,assign) BOOL isIgnoreScroll;

@property(nonatomic,assign) BOOL isIgnorePreOperate;

@property(nonatomic,assign) BOOL isNotFirstSetCurrentIndex;

@end

@implementation LZBroadcastView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.isIgnoreScroll = NO;
    self.isNotFirstSetCurrentIndex = NO;
    
    self.clipsToBounds = YES;
    self.padding = kPadding;
    
    self.scrollView.scrollsToTop = NO;
}

#pragma mark - seLZer geLZer

- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.autoresizesSubviews = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingNone;
        _scrollView.clipsToBounds = YES;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (NSMutableSet*)visibleCells
{
    if (!_visibleCells) {
        _visibleCells = [NSMutableSet set];
    }
    return _visibleCells;
}

- (NSMutableSet*)reusableCells
{
    if (!_reusableCells) {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    NSUInteger pageCount = [self pageCount];
    if (currentIndex>pageCount-1) {
        currentIndex = pageCount-1;
    }
    if (currentIndex == _currentIndex&&self.isNotFirstSetCurrentIndex) {
        return;
    }
    self.isNotFirstSetCurrentIndex = YES;
    
    _currentIndex = currentIndex;
    
    if (self.isAutoRoll&&pageCount>=4) {

        if (self.currentIndex>=pageCount-1) {
            self.isIgnorePreOperate = YES;
            
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x-(pageCount-2)*CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
            
            self.isIgnorePreOperate = NO;
            return;
        }else if (self.currentIndex<=0) {
            self.isIgnorePreOperate = YES;

            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x+(pageCount-2)*CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
            
            self.isIgnorePreOperate = NO;
            return;
        }
    }

    if (self.delegate&&[self.delegate respondsToSelector:@selector(didScrollToPageIndex:ofBroadcastView:)]) {
        [self.delegate didScrollToPageIndex:[self switchToPageIndexForIndex:currentIndex] ofBroadcastView:self];
    }
}

- (NSUInteger)currentPageIndex
{
    return [self switchToPageIndexForIndex:self.currentIndex];
}

#pragma mark - helper
- (NSUInteger)pageCount
{
    NSUInteger count = [self.dataSource cellCountOfBroadcastView:self];
    count = count>1?count+(self.isAutoRoll?2:0):count;
    return count;
}

- (NSUInteger)switchToPageIndexForIndex:(NSUInteger)index
{
    if (!self.isAutoRoll) {
        return index;
    }
    NSUInteger pageCount = [self pageCount];
    if (pageCount<4) {
        return index;
    }
    
    if (index>=pageCount-1) {
        return 0;
    }else if (index<=0){
        return pageCount-2-1;
    }
    
    return index-1;
}

#pragma mark - layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger pageCount = [self pageCount];

    CGRect scrollFrame = self.bounds;
    scrollFrame.origin.x -= self.padding;
    scrollFrame.size.width += 2 * self.padding;
    
    self.isIgnoreScroll = YES;
    self.scrollView.frame = scrollFrame;
    self.scrollView.contentSize = CGSizeMake(pageCount*scrollFrame.size.width, scrollFrame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.currentIndex*scrollFrame.size.width, 0);
    
    self.isIgnoreScroll = NO;
    
    CGRect bounds = self.scrollView.bounds;
    for (LZBroadcastViewCell *cell in self.visibleCells) {
        cell.frame = CGRectMake(CGRectGetWidth(bounds)*kCellIndex(cell)+self.padding, CGRectGetMinY(bounds), CGRectGetWidth(bounds)-2*self.padding, CGRectGetHeight(bounds));
    }
}

#pragma mark - reusable
- (id)dequeueReusableCellWithIdentifier:(NSString*)identifier
{
    LZBroadcastViewCell *cell = nil;
    for (LZBroadcastViewCell *aCell in self.reusableCells) {
        if ([aCell.reuseIdentifier isEqualToString:identifier]) {
            cell = aCell;
            break;
        }
    }
    if (cell) {
        [self.reusableCells removeObject:cell];
        [cell prepareForReuse];
    }
    
    return cell;
}

#pragma mark - showCell

- (void)showCells
{
    NSUInteger pageCount = [self pageCount];
    if (pageCount<=0) {
        return;
    }
    CGRect visibleBounds = self.scrollView.bounds;
	NSInteger firstIndex = (NSInteger)floor((CGRectGetMinX(visibleBounds)+self.padding*2) / CGRectGetWidth(visibleBounds));
	NSInteger lastIndex  = (NSInteger)floor((CGRectGetMaxX(visibleBounds)-1-self.padding*2) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= pageCount) firstIndex = pageCount - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= pageCount) lastIndex = pageCount - 1;
	if (firstIndex>lastIndex) {
        return;
    }
    NSInteger cellIndex;
	for (LZBroadcastViewCell *cell in self.visibleCells) {
        cellIndex = kCellIndex(cell);
		if (cellIndex < firstIndex || cellIndex > lastIndex) {
			[self.reusableCells addObject:cell];
			[cell removeFromSuperview];
		}
	}
	[self.visibleCells minusSet:self.reusableCells];
    
    if (self.reusableCells.count>2) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (LZBroadcastViewCell *cell in self.reusableCells) {
            NSAssert(cell.reuseIdentifier, @"BroadcastCell没有对应的标识符");
            if (!dict[cell.reuseIdentifier]) {
                dict[cell.reuseIdentifier] = [NSMutableArray array];
            }
            [dict[cell.reuseIdentifier] addObject:cell];
        }
        for (NSMutableArray *array in [dict allValues]) {
            if (array.count>2) {
                for (NSUInteger i=2; i<array.count; i++) {
                    [self.reusableCells removeObject:array[i]];
                }
            }
        }
    }
	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        [self showCellAtIndex:index];
	}
}

- (void)showCellAtIndex:(NSUInteger)index
{
    for (LZBroadcastViewCell *cell in self.visibleCells) {
        if (kCellIndex(cell) == index) {
            return;
        }
    }
    
    NSUInteger cellIndex = index;
    NSUInteger pageCount = [self pageCount];;
    if (self.isAutoRoll&&pageCount>=4) {
        NSUInteger realPageCount = pageCount - 2;
        if (cellIndex<=0) {
            cellIndex = realPageCount-1;
        }else if (cellIndex>=pageCount-1) {
            cellIndex = 0;
        }else{
            cellIndex -=1;
        }
    }
    LZBroadcastViewCell *cell = [self.dataSource broadcastView:self cellAtPageIndex:cellIndex];
    
    cell.tag = kCellTagOffset + index;
    
    CGRect bounds = self.scrollView.bounds;
    cell.frame = CGRectMake(CGRectGetWidth(bounds)*index+self.padding, CGRectGetMinY(bounds), CGRectGetWidth(bounds)-2*self.padding, CGRectGetHeight(bounds));
    
    [self.visibleCells addObject:cell];
    [self.scrollView addSubview:cell];
    
    if (!self.isIgnorePreOperate) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(preOperateInBackgroundAtPageIndex:ofBroadcastView:)]) {
            [self preOperateNearIndex:index];
        }
    }
}

#pragma mark pre operate
- (void)justPreOperateWithIndex:(NSUInteger)index
{
    for (LZBroadcastViewCell *cell in self.visibleCells) {
        if ([self switchToPageIndexForIndex:kCellIndex(cell)] == [self switchToPageIndexForIndex:index]) {
            return;
        }
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(preOperateInBackgroundAtPageIndex:ofBroadcastView:)]) {
        __weak __typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf.delegate preOperateInBackgroundAtPageIndex:[self switchToPageIndexForIndex:index] ofBroadcastView:weakSelf];
        });
    }
}

- (void)preOperateNearIndex:(NSUInteger)index
{
    NSUInteger pageCount = [self pageCount];
    if (self.isAutoRoll&&pageCount>=4) {
        NSUInteger leftIndex = index<1?pageCount-2-2+1:index-1;
        NSUInteger rightIndex = index+1>pageCount-1?2-1+1:index+1;
        [self justPreOperateWithIndex:leftIndex];
        if (leftIndex!=rightIndex&&[self switchToPageIndexForIndex:leftIndex]!=[self switchToPageIndexForIndex:rightIndex]) {
            [self justPreOperateWithIndex:rightIndex];
        }
    }else{
        if (index > 0) {
            [self justPreOperateWithIndex:index-1];
        }
        if (index < pageCount - 1) {
            [self justPreOperateWithIndex:index+1];
        }
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.dataSource) {
        return;
    }
    if (self.isIgnoreScroll) {
        return;
    }
    [self showCells];
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    self.currentIndex = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

#pragma mark - other
- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSUInteger pageCount = [self pageCount];
    if (index>=pageCount) {
        index = pageCount-1;
    }
    [self.scrollView setContentOffset:CGPointMake(index * CGRectGetWidth(self.scrollView.frame), 0) animated:animated];
    [self showCells];
}

- (void)scrollToPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated
{
    NSUInteger pageCount = [self pageCount];
    NSUInteger index = pageIndex;

    if (self.isAutoRoll&&pageCount>=4) {
        NSUInteger realPageCount = pageCount - 2;
        NSUInteger currentPageIndex = self.currentPageIndex;
        if (pageIndex<=0&&currentPageIndex>=realPageCount/2) {
            index = pageCount - 1;
        }else if (pageIndex>=realPageCount-1&&currentPageIndex<realPageCount/2) {
            index = 0;
        }else{
            index++;
        }
    }
    [self scrollToIndex:index animated:animated];
}

- (void)reloadData
{
    self.isNotFirstSetCurrentIndex = NO;
    self.isIgnoreScroll = NO;
    
    for (LZBroadcastViewCell *cell in self.visibleCells) {
        [cell removeFromSuperview];
	}
    [self.visibleCells removeAllObjects];
    [self.reusableCells removeAllObjects];
    
    if (self.isAutoRoll&&[self pageCount]>=4) {
        self.currentIndex = 1;
    }else{
        self.currentIndex = 0;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self scrollToIndex:self.currentIndex animated:NO];
}

@end
