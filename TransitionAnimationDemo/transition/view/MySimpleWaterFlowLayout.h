//
//  MySimpleWaterFlowLayout.h
//  TransitionAnimatedDemo
//
//  Created by Turbo on 2017/6/28.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MySimpleWaterFlowLayout;
@protocol MySimpleWaterFlowLayoutDelegate <NSObject>

@required
/**
 *根据宽度计算返回的高度
 */
- (CGFloat)alw_collectionView:(UICollectionView *)collectionView layout:(MySimpleWaterFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width indexPath:(NSIndexPath*)indexPath;

@optional
/**
 *返回头部高度
 */
- (CGFloat)alw_collectionView:(UICollectionView *)collectionView layout:(MySimpleWaterFlowLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section;
/**
 *返回尾部高度
 */
- (CGFloat)alw_collectionView:(UICollectionView *)collectionView layout:(MySimpleWaterFlowLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section;
/**
 *返回列数
 */
- (NSInteger)alw_collectionView:(UICollectionView *)collectionView layout:(MySimpleWaterFlowLayout *)collectionViewLayout columnCountForSection:(NSInteger)section;
/**
 *返回每行之间的间隙
 */
- (CGFloat)alw_collectionView:(UICollectionView *)collectionView layout:(MySimpleWaterFlowLayout*)collectionViewLayout rowMarginForSectionAtIndex:(NSInteger)section;
/**
 *返回每列之间的间隙
 */
- (CGFloat)alw_collectionView:(UICollectionView *)collectionView layout:(MySimpleWaterFlowLayout*)collectionViewLayout columnMarginForSectionAtIndex:(NSInteger)section;
/**
 *返回每个区的UIEdgeInsets偏移量
 */
- (UIEdgeInsets)alw_collectionView:(UICollectionView *)collectionView layout:(MySimpleWaterFlowLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

@end


@interface MySimpleWaterFlowLayout : UICollectionViewLayout

//行间距
@property (nonatomic, assign) CGFloat rowMargin;
//列间距
@property (nonatomic, assign) CGFloat columnMargin;
//最大列数
@property (nonatomic, assign) CGFloat columnCount;
//头部高度
@property (nonatomic, assign) CGFloat headerHeight;
//尾部高度
@property (nonatomic, assign) CGFloat footerHeight;
//四边间距
@property (nonatomic, assign) UIEdgeInsets sectionInset;


@end
