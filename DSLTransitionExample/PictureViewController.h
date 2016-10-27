//
//  PictureViewController.h
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/26.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureViewController : UIViewController

- (instancetype)initWithImage:(UIImage *)image;

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) UIImageView *imageView;

@end
