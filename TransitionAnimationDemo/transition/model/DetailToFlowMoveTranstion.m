//
//  DetailToFlowMoveTranstion.m
//  TransitionAnimatedDemo
//
//  Created by Turbo on 2017/6/28.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "DetailToFlowMoveTranstion.h"
#import "TransitionListViewController.h"
#import "TransDetailViewController.h"
#import "TransitionAnimatedCell.h"

@implementation DetailToFlowMoveTranstion

/**
 *  过度时间
 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}


/**
 *  定义两个 ViewController 之间的过渡效果
 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //实现过渡的控制器 和 容器view
    TransitionListViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    TransDetailViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //前一个VC设置 截图
    UIView *snapshotView = [fromVC.iconImgV snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [containerView convertRect:fromVC.iconImgV.frame fromView:fromVC.view];
    fromVC.iconImgV.hidden = YES;
    
    //下一个VC设置
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC   ];
    TransitionAnimatedCell *cell = (TransitionAnimatedCell *)[toVC.collectionView cellForItemAtIndexPath:toVC.currentIndexPath];
    cell.iconImgV.hidden = YES;
    
    // 添加到容器
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:snapshotView];
        
    // 动画 UIViewAnimationOptionCurveLinear动画匀速执行
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        fromVC.view.alpha = 0;
        
        snapshotView.frame = [containerView convertRect:cell.iconImgV.frame fromView:cell.iconImgV.superview];
        
    } completion:^(BOOL finished) {
        [snapshotView removeFromSuperview];
        cell.iconImgV.hidden = NO;
        fromVC.iconImgV.hidden = NO;
        
        // 告诉系统动画结束
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

@end
