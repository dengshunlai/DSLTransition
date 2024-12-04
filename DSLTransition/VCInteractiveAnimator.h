//
//  DSLAnimatedTransitioning.h
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/25.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DSLTransitionStyle) {
    DSLTransitionStyleNone = 0,
    DSLTransitionStyleBottomTranslationTap,
    DSLTransitionStyleBottomTranslationPan,
    DSLTransitionStyleFromTo,
    DSLTransitionStyleCircularEnlarge,
    DSLTransitionStyleCenterGradient,
    DSLTransitionStyleLeftTransitionTap,
    DSLTransitionStyleBottomTranslationScaleTap,
    DSLTransitionStyleCenterSpring,
    DSLTransitionStyleLeftTranslutionPan,
    DSLTransitionStyleRightTranslutionPan,
};

typedef NS_ENUM(NSUInteger, DSLTransitionType) {
    DSLTransitionTypeNone = DSLTransitionStyleNone,
    DSLTransitionType1 = DSLTransitionStyleBottomTranslationTap,
    DSLTransitionType2 = DSLTransitionStyleBottomTranslationPan,
    DSLTransitionType3 = DSLTransitionStyleFromTo,
    DSLTransitionType4 = DSLTransitionStyleCircularEnlarge,
    DSLTransitionType5 = DSLTransitionStyleCenterGradient,
    DSLTransitionType6 = DSLTransitionStyleLeftTransitionTap,
    DSLTransitionType7 = DSLTransitionStyleBottomTranslationScaleTap,
    DSLTransitionType8 = DSLTransitionStyleCenterSpring,
    DSLTransitionType9 = DSLTransitionStyleLeftTranslutionPan,
    DSLTransitionType10 = DSLTransitionStyleRightTranslutionPan,
};

@interface VCInteractiveAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, CAAnimationDelegate>

/**
 转场类型
 */
@property (assign, nonatomic) DSLTransitionType type;

/**
 被present的VC
 */
@property (weak, nonatomic) UIViewController *presentViewController;

/**
 发出present的VC
 */
@property (weak, nonatomic) UIViewController *presentSenderViewController;

/**
 是否进行交互式转场，暴露这个属性出来用于手动实现交互式present
 */
@property (assign, nonatomic) BOOL isInteractive;

/**
 type = 3 时有效
 */
@property (weak, nonatomic) UIView *fromView;

/**
 type = 3 时有效
 */
@property (weak, nonatomic) UIView *toView;

/**
 type = 4时有效，转场开始时，圆圈的位置、大小
 */
@property (assign, nonatomic) CGRect fromRect;

/**
 type = 5、8时有效，视窗大小
 */
@property (assign, nonatomic) CGSize size;

/**
 type = 6、9时有效，抽屉伸出的宽度，默认 屏幕宽度-70
 */
@property (assign, nonatomic) CGFloat width;

/**
 type = 1、2、7时有效，抽屉伸出的高度，默认 280
 */
@property (assign, nonatomic) CGFloat height;

/**
 type = 2、7时有效，默认0.85
 */
@property (assign, nonatomic) CGFloat scale;

@end
