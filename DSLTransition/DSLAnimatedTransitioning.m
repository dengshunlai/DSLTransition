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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = DSLTransitionTypeNone;
        _width = kScreenWidth - 70;
        _height = 280;
        _scale = 0.85;
        _size = CGSizeMake(280, 280);
    }
    return self;
}

- (void)dealloc {
    ;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case DSLTransitionType4:
            return 0.55;
            break;
        case DSLTransitionType5:
            return 0.25;
            break;
        case DSLTransitionType8:
            return 0.25;
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
    
    if (_type == DSLTransitionType1) {
        if (_isPresent) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            bgView.alpha = 0;
            bgView.tag = 2001;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDismissTap:)];
            [bgView addGestureRecognizer:tap];
            
            toView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _height);
            [containerView addSubview:bgView];
            [containerView addSubview:toView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                bgView.alpha = 1;
                toView.frame = CGRectMake(0, kScreenHeight - _height, kScreenWidth, _height);
            } completion:^(BOOL finished) {
                UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:YES];
                [containerView insertSubview:fromViewSnapshot belowSubview:bgView];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        } else {
            UIView *bgView = [containerView viewWithTag:2001];
            toView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [containerView insertSubview:toView belowSubview:bgView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                bgView.alpha = 0;
                fromView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _height);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
    } else if (_type == DSLTransitionType2) {
        if (_isPresent) {
            toView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _height);
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
                fromView.transform = CGAffineTransformScale(fromView.transform, _scale, _scale);
                toView.frame = CGRectMake(0, kScreenHeight - _height, kScreenWidth, _height);
            } completion:^(BOOL finished) {
                UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
                fromViewSnapshot.tag = 2002;
                fromViewSnapshot.transform = CGAffineTransformScale(fromViewSnapshot.transform, _scale, _scale);
                [containerView insertSubview:fromViewSnapshot belowSubview:toView];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDismissPanY:)];
                [fromViewSnapshot addGestureRecognizer:pan];
                [fromView.layer removeAnimationForKey:@"cornerRadius"];
            }];
        } else {
            UIView *toViewSnapshot = [containerView viewWithTag:2002];
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                toViewSnapshot.transform = CGAffineTransformIdentity;
                fromView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _height);
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
    } else if (_type == DSLTransitionType3) {
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
    } else if (_type == DSLTransitionType4) {
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
    } else if (_type == DSLTransitionType5) {
        if (_isPresent) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            bgView.alpha = 0;
            bgView.tag = 2005;
            [containerView addSubview:bgView];
            
            toView.frame = CGRectMake(0, 0, _size.width, _size.height);
            toView.center = containerView.center;
            toView.alpha = 0;
            [containerView addSubview:toView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                toView.alpha = 1;
                bgView.alpha = 1;
            } completion:^(BOOL finished) {
                UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
                [containerView insertSubview:fromViewSnapshot belowSubview:bgView];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDismissTap:)];
                [bgView addGestureRecognizer:tap];
            }];
        } else {
            UIView *bgView = [containerView viewWithTag:2005];
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                bgView.alpha = 0;
                fromView.alpha = 0;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
    } else if (_type == DSLTransitionType6) {
        if (_isPresent) {
            toView.frame = CGRectMake(-_width, 0, _width, kScreenHeight);
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];;
            bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            bgView.alpha = 0;
            bgView.tag = 2006;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDismissTap:)];
            [bgView addGestureRecognizer:tap];
            
            [containerView addSubview:bgView];
            [containerView addSubview:toView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                bgView.alpha = 1;
                toView.frame = CGRectMake(0, 0, _width, kScreenHeight);
                fromView.frame = CGRectMake(100, 0, kScreenWidth, kScreenHeight);
            } completion:^(BOOL finished) {
                UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
                fromViewSnapshot.frame = CGRectMake(100, 0, kScreenWidth, kScreenHeight);
                [containerView insertSubview:fromViewSnapshot belowSubview:bgView];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        } else {
            UIView *bgView = [containerView viewWithTag:2006];
            [containerView insertSubview:toView belowSubview:bgView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                bgView.alpha = 0;
                toView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                fromView.frame = CGRectMake(-_width, 0, _width, kScreenHeight);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
    } else if (_type == DSLTransitionType7) {
        if (_isPresent) {
            toView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _height);
            [containerView addSubview:toView];
            
            UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            bg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            [containerView insertSubview:bg belowSubview:toView];
            bg.tag = 20071;
            bg.alpha = 0;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                fromView.transform = CGAffineTransformScale(fromView.transform, _scale, _scale);
                toView.frame = CGRectMake(0, kScreenHeight - _height, kScreenWidth, _height);
                bg.alpha = 1;
            } completion:^(BOOL finished) {
                UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
                fromViewSnapshot.tag = 20072;
                fromViewSnapshot.transform = CGAffineTransformScale(fromViewSnapshot.transform, _scale, _scale);
                [containerView insertSubview:fromViewSnapshot belowSubview:bg];
                
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDismissTap:)];
                [bg addGestureRecognizer:tap];
            }];
        } else {
            UIView *toViewSnapshot = [containerView viewWithTag:20072];
            UIView *bg = [containerView viewWithTag:20071];
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                toViewSnapshot.transform = CGAffineTransformIdentity;
                fromView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _height);
                bg.alpha = 0;
            } completion:^(BOOL finished) {
                toView.transform = CGAffineTransformIdentity;
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
    } else if (_type == DSLTransitionType8) {
        if (_isPresent) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            bgView.alpha = 0;
            bgView.tag = 2008;
            [containerView addSubview:bgView];
            
            toView.frame = CGRectMake(0, 0, _size.width, _size.height);
            toView.center = containerView.center;toView.alpha = 0;
            [containerView addSubview:toView];
            
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                toView.transform = CGAffineTransformScale(toView.transform, 1.2, 1.2);
                bgView.alpha = 1;toView.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.10 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    toView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
                    [containerView insertSubview:fromViewSnapshot belowSubview:bgView];
                    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDismissTap:)];
                    [bgView addGestureRecognizer:tap];
                }];
            }];
        } else {
            UIView *bgView = [containerView viewWithTag:2008];
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                fromView.transform = CGAffineTransformScale(fromView.transform, 1.3, 1.3);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    bgView.alpha = 0;
                    fromView.transform = CGAffineTransformScale(fromView.transform, 0.05, 0.05);
                    fromView.alpha = 0;
                } completion:^(BOOL finished) {
                    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                }];
            }];
        }
    } else if (_type == DSLTransitionType9) {
        if (_isPresent) {
            toView.frame = CGRectMake(-_width, 0, _width, kScreenHeight);
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];;
            bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            bgView.alpha = 0;
            bgView.tag = 2009;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDismissTap:)];
            [bgView addGestureRecognizer:tap];
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDismissPanX:)];
            [toView addGestureRecognizer:pan];
            
            [containerView addSubview:bgView];
            [containerView addSubview:toView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                bgView.alpha = 1;
                toView.frame = CGRectMake(0, 0, _width, kScreenHeight);
                fromView.frame = CGRectMake(100, 0, kScreenWidth, kScreenHeight);
            } completion:^(BOOL finished) {
                UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
                fromViewSnapshot.frame = CGRectMake(100, 0, kScreenWidth, kScreenHeight);
                [containerView insertSubview:fromViewSnapshot belowSubview:bgView];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        } else {
            UIView *bgView = [containerView viewWithTag:2009];
            [containerView insertSubview:toView belowSubview:bgView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                bgView.alpha = 0;
                toView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                fromView.frame = CGRectMake(-_width, 0, _width, kScreenHeight);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
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
    return _isInteractive ? self : nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    switch (_type) {
        case DSLTransitionType2:
        case DSLTransitionType9:
            return _isInteractive ? self : nil;
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - GestureRecognizer

- (void)gestureDismissTap:(UITapGestureRecognizer *)tap
{
    [_presentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)gestureDismissPanY:(UIPanGestureRecognizer *)pan
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

- (void)gestureDismissPanX:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _isInteractive = YES;
            [_presentViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [pan translationInView:pan.view];
            CGFloat percent = -translation.x / _width;
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
            CGFloat percent = -translation.x / _width;
            if (percent > 0.30) {
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
