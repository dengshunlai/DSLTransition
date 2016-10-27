//
//  UIViewController+DSLTransition.h
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/24.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DSLTransition)

/**
 是否开启自定义转场
 */
@property (assign, nonatomic) BOOL dsl_transitionEnabled;

/**
 转场类型
 */
@property (assign, nonatomic) NSInteger dsl_transitionType;

/**
 type = 2 时有效
 */
@property (weak, nonatomic) UIView *dsl_transition_fromView;

/**
 type = 2 时有效
 */
@property (weak, nonatomic) UIView *dsl_transition_toView;

/**
 设置dsl_transition_fromView、dsl_transition_toView
 type = 2 时有效

 @param fromView dsl_transition_fromView
 @param toView   dsl_transition_toView
 */
- (void)dsl_setTransitionFromView:(UIView *)fromView toView:(UIView *)toView;

@end
