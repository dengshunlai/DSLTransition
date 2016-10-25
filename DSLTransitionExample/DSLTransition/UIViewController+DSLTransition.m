//
//  UIViewController+DSLTransition.m
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/24.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import "UIViewController+DSLTransition.h"
#import <objc/runtime.h>

@interface UIViewController ()

@property (strong, nonatomic) DSLAnimatedTransitioning *dsl_animatedTransitioning;

@end

@implementation UIViewController (DSLTransition)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method original = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
        Method exchanged = class_getInstanceMethod(self, @selector(dsl_presentViewController:animated:completion:));
        method_exchangeImplementations(original, exchanged);
    });
}

- (BOOL)dsl_transitionEnabled
{
    return [objc_getAssociatedObject(self, @selector(dsl_transitionEnabled)) boolValue];
}

- (void)setDsl_transitionEnabled:(BOOL)dsl_transitionEnabled
{
    objc_setAssociatedObject(self, @selector(dsl_transitionEnabled), [NSNumber numberWithBool:dsl_transitionEnabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)dsl_transitionType
{
    return [objc_getAssociatedObject(self, @selector(dsl_transitionType)) integerValue];
}

- (void)setDsl_transitionType:(NSInteger)dsl_transitionType
{
    objc_setAssociatedObject(self, @selector(dsl_transitionType), [NSNumber numberWithInteger:dsl_transitionType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DSLAnimatedTransitioning *)dsl_animatedTransitioning
{
    DSLAnimatedTransitioning *animator = objc_getAssociatedObject(self, @selector(dsl_animatedTransitioning));
    if (!animator) {
        self.dsl_animatedTransitioning = animator = [[DSLAnimatedTransitioning alloc] init];
    }
    return animator;
}

- (void)setDsl_animatedTransitioning:(DSLAnimatedTransitioning *)dsl_animatedTransitioning
{
    objc_setAssociatedObject(self, @selector(dsl_animatedTransitioning), dsl_animatedTransitioning, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dsl_presentViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion
{
    if (self.dsl_transitionEnabled) {
        viewController.transitioningDelegate = self.dsl_animatedTransitioning;
        self.dsl_animatedTransitioning.type = self.dsl_transitionType;
    } else {
        viewController.transitioningDelegate = nil;
    }
    [self dsl_presentViewController:viewController animated:YES completion:completion];
}

@end


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface DSLAnimatedTransitioning ()

@property (assign, nonatomic) BOOL isPresent;

@end

@implementation DSLAnimatedTransitioning

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    
    if (_type == 0) {
        if (_isPresent) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            bgView.alpha = 0;
            bgView.tag = 2000;
            UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:YES];
            
            toView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
            [containerView addSubview:fromViewSnapshot];
            [containerView addSubview:bgView];
            [containerView addSubview:toView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                bgView.alpha = 1;
                toView.frame = CGRectMake(0, CGRectGetMaxY(fromView.frame) - 350, kScreenWidth, kScreenHeight);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        } else {
            UIView *bgView;
            for (UIView *view in containerView.subviews) {
                if (view.tag == 2000) {
                    bgView = view;
                }
            }
            toView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [containerView insertSubview:toView belowSubview:bgView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                bgView.alpha = 0;
                fromView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
            } completion:^(BOOL finished) {
                NSLog(@"%@",containerView.subviews);
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
    } else if (_type == 1) {
        ;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _isPresent = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _isPresent = NO;
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

@end
