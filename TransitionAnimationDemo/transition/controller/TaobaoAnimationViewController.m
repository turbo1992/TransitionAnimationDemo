//
//  TaobaoAnimationViewController.m
//  TransitionAnimatedDemo
//
//  Created by Turbo on 2017/6/28.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "TaobaoAnimationViewController.h"

@implementation TaobaoAnimationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    
}

#pragma mark - 初始化UI
- (void)initUI {
    
    // 动画底板
    self.mainBackgroundView = [[UIView alloc] init];
    self.mainBackgroundView.frame = self.view.bounds;
    self.mainBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainBackgroundView];
    
    // 黑色半透明蒙板
    self.maskView = [[UIView alloc] initWithFrame:self.view.frame];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker:)]];
    [self.view addSubview:self.maskView];
    self.maskView.hidden = YES;
    
    UIView *navbarView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, IphoneWidth, 64.0f)];
    navbarView.backgroundColor = RGBCOLOR(25, 136, 53);
    [self.mainBackgroundView addSubview:navbarView];
    
    // 自定义标题
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(.0f, 20.0f, self.view.frame.size.width, 44.0f);
    title.text = @"仿淘宝动画";
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = RGBCOLOR(25, 136, 53);
    title.textAlignment = NSTextAlignmentCenter;
    [self.mainBackgroundView addSubview:title];
    
    // 返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(5, 22, 40 , 40);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.mainBackgroundView addSubview:backButton];
    
    // 图片
    self.iconImgV.frame = CGRectMake(.0f, 64.0f, self.view.frame.size.width, self.view.frame.size.width/1.33);
    [self.mainBackgroundView addSubview:self.iconImgV];
    
    // 添加触摸手势返回
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture)];
    tapGesture.numberOfTapsRequired=1;
    self.iconImgV.userInteractionEnabled = YES;
    [self.iconImgV addGestureRecognizer:tapGesture];
    
    // 购物车
    self.shopChoiceView = [[UIView alloc] init];
    self.shopChoiceView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.6);
    self.shopChoiceView.backgroundColor = [UIColor whiteColor];
    [[[UIApplication sharedApplication].delegate window] addSubview:self.shopChoiceView];
}

- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleTapGesture {
    
    self.view.backgroundColor = [UIColor blackColor];
    self.maskView.hidden = NO;

    [UIView animateWithDuration:0.6 animations:^{
        // 优化页面跳出效果
        CGRect mainBackgroundViewFrame              = self.mainBackgroundView.frame;
        mainBackgroundViewFrame.origin.y            = .0f;
        self.mainBackgroundView.frame       = mainBackgroundViewFrame;
        self.maskView.alpha                 = 0.6f;
    }];
    
    // 仿淘宝动画方法
    [self popOnAnimate];
    
    // 弹出购物车
    [UIView animateWithDuration:0.5f animations:^{
        
        self.shopChoiceView.frame = CGRectMake(0, self.view.frame.size.height*0.4, self.view.frame.size.width, self.view.frame.size.height*0.6);
    }];
}

- (void)hideMyPicker:(UIGestureRecognizer*)sender {
    
    self.maskView.hidden = YES;

    [self popOffAnimate];
    
    // 收起购物车
    [UIView animateWithDuration:0.5f animations:^{
        
        self.shopChoiceView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.6);
    }];
}

#pragma mark - 仿淘宝动画方法，跳出
- (void)popOnAnimate {
    
    self.mainBackgroundView.layer.zPosition = -400;
    //---弹出动画
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //---第一步形变：绕X轴旋转并缩小
        [self.mainBackgroundView.layer setTransform:[self firstTransform]];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //---第二步形变：向上移动，并缩小
            [self.mainBackgroundView.layer setTransform:[self secondTransform]];
            
        } completion:^(BOOL finished) {
        }];
        
    }];
}

#pragma mark - 仿淘宝动画方法，关闭
- (void)popOffAnimate {
    
    //---收起动画
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //---第一步形变：绕X轴旋转并缩小
        [self.mainBackgroundView.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //---第二步形变：回到初始位置
            [self.mainBackgroundView.layer setTransform:CATransform3DIdentity];
            
        } completion:^(BOOL finished) {
            self.view.backgroundColor = [UIColor whiteColor];
        }];
        
    }];
}

#pragma mark - 变换操作，第一步变换
- (CATransform3D )firstTransform {
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0/ -900;
    //---宽高缩小0.9
    transform = CATransform3DScale(transform, 0.9, 0.9, 1);
    //---绕X轴旋转15度
    transform = CATransform3DRotate(transform, 15.0 * M_PI / 180.0 , 1, 0, 0);
    
    return transform;
}

#pragma mark - 变换操作，第二步变换
- (CATransform3D )secondTransform {
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = [self firstTransform].m34;
    //---向上移动的高度
    transform = CATransform3DTranslate(transform, .0f, -20.0f , .0f);
    //---宽高缩小0.85
    transform = CATransform3DScale(transform, 0.85, 0.85, 1);
    
    return transform;
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

- (CGSize)preferredContentSize {
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width/1.33+64.0f);
    return size;
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

@end
