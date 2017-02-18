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
    
    
    //添加一个手势，展示如何实现交互式present，动画采用type5
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(presentUseType5:)];
    [self.view addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
//0-6种转场效果
- (IBAction)type0:(UIButton *)sender {
    //转场类型
    self.dsl_transitionType = 0;
    self.dsl_transition_height = 350;
    NextViewController *vc = [[NextViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type1:(UIButton *)sender {
    self.dsl_transitionType = 1;
    self.dsl_transition_height = 450;
    //self.dsl_transition_scale = 0.9;
    NextViewController *vc = [[NextViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type2:(UITapGestureRecognizer *)sender {
    UIImageView *iv = (UIImageView *)sender.view;
    self.dsl_transitionType = 2;
    PictureViewController *vc = [[PictureViewController alloc] initWithImage:iv.image];
    [self dsl_transition_setFromView:sender.view toView:vc.imageView];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type3:(UIButton *)sender {
    self.dsl_transitionType = 3;
    PictureViewController *vc = [[PictureViewController alloc] initWithImage:[UIImage imageNamed:@"2.jpg"]];
    self.dsl_transition_fromRect = sender.frame;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type4:(UIButton *)sender {
    self.dsl_transitionType = 4;
    NextViewController *vc = [[NextViewController alloc] init];
    vc.view.layer.cornerRadius = 10;
    vc.view.layer.masksToBounds = YES;
    self.dsl_transition_size = CGSizeMake(250, 250);
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type5:(UIButton *)sender {
    self.dsl_transitionType = 5;
    //self.dsl_transition_width = 200;
    NextViewController *vc = [[NextViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type6:(UIButton *)sender {
    self.dsl_transitionType = 6;
    self.dsl_transition_height = [UIScreen mainScreen].bounds.size.height - 64 - 50;
    NextViewController *vc = [[NextViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Gesture
//右划出现抽屉的效果
- (void)presentUseType5:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.dsl_transitionType = 5;
            NextViewController *vc = [[NextViewController alloc] init];
            self.dsl_animatedTransitioning.isInteractive = YES;
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [pan translationInView:pan.view];
            CGFloat percent = translation.x / 250.0;
            if (percent >= 1) {
                [self.dsl_animatedTransitioning finishInteractiveTransition];
            } else {
                [self.dsl_animatedTransitioning updateInteractiveTransition:percent];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint translation = [pan translationInView:pan.view];
            CGFloat percent = translation.x / 250.0;
            if (percent > 0.50) {
                [self.dsl_animatedTransitioning finishInteractiveTransition];
            } else {
                [self.dsl_animatedTransitioning cancelInteractiveTransition];
            }
            self.dsl_animatedTransitioning.isInteractive = NO;
        }
            break;
        default:
            break;
    }
}

@end
