//
//  UIViewController+DSLTransition.h
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/24.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCInteractiveAnimator.h"

@interface UIViewController (DSLTransition)

/**
 转场类型，默认DSLTransitionTypeNone
 */
@property (assign, nonatomic) DSLTransitionType dsl_transitionType;

/**
 转场动画控制器
 */
@property (strong, nonatomic, readonly) VCInteractiveAnimator *dsl_interactiveAnimator;

/**
 type = 3 时有效
 */
@property (weak, nonatomic) UIView *dsl_transition_fromView;

/**
 type = 3 时有效
 */
@property (weak, nonatomic) UIView *dsl_transition_toView;

/**
 type = 4时有效，转场开始时，圆圈的位置、大小
 */
@property (assign, nonatomic) CGRect dsl_transition_fromRect;

/**
 type = 5时有效，视窗大小
 */
@property (assign, nonatomic) CGSize dsl_transition_size;

/**
 type = 6、9时有效，抽屉伸出的宽度，默认 屏幕宽度-70
 */
@property (assign, nonatomic) CGFloat dsl_transition_width;

/**
 type = 1、2、7时有效，抽屉伸出的高度，默认 280
 */
@property (assign, nonatomic) CGFloat dsl_transition_height;

/**
 type = 2、7时有效，默认0.85
 */
@property (assign, nonatomic) CGFloat dsl_transition_scale;

/**
 设置dsl_transition_fromView、dsl_transition_toView
 type = 3 时有效

 @param fromView dsl_transition_fromView
 @param toView   dsl_transition_toView
 */
- (void)dsl_transition_setFromView:(UIView *)fromView toView:(UIView *)toView;

@end
