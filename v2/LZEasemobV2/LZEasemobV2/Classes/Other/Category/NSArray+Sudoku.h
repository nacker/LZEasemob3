//
//  NSArray+Sudoku.h
//  WexWeiCaiFu
//
//  Created by 星星 on 16/8/8.
//  Copyright © 2016年 SinaPay. All rights reserved.
//

#import "MASUtilities.h"
#import "MASConstraintMaker.h"
#import "MASViewAttribute.h"

@interface NSArray (Sudoku)


/**
 *  九宫格布局 固定ItemSize 可变ItemSpacing
 *
 *  @param fixedItemWidth  固定宽度
 *  @param fixedItemHeight 固定高度
 *  @param warpCount       折行点
 *  @param topSpacing      顶间距
 *  @param bottomSpacing   底间距
 *  @param leadSpacing     左间距
 *  @param tailSpacing     右间距
 */
- (void)mas_distributeSudokuViewsWithFixedItemWidth:(CGFloat)fixedItemWidth
                                    fixedItemHeight:(CGFloat)fixedItemHeight
                                          warpCount:(NSInteger)warpCount
                                         topSpacing:(CGFloat)topSpacing
                                      bottomSpacing:(CGFloat)bottomSpacing
                                        leadSpacing:(CGFloat)leadSpacing
                                        tailSpacing:(CGFloat)tailSpacing;


/**
 *  九宫格布局 可变ItemSize 固定ItemSpacing
 *
 *  @param fixedLineSpacing      行间距
 *  @param fixedInteritemSpacing 列间距
 *  @param warpCount             折行点
 *  @param topSpacing            顶间距
 *  @param bottomSpacing         底间距
 *  @param leadSpacing           左间距
 *  @param tailSpacing           右间距
 */
- (void)mas_distributeSudokuViewsWithFixedLineSpacing:(CGFloat)fixedLineSpacing
                                fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing
                                            warpCount:(NSInteger)warpCount
                                           topSpacing:(CGFloat)topSpacing
                                        bottomSpacing:(CGFloat)bottomSpacing
                                          leadSpacing:(CGFloat)leadSpacing
                                          tailSpacing:(CGFloat)tailSpacing;


/**
 *  九宫格布局 固定ItemSize 固定ItemSpacing
 *  可由九宫格的内容控制SuperView的大小
 *  如果warpCount大于[self count]，该方法将会用空白的View填充到superview中
 *
 *  Sudoku Layout, has fixed item size, and fix item space
 *  If warp count greater than self.count, It's fill empty view to superview
 *
 *  @param fixedItemWidth        固定宽度，如果设置成0，则表示自适应，If set it to zero, indicates the adaptive.
 *  @param fixedItemHeight       固定高度，如果设置成0，则表示自适应，If set it to zero, indicates the adaptive.
 *  @param fixedLineSpacing      行间距
 *  @param fixedInteritemSpacing 列间距
 *  @param warpCount             折行点
 *  @param topSpacing            顶间距
 *  @param bottomSpacing         底间距
 *  @param leadSpacing           左间距
 *  @param tailSpacing           右间距
 *
 *  @return 一般情况下会返回[self copy], 如果warpCount大于[self count]，则会返回一个被空白view填充过的数组，可以让你循环调用removeFromSuperview或者干一些其他的事情;
 *  @return Normal will return [self copy], If warpCount bigger than [self count] , It will return a empty views filled array, you could enumerate [subview removeFromSuperview] or do other things;
 */
- (NSArray *)mas_distributeSudokuViewsWithFixedItemWidth:(CGFloat)fixedItemWidth
                                         fixedItemHeight:(CGFloat)fixedItemHeight
                                        fixedLineSpacing:(CGFloat)fixedLineSpacing
                                   fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing
                                               warpCount:(NSInteger)warpCount
                                              topSpacing:(CGFloat)topSpacing
                                           bottomSpacing:(CGFloat)bottomSpacing
                                             leadSpacing:(CGFloat)leadSpacing
                                             tailSpacing:(CGFloat)tailSpacing;
@end
