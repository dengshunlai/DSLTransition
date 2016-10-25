//
//  UIViewController+DSLTransition.h
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/24.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DSLTransition)

@property (assign, nonatomic) BOOL dsl_transitionEnabled;

@property (assign, nonatomic) NSInteger dsl_transitionType;

@end

@interface DSLAnimatedTransitioning : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (assign, nonatomic) NSInteger type;

@end
