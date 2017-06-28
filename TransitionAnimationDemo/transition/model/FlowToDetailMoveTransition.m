//
//  FlowToDetailMoveTransition.m
//  TransitionAnimatedDemo
//
//  Created by Turbo on 2017/6/28.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "FlowToDetailMoveTransition.h"
#import "TransitionListViewController.h"
#import "TransDetailViewController.h"
#import "TransitionAnimatedCell.h"

@implementation FlowToDetailMoveTransition

/**
 * 过渡时间
 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

/**
 *  定义两个 ViewController 之间的过渡效果
 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //先拿到前后两个viewcontroller 以及 实现动画的容器
    TransDetailViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    TransitionListViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //对Cell上的 imageView 截图，同时将这个 imageView 本身隐藏
    TransitionAnimatedCell *cell = (TransitionAnimatedCell *)[fromVC.collectionView cellForItemAtIndexPath:[[fromVC.collectionView indexPathsForSelectedItems] firstObject]];
    fromVC.currentIndexPath = [[fromVC.collectionView indexPathsForSelectedItems] firstObject];
    UIView *snapshotView = [cell.iconImgV snapshotViewAfterScreenUpdates:NO];
    
    // 坐标转换 将cell.iconImgV的rect从其父view中转换到containerView视图中，返回在containerView视图中的rect
    snapshotView.frame = [containerView convertRect:cell.iconImgV.frame fromView:cell.iconImgV.superview];
    cell.iconImgV.hidden = YES;
    
    
    //设置第二个 viewController ，将它的放到过渡后的位置，但让他完全透明，我们会在过渡时给它一个淡入的效果。
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    toVC.iconImgV.hidden = YES;
    
    //把动画前后的两个ViewController加到容器中,顺序很重要,snapShotView在上方
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapshotView];
    
    
    //现在来做 view 的动画，移动之前生成的 imageView 的截图，淡入第二个 viewController 的 view。在动画结束后，移除 imageView 的截图，让第二个 view 完全呈现。
    // UIViewAnimationOptionCurveLinear动画匀速执行
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        //将截图放到第二个viewController的imageView上
        snapshotView.frame = [containerView convertRect:toVC.iconImgV.frame fromView:toVC.view];
        
        toVC.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        cell.iconImgV.hidden = NO;
        toVC.iconImgV.hidden = NO;
        [snapshotView removeFromSuperview];
        
        //告诉系统动画结束
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
    }];
}

@end
