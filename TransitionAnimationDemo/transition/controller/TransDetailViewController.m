//
//  TransDetailViewController.m
//  TransitionAnimatedDemo
//
//  Created by Turbo on 2017/6/28.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "TransDetailViewController.h"
#import "TransitionListViewController.h"
#import "DetailToFlowMoveTranstion.h"
#import "TaobaoAnimationViewController.h"

#define IphoneHeight  [[UIScreen mainScreen] bounds].size.height
#define IphoneWidth   [[UIScreen mainScreen] bounds].size.width

@interface TransDetailViewController ()<UINavigationControllerDelegate,UIViewControllerPreviewingDelegate>

@end

@implementation TransDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"TransDetail";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = self;
    
    [self initUI];

}

- (void)initUI {
    
    /* 返回 */
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, 5, 40, 40);
    [back setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [back setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [back addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
    
    /* 导航 */
    UIView *navbarView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, IphoneWidth, 20.0f)];
    navbarView.backgroundColor = RGBCOLOR(25, 136, 53);
    [self.view addSubview:navbarView];
    
    /* 导航标题,供3DTouch预览展示 */
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(.0f, 20.0f, self.view.frame.size.width, 44.0f);
    title.text = @"TransDetail";
    title.font = [UIFont boldSystemFontOfSize:17.f];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = RGBCOLOR(25, 136, 53);
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    /* PUSH */
    UIButton *push = [UIButton buttonWithType:UIButtonTypeCustom];
    [push addTarget:self action:@selector(pushDetail) forControlEvents:UIControlEventTouchUpInside];
    push.frame = CGRectMake(self.view.frame.size.width/4, self.view.frame.size.width*1.1, self.view.frame.size.width/2 , 40.0f);
    push.backgroundColor = RGBCOLOR(25, 136, 53);
    push.layer.cornerRadius = 5.0f;
    [push setTitle:@"PUSH" forState:UIControlStateNormal];
    [push setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:push];
    
    /* 封面大图 */
    self.iconImgV.frame = CGRectMake(.0f, 64.0f, self.view.frame.size.width, self.view.frame.size.width/1.33);
    [self.view addSubview:self.iconImgV];
    
    // 判断3dtouch权限
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.iconImgV];
        self.promptLabel1.frame = CGRectMake(0, CGRectGetHeight(self.iconImgV.frame)-60.0f, self.view.frame.size.width, 25.0f);
        [self.iconImgV addSubview:self.promptLabel1];
    }
    
    // 添加触摸手势
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired=1;
    self.iconImgV.userInteractionEnabled = YES;
    [self.iconImgV addGestureRecognizer:tapGesture];
    
    // 轻触返回提示
    self.promptLabel2.frame = CGRectMake(0, CGRectGetHeight(self.iconImgV.frame)-35.0f, self.view.frame.size.width, 25.0f);
    [self.iconImgV addSubview:self.promptLabel2];
}

- (void)goback {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushDetail {
    [self.navigationController pushViewController:[TaobaoAnimationViewController new] animated:YES];
}

- (void)handleTapGesture:(UIGestureRecognizer*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 3DTouch peek的代理方法，轻按即可触发弹出vc
- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    TaobaoAnimationViewController *detail = [[TaobaoAnimationViewController alloc] init];
    return detail;
}
#pragma mark -  pop的代理方法，在此处可对将要进入的vc进行处理
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

#pragma mark - 3DTouch preview上滑
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    UIPreviewAction * action1 = [UIPreviewAction actionWithTitle:@"收藏" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"收藏");
    }];
    
    UIPreviewAction * action2 = [UIPreviewAction actionWithTitle:@"喜欢" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"喜欢");
    }];
    
    NSArray *items = @[action1,action2];
    return items;
}

#pragma mark - UINavigationControllerDelegate

/**
 * 定义一个不带交互的转场动画
 */
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (fromVC == self && [toVC isMemberOfClass:[TransitionListViewController class]]) {
        return [[DetailToFlowMoveTranstion alloc] init];
    }else{
        return nil;
    }
}

/**
 *  给转场动画添加交互
 *  注意点：该方法的执行时机，只有在实现了上面一个方法后，且返回不为空，下面这个方法才会执行，也就是说只有自定义了一个
 *  转场动画，下面这个交互转场百分比的方法才会执行
 *  UIKit->UIPercentDrivenInteractiveTransition这个类实现了UIViewControllerInteractiveTransitioning协议
 */
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    if ([animationController isKindOfClass:[DetailToFlowMoveTranstion class]]) {
        return _percentDrivenInteractiveTransition;
    }else{
        return nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - view getters

- (UIImageView *)iconImgV {
    
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc] init];
        _iconImgV.image = [UIImage imageNamed:@"nature.jpg"];
    }
    return _iconImgV;
}

- (UILabel *)promptLabel2 {
    
    if (!_promptLabel2) {
        _promptLabel2 = [[UILabel alloc] init];
        _promptLabel2.text = @"轻触图片返回";
        _promptLabel2.textColor = [UIColor whiteColor];
        _promptLabel2.textAlignment = NSTextAlignmentCenter;
        _promptLabel2.font = [UIFont systemFontOfSize:14.0f];
    }
    return _promptLabel2;
}

- (UILabel *)promptLabel1 {
    
    if (!_promptLabel1) {
        _promptLabel1 = [[UILabel alloc] init];
        _promptLabel1.text = @"按压图片弹起";
        _promptLabel1.textColor = [UIColor whiteColor];
        _promptLabel1.textAlignment = NSTextAlignmentCenter;
        _promptLabel1.font = [UIFont systemFontOfSize:14.0f];
    }
    return _promptLabel1;
}

@end
