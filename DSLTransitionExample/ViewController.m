//
//  ViewController.m
//  DSLTransition
//
//  Created by 邓顺来 on 16/10/24.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import "PictureViewController.h"
#import "UIViewController+DSLTransition.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //开启自定义转场
    self.dsl_transitionEnabled = YES;
    //关闭
    //self.dsl_transitionEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)type0:(UIButton *)sender {
    //转场类型
    self.dsl_transitionType = 0;
    NextViewController *vc = [[NextViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type1:(UIButton *)sender {
    self.dsl_transitionType = 1;
    NextViewController *vc = [[NextViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type2:(UITapGestureRecognizer *)sender {
    UIImageView *iv = (UIImageView *)sender.view;
    self.dsl_transitionType = 2;
    PictureViewController *vc = [[PictureViewController alloc] initWithImage:iv.image];
    [self dsl_setTransitionFromView:sender.view toView:vc.imageView];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
