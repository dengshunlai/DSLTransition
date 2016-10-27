//
//  PictureViewController.m
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/26.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import "PictureViewController.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        _image = image;
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.frame = CGRectMake(25, 80, [UIScreen mainScreen].bounds.size.width - 50, ([UIScreen mainScreen].bounds.size.width - 50) * 125 / 100);
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:_imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
