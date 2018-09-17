//
//  CollectionViewWaterFlowLayout.m
//  collectionView02-瀑布流
//
//  Created by haifeng on 2018/9/17.
//  Copyright © 2018年 coderhong. All rights reserved.
//

#import "HTWaterFlowLayout.h"


/**默认的列数*/
static const NSInteger DefaultColumnCount = 2;
/**默认的列边距*/
static const CGFloat DefaultColumnMargin = 10;
/**默认的行边距*/
static const CGFloat DefaultRowMargin = 10;
/**默认的edge*/
static const UIEdgeInsets DefaultEdgeInsets = {10, 10, 10, 10};

@interface HTWaterFlowLayout()

@property (nonatomic, strong) NSMutableArray *attrisArray;
/** 存储所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;
@end

@implementation HTWaterFlowLayout

#pragma mark - 常见数据处理
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return DefaultRowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return DefaultColumnMargin;
    }
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return DefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return DefaultEdgeInsets;
    }
}

- (NSMutableArray *)attrisArray {
    if (_attrisArray == nil) {
        _attrisArray = [NSMutableArray array];
    }
    return _attrisArray;
}
- (NSMutableArray *)columnHeights {
    if (_columnHeights == nil) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    // 清除以前的高度
    [self.columnHeights removeAllObjects];
    // 设置默认值
    for (NSInteger i=0; i<self.columnMargin; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
     // CollectionView刷新清空
     [self.attrisArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i=0; i<count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attris = [self layoutAttributesForInteractivelyMovingItemAtIndexPath:indexPath];
        
        [self.attrisArray addObject:attris];
    }
}

/**
 * 如果布局不是继承UICollectionViewFlowLayout 该方法频繁被调用 说明之前UICollectionViewFlowLayout内部是做了控制
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attrisArray;
}

/**
 * 返回CollectionView的内容
 */
- (CGSize)collectionViewContentSize {
    
    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i=1; i<self.columnCount; i++) {
        CGFloat cloumnHeight = [self.columnHeights[i] doubleValue];
        if (maxColumnHeight < cloumnHeight) {
            maxColumnHeight = cloumnHeight;
        }
    }
    return CGSizeMake(0, maxColumnHeight + self.edgeInsets.bottom);
}

/**
 * 返回indexPath位置对应的UICollectionViewLayoutAttributes
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForInteractivelyMovingItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    // 创建布局对象
    UICollectionViewLayoutAttributes *attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // 获取CollectionView的宽度
    CGFloat collectionW = self.collectionView.frame.size.width;
    
    CGFloat w = (collectionW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount-1)*self.columnMargin) / self.columnCount;
    CGFloat h = [self.delegate waterFlowLayout:self heightForRowAtIndexPath:indexPath width: w];
    
    // 核心找到最短的那一列
    // 遍历优化 从1开始遍历
    NSInteger destColumn = 0; // 最小的列号
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (int i=1; i<self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn *(w+self.columnMargin);
    CGFloat y = minColumnHeight;
    if(y != self.edgeInsets.top){
        y+=self.rowMargin;
    }
    
    attris.frame = CGRectMake(x, y, w, h);
    
    // 更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attris.frame));
    
    return attris;
}

@end
