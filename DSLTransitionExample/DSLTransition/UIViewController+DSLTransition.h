//
//  UIViewController+DSLTransition.h
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/24.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DSLTransition)

/**
 是否开启自定义转场
 */
@property (assign, nonatomic) BOOL dsl_transitionEnabled;

/**
 转场类型
 */
@property (assign, nonatomic) NSInteger dsl_transitionType;

@end
