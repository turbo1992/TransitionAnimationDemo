//
//  TransitionListViewController.m
//  TransitionAnimationDemo
//
//  Created by Turbo on 2017/6/28.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "TransitionListViewController.h"
#import "TransitionAnimatedCell.h"
#import "MySimpleWaterFlowLayout.h"
#import "TransDetailViewController.h"
#import "FlowToDetailMoveTransition.h"
#import <objc/runtime.h>

static char indexPathAssociation;

@interface TransitionListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, MySimpleWaterFlowLayoutDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIViewControllerPreviewingDelegate>

@end

@implementation TransitionListViewController

#pragma mark - 添加代理和取消代理

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
    
    if (self.navigationController.interactivePopGestureRecognizer.delegate == self) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"TransitionList";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];

}

- (void)initUI {
        
    [self.view addSubview:self.collectionView];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    /* 当前点击item */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width - 65, 5, 45, 30);
    [button setTitle:@"0" forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:button];
    [self addAssion:button];
}

#pragma mark - WaterFlowLayoutDelegate
- (CGFloat)alw_collectionView:(UICollectionView *)collectionView layout:(MySimpleWaterFlowLayout *)collectionViewLayout heightForWidth:(CGFloat)width indexPath:(NSIndexPath *)indexPath {
    return width/1.33;
}

- (NSInteger)alw_collectionView:(UICollectionView *)collectionView layout:(MySimpleWaterFlowLayout *)collectionViewLayout columnCountForSection:(NSInteger)section {
    return 2;
}

#pragma mark - UICollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"TransitionAnimatedCell";
    TransitionAnimatedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
   
    [self registerForPreviewingWithDelegate:self sourceView:cell];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIButton *button = [self getAssociation];
    NSString *currentindex = [NSString stringWithFormat:@"%ld",indexPath.row];
    [button setTitle:currentindex forState:UIControlStateNormal];

    TransDetailViewController *detail = [[TransDetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (fromVC == self && [toVC isMemberOfClass:[TransDetailViewController class]]){
        return [[FlowToDetailMoveTransition alloc] init];
    }
    return nil;
}

#pragma mark - 3DTouch peek的代理方法,轻按即可触发弹出vc
- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    // 用于显示预览的vc
    TransDetailViewController *detail = [[TransDetailViewController alloc] init];
    return detail;
}

#pragma mark -  pop的代理方法,在此处可对将要进入的vc进行处理
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - view getters
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        MySimpleWaterFlowLayout * mySimpleWaterFlowLayout = [[MySimpleWaterFlowLayout alloc] init];
        mySimpleWaterFlowLayout.headerHeight = 10;
        mySimpleWaterFlowLayout.footerHeight = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, IphoneWidth, IphoneHeight) collectionViewLayout:mySimpleWaterFlowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[TransitionAnimatedCell class] forCellWithReuseIdentifier:@"TransitionAnimatedCell"];
    }
    return _collectionView;
}

#pragma mark - objc_Association

- (void)addAssion:(id)objc {
    objc_setAssociatedObject(self, &indexPathAssociation, objc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)getAssociation {
    id objc = objc_getAssociatedObject(self, &indexPathAssociation);
    if ([objc isKindOfClass:[UIButton class]] && objc) {
        return objc;
    }
    return nil;
}

- (void)dealloc {
    objc_setAssociatedObject(self, &indexPathAssociation, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_removeAssociatedObjects(self);
}

@end
