//
//  DSLAnimatedTransitioning.h
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/25.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLAnimatedTransitioning : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (assign, nonatomic) NSInteger type;

@property (weak, nonatomic) UIViewController *presentViewController;

- (instancetype)initWithPresentViewController:(UIViewController *)presentViewController;

@end
