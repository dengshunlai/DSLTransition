//
//  UIViewController+DSLTransition.m
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/24.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import "UIViewController+DSLTransition.h"
#import "DSLAnimatedTransitioning.h"
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
        self.dsl_animatedTransitioning.presentViewController = viewController;
    } else {
        viewController.transitioningDelegate = nil;
    }
    [self dsl_presentViewController:viewController animated:YES completion:completion];
}

@end
