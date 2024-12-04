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

- (VCInteractiveAnimator *)dsl_interactiveAnimator
{
    VCInteractiveAnimator *animator = objc_getAssociatedObject(self, @selector(dsl_interactiveAnimator));
    if (!animator) {
        self.dsl_interactiveAnimator = animator = [[VCInteractiveAnimator alloc] init];
        animator.presentViewController = self;
    }
    return animator;
}

- (void)setDsl_interactiveAnimator:(VCInteractiveAnimator *)dsl_interactiveAnimator
{
    objc_setAssociatedObject(self, @selector(dsl_interactiveAnimator), dsl_interactiveAnimator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DSLTransitionType)dsl_transitionType
{
    return self.dsl_interactiveAnimator.type;
}

- (void)setDsl_transitionType:(DSLTransitionType)dsl_transitionType
{
    self.dsl_interactiveAnimator.type = dsl_transitionType;
}

- (UIView *)dsl_transition_fromView
{
    return self.dsl_interactiveAnimator.fromView;
}

- (void)setDsl_transition_fromView:(UIView *)dsl_transition_fromView
{
    self.dsl_interactiveAnimator.fromView = dsl_transition_fromView;
}

- (UIView *)dsl_transition_toView
{
    return self.dsl_interactiveAnimator.toView;
}

- (void)setDsl_transition_toView:(UIView *)dsl_transition_toView
{
    self.dsl_interactiveAnimator.toView = dsl_transition_toView;
}

- (CGRect)dsl_transition_fromRect
{
    return self.dsl_interactiveAnimator.fromRect;
}

- (void)setDsl_transition_fromRect:(CGRect)dsl_transition_fromRect
{
    self.dsl_interactiveAnimator.fromRect = dsl_transition_fromRect;
}

- (CGSize)dsl_transition_size
{
    return self.dsl_interactiveAnimator.size;
}

- (void)setDsl_transition_size:(CGSize)dsl_transition_size
{
    self.dsl_interactiveAnimator.size = dsl_transition_size;
}

- (CGFloat)dsl_transition_width
{
    return self.dsl_interactiveAnimator.width;
}

- (void)setDsl_transition_width:(CGFloat)dsl_transition_width
{
    self.dsl_interactiveAnimator.width = dsl_transition_width;
}

- (CGFloat)dsl_transition_height
{
    return self.dsl_interactiveAnimator.height;
}

- (void)setDsl_transition_height:(CGFloat)dsl_transition_height
{
    self.dsl_interactiveAnimator.height = dsl_transition_height;
}

- (CGFloat)dsl_transition_scale
{
    return self.dsl_interactiveAnimator.scale;
}

- (void)setDsl_transition_scale:(CGFloat)dsl_transition_scale
{
    self.dsl_interactiveAnimator.scale = dsl_transition_scale;
}

- (void)dsl_transition_setFromView:(UIView *)fromView toView:(UIView *)toView
{
    self.dsl_transition_fromView = fromView;
    self.dsl_transition_toView = toView;
}

- (void)dsl_presentViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion
{
    if (viewController.dsl_transitionType != DSLTransitionTypeNone) {
        viewController.transitioningDelegate = viewController.dsl_interactiveAnimator;
        viewController.dsl_interactiveAnimator.presentSenderViewController = self;
        viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    } else {
        if ([viewController.transitioningDelegate isKindOfClass:[VCInteractiveAnimator class]]) {
            viewController.transitioningDelegate = nil;
        }
    }
    [self dsl_presentViewController:viewController animated:flag completion:completion];
}

@end
