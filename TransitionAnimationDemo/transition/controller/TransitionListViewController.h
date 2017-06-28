//
//  TransitionListViewController.h
//  TransitionAnimationDemo
//
//  Created by Turbo on 2017/6/28.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitionListViewController : UIViewController

@property(nonatomic ,strong) UICollectionView *collectionView;

/**
 *  进入下个控制器前保存当前NSIndexPath
 *
 *  @NSIndexPath
 */
@property(nonatomic ,strong) NSIndexPath *currentIndexPath;

/**
 *  进入下个控制器前截屏
 *
 *  @currentVCSnapshotView
 */
@property(nonatomic ,strong) UIView *currentVCSnapshotView;

@end
