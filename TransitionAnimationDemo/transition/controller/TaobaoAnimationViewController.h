//
//  TaobaoAnimationViewController.h
//  TransitionAnimatedDemo
//
//  Created by Turbo on 2017/6/28.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaobaoAnimationViewController : UIViewController

/**
 *  二级页面图片
 *
 *  @iconImgV
 */
@property (nonatomic, strong) UIImageView *iconImgV;

/**
 *  承载仿淘宝动画的BackView
 *
 *  @BackView
 */
@property (nonatomic, strong) UIView *mainBackgroundView;

/**
 *  半透明触摸蒙版
 *
 *  @maskView
 */
@property (nonatomic, strong) UIView *maskView;

/**
 *  底部弹出模块
 *
 *  @shopChoiceView
 */
@property (nonatomic, strong) UIView *shopChoiceView;

@end
