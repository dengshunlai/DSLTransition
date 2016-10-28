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
@property (assign, nonatomic) BOOL isInteractive;

@end

@implementation DSLAnimatedTransitioning

- (instancetype)initWithPresentViewController:(UIViewController *)presentViewController
{
    self = [super init];
    if (self) {
        _presentViewController = presentViewController;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case 3:
            return 0.55;
            break;
        default:
            return 0.35;
            break;
    }
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
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureType0:)];
            [bgView addGestureRecognizer:tap];
            
            toView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
            toView.layer.cornerRadius = 15;
            toView.layer.masksToBounds = YES;
            [containerView addSubview:bgView];
            [containerView addSubview:toView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                bgView.alpha = 1;
                toView.frame = CGRectMake(0, kScreenHeight - 280, kScreenWidth, kScreenHeight);
            } completion:^(BOOL finished) {
                UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:YES];
                [containerView insertSubview:fromViewSnapshot belowSubview:bgView];
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
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
    } else if (_type == 1) {
        if (_isPresent) {
            toView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 280);
            toView.layer.cornerRadius = 10;
            toView.layer.masksToBounds = YES;
            [containerView addSubview:toView];
            
            fromView.layer.masksToBounds = YES;
            CABasicAnimation *cornerAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            cornerAnimation.duration = [self transitionDuration:transitionContext];
            cornerAnimation.fillMode = kCAFillModeForwards;
            cornerAnimation.removedOnCompletion = NO;
            cornerAnimation.fromValue = @(0);
            cornerAnimation.toValue = @(10);
            [fromView.layer addAnimation:cornerAnimation forKey:@"cornerRadius"];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                fromView.transform = CGAffineTransformScale(fromView.transform, 0.85, 0.85);
                toView.frame = CGRectMake(0, kScreenHeight - 280, kScreenWidth, 280);
            } completion:^(BOOL finished) {
                UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
                fromViewSnapshot.tag = 2000;
                fromViewSnapshot.transform = CGAffineTransformScale(fromViewSnapshot.transform, 0.85, 0.85);
                [containerView insertSubview:fromViewSnapshot belowSubview:toView];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureType1:)];
                [fromViewSnapshot addGestureRecognizer:pan];
                [fromView.layer removeAnimationForKey:@"cornerRadius"];
            }];
        } else {
            UIView *toViewSnapshot;
            for (UIView *view in containerView.subviews) {
                if (view.tag == 2000) {
                    toViewSnapshot = view;
                }
            }
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                toViewSnapshot.transform = CGAffineTransformIdentity;
                fromView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 280);
            } completion:^(BOOL finished) {
                toView.transform = CGAffineTransformIdentity;
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                
                CABasicAnimation *cornerAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
                cornerAnimation.duration = 0.2;
                cornerAnimation.fromValue = @(10);
                cornerAnimation.toValue = @(0);
                [toView.layer addAnimation:cornerAnimation forKey:@"cornerRadius"];
            }];
        }
    } else if (_type == 2) {
        if (_isPresent) {
            toView.alpha = 0;
            toView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [containerView addSubview:toView];
            
            UIView *fromViewSnapshot = [_fromView snapshotViewAfterScreenUpdates:NO];
            fromViewSnapshot.frame = [_fromView convertRect:_fromView.bounds toView:containerView];
            [containerView addSubview:fromViewSnapshot];
            _fromView.hidden = YES;
            _toView.hidden = YES;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                fromViewSnapshot.frame = [_toView convertRect:_toView.bounds toView:containerView];
                toView.alpha = 1;
            } completion:^(BOOL finished) {
                _toView.hidden = NO;
                fromViewSnapshot.hidden = YES;
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        } else {
            [containerView insertSubview:toView belowSubview:fromView];
            
            UIView *fromViewSnapshot = containerView.subviews.lastObject;
            fromViewSnapshot.hidden = NO;
            _toView.hidden = YES;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                fromViewSnapshot.frame = [_fromView convertRect:_fromView.bounds toView:containerView];
                fromView.alpha = 0;
            } completion:^(BOOL finished) {
                _fromView.hidden = NO;
                fromViewSnapshot.hidden = YES;
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
    } else if (_type == 3) {
        if (_isPresent) {
            toView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [containerView addSubview:toView];
            if (CGRectIsEmpty(_fromRect)) {
                _fromRect = CGRectMake(CGRectGetWidth(_presentSenderViewController.view.bounds) / 2 - 10, CGRectGetHeight(_presentSenderViewController.view.bounds) / 2 - 10, 20, 20);
            }
            CGFloat radius = MIN(_fromRect.size.width, _fromRect.size.height);
            CGRect rect = [_presentSenderViewController.view convertRect:_fromRect toView:containerView];
            CGPoint center = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
            UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
            radius = sqrt(pow(containerView.bounds.size.width / 2, 2) + pow(containerView.bounds.size.height / 2, 2));
            UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = startPath.CGPath;
            toView.layer.mask = maskLayer;
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.fromValue = (__bridge id)startPath.CGPath;
            animation.toValue = (__bridge id)endPath.CGPath;
            animation.duration = [self transitionDuration:transitionContext];
            animation.delegate = self;
            [animation setValue:transitionContext forKey:@"transitionContext"];
            [maskLayer addAnimation:animation forKey:@"path"];
        } else {
            [containerView insertSubview:toView belowSubview:fromView];
            CGFloat radius = sqrt(pow(containerView.bounds.size.width / 2, 2) + pow(containerView.bounds.size.height / 2, 2));
            UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
            radius = MIN(_fromRect.size.width, _fromRect.size.height);
            CGRect rect = [_presentSenderViewController.view convertRect:_fromRect toView:containerView];
            CGPoint center = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
            UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = startPath.CGPath;
            fromView.layer.mask = maskLayer;
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.fromValue = (__bridge id)startPath.CGPath;
            animation.toValue = (__bridge id)endPath.CGPath;
            animation.duration = [self transitionDuration:transitionContext];
            animation.delegate = self;
            [animation setValue:transitionContext forKey:@"transitionContext"];
            [maskLayer addAnimation:animation forKey:@"path"];
        }
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
    switch (_type) {
        case 0:
            return nil;
            break;
        case 1:
            return _isInteractive ? self : nil;
            return nil;
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - Action

- (void)gestureType0:(UITapGestureRecognizer *)tap
{
    [_presentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)gestureType1:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _isInteractive = YES;
            [_presentViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [pan translationInView:pan.view];
            CGFloat percent = translation.y / 150.0;
            if (percent >= 1) {
                [self finishInteractiveTransition];
            } else {
                [self updateInteractiveTransition:percent];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint translation = [pan translationInView:pan.view];
            CGFloat percent = translation.y / 150.0;
            if (percent > 0.50) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            _isInteractive = NO;
        }
            break;
        default:
            break;
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    id <UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    if (_isPresent) {
        [toView.layer.mask removeAllAnimations];
        toView.layer.mask = nil;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    } else {
        [fromView.layer.mask removeAllAnimations];
        fromView.layer.mask = nil;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }
}

@end
