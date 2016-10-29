//
//  DSLAnimatedTransitioning.h
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/25.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLAnimatedTransitioning : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, CAAnimationDelegate>

/**
 转场类型
 */
@property (assign, nonatomic) NSInteger type;

/**
 被present的VC
 */
@property (weak, nonatomic) UIViewController *presentViewController;

/**
 发出present的VC
 */
@property (weak, nonatomic) UIViewController *presentSenderViewController;

@property (weak, nonatomic) UIView *fromView;

@property (weak, nonatomic) UIView *toView;

@property (assign, nonatomic) CGRect fromRect;

@property (assign, nonatomic) CGSize size;

- (instancetype)initWithPresentViewController:(UIViewController *)presentViewController;

@end
