//
//  DSLAnimatedTransitioning.m
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/25.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import "DSLAnimatedTransitioning.h"

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
