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

- (DSLAnimatedTransitioning *)dsl_animatedTransitioning
{
    DSLAnimatedTransitioning *animator = objc_getAssociatedObject(self, @selector(dsl_animatedTransitioning));
    if (!animator) {
        self.dsl_animatedTransitioning = animator = [[DSLAnimatedTransitioning alloc] init];
        animator.presentViewController = self;
    }
    return animator;
}

- (void)setDsl_animatedTransitioning:(DSLAnimatedTransitioning *)dsl_animatedTransitioning
{
    objc_setAssociatedObject(self, @selector(dsl_animatedTransitioning), dsl_animatedTransitioning, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DSLTransitionType)dsl_transitionType
{
    return self.dsl_animatedTransitioning.type;
}

- (void)setDsl_transitionType:(DSLTransitionType)dsl_transitionType
{
    self.dsl_animatedTransitioning.type = dsl_transitionType;
}

- (UIView *)dsl_transition_fromView
{
    return self.dsl_animatedTransitioning.fromView;
}

- (void)setDsl_transition_fromView:(UIView *)dsl_transition_fromView
{
    self.dsl_animatedTransitioning.fromView = dsl_transition_fromView;
}

- (UIView *)dsl_transition_toView
{
    return self.dsl_animatedTransitioning.toView;
}

- (void)setDsl_transition_toView:(UIView *)dsl_transition_toView
{
    self.dsl_animatedTransitioning.toView = dsl_transition_toView;
}

- (CGRect)dsl_transition_fromRect
{
    return self.dsl_animatedTransitioning.fromRect;
}

- (void)setDsl_transition_fromRect:(CGRect)dsl_transition_fromRect
{
    self.dsl_animatedTransitioning.fromRect = dsl_transition_fromRect;
}

- (CGSize)dsl_transition_size
{
    return self.dsl_animatedTransitioning.size;
}

- (void)setDsl_transition_size:(CGSize)dsl_transition_size
{
    self.dsl_animatedTransitioning.size = dsl_transition_size;
}

- (CGFloat)dsl_transition_width
{
    return self.dsl_animatedTransitioning.width;
}

- (void)setDsl_transition_width:(CGFloat)dsl_transition_width
{
    self.dsl_animatedTransitioning.width = dsl_transition_width;
}

- (CGFloat)dsl_transition_height
{
    return self.dsl_animatedTransitioning.height;
}

- (void)setDsl_transition_height:(CGFloat)dsl_transition_height
{
    self.dsl_animatedTransitioning.height = dsl_transition_height;
}

- (CGFloat)dsl_transition_scale
{
    return self.dsl_animatedTransitioning.scale;
}

- (void)setDsl_transition_scale:(CGFloat)dsl_transition_scale
{
    self.dsl_animatedTransitioning.scale = dsl_transition_scale;
}

- (void)dsl_transition_setFromView:(UIView *)fromView toView:(UIView *)toView
{
    self.dsl_transition_fromView = fromView;
    self.dsl_transition_toView = toView;
}

- (void)dsl_presentViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion
{
    if (viewController.dsl_transitionType != DSLTransitionTypeNone) {
        viewController.transitioningDelegate = viewController.dsl_animatedTransitioning;
        viewController.dsl_animatedTransitioning.presentSenderViewController = self;
        viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    } else {
        if ([viewController.transitioningDelegate isKindOfClass:[DSLAnimatedTransitioning class]]) {
            viewController.transitioningDelegate = nil;
        }
    }
    [self dsl_presentViewController:viewController animated:flag completion:completion];
}

@end
