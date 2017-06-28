//
//  TransDetailViewController.h
//  TransitionAnimatedDemo
//
//  Created by Turbo on 2017/6/28.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransDetailViewController : UIViewController

/**
 *  二级页面图片
 *
 *  @iconImgV
 */
@property (nonatomic, strong) UIImageView *iconImgV;

/**
 *  按压图片弹起 3D Touch效果
 *
 *  @promptLabel1
 */
@property (nonatomic, strong) UILabel *promptLabel1;

/**
 *  轻触图片返回上级页面
 *
 *  @promptLabel2
 */
@property (nonatomic, strong) UILabel *promptLabel2;

/**
 *  转场动画交互协议类
 *
 *  @UIPercentDrivenInteractiveTransition
 */
@property(nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;

@end
