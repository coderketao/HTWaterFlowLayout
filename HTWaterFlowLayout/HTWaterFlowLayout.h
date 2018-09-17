//
//  CollectionViewWaterFlowLayout.h
//  collectionView02-瀑布流
//
//  Created by haifeng on 2018/9/17.
//  Copyright © 2018年 coderhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTWaterFlowLayout;

@protocol HTWaterFlowLayoutDelegate <NSObject>

@required
-(CGFloat)waterFlowLayout:(HTWaterFlowLayout *)waterFlowLayout heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)itemWidth;
@optional

- (CGFloat)columnCountInWaterflowLayout:(HTWaterFlowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(HTWaterFlowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(HTWaterFlowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(HTWaterFlowLayout *)waterflowLayout;

@end

@interface HTWaterFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<HTWaterFlowLayoutDelegate> delegate;

@end
