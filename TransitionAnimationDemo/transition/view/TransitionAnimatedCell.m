//
//  TransitionAnimatedCell.m
//  TransitionAnimatedDemo
//
//  Created by Turbo on 2017/6/28.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "TransitionAnimatedCell.h"

@implementation TransitionAnimatedCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.iconImgV.frame = CGRectMake(.0f, .0f, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.iconImgV.image = [UIImage imageNamed:@"nature.jpg"];
        [self.contentView addSubview:self.iconImgV];
    }
    
    return self;
}

#pragma mark - view getters

- (UIImageView *)iconImgV {
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc] init];
    }
    return _iconImgV;
}

@end
