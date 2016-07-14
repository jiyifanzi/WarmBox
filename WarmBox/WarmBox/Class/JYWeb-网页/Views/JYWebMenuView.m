//
//  JYWebMenuView.m
//  WarmBox
//
//  Created by JiYi on 16/7/13.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWebMenuView.h"

#define AnimiationDuration 0.6  // 时间
#define delta 60   //按钮间的间距

@interface JYWebMenuView ()

//  返回按钮
@property (nonatomic, strong) UIButton * backBtn;

// 仿真器，仿真环境，操场
@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

@implementation JYWebMenuView

#pragma mark - 懒加载
- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return _animator;
}

+ (instancetype)WebMenu {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //  创建主按钮
        [self createBackBtn];
    }
    return self;
}

#pragma mark - 创建主菜单
- (void)createBackBtn {
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"clock_pause"] forState:UIControlStateNormal];
    _backBtn.frame = CGRectMake(0, 1, 48, 48);
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.userInteractionEnabled = NO;
    [self addSubview:_backBtn];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:@[self.backBtn]];
    
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:nil];
    
    //  移除之前的行为
//    [self.animator removeAllBehaviors];
//    //  创建捕捉行为
//    UISnapBehavior * snap = [[UISnapBehavior alloc] initWithItem:self snapToPoint:point];
//    //  设置抖动系数
//    snap.damping = 0.9;
    
    // 增加一个碰撞检测
   
    
    //  添加
//    [self.animator addBehavior:snap];
    
    self.center = point;
}

//  主按钮的点击事件
- (void)backBtnClick {
    
}

@end
