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

@property (strong, nonatomic) NextViewController *nextVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTopBar];
    
    _nextVC = [[NextViewController alloc] init];
    _nextVC.dsl_transitionType = DSLTransitionType9;
    //添加一个手势，展示如何实现交互式present，动画采用type9
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(presentUseType9:)];
    [self.view addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTopBar {
    UIBarButtonItem *normal = [[UIBarButtonItem alloc] initWithTitle:@"normal"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self action:@selector(normal)];
    self.navigationItem.leftBarButtonItem = normal;
}

//原生present转场
- (void)normal {
    NextViewController *vc = [[NextViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Action
//各种转场效果
- (IBAction)type1:(UIButton *)sender {
    NextViewController *vc = [[NextViewController alloc] init];
    vc.dsl_transitionType = DSLTransitionType1;
    vc.dsl_transition_height = 350;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type2:(UIButton *)sender {
    NextViewController *vc = [[NextViewController alloc] init];
    vc.dsl_transitionType = DSLTransitionType2;
    vc.dsl_transition_height = 450;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type3:(UITapGestureRecognizer *)sender {
    UIImageView *iv = (UIImageView *)sender.view;
    PictureViewController *vc = [[PictureViewController alloc] initWithImage:iv.image];
    vc.dsl_transitionType = DSLTransitionType3;
    [vc dsl_transition_setFromView:sender.view toView:vc.imageView];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type4:(UIButton *)sender {
    PictureViewController *vc = [[PictureViewController alloc] initWithImage:[UIImage imageNamed:@"2.jpg"]];
    vc.dsl_transitionType = DSLTransitionType4;
    vc.dsl_transition_fromRect = sender.frame;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type5:(UIButton *)sender {
    NextViewController *vc = [[NextViewController alloc] init];
    vc.view.layer.cornerRadius = 10;
    vc.view.layer.masksToBounds = YES;
    vc.dsl_transitionType = DSLTransitionType5;
    //vc.dsl_transition_size = CGSizeMake(250, 250);
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type6:(UIButton *)sender {
    NextViewController *vc = [[NextViewController alloc] init];
    vc.dsl_transitionType = DSLTransitionType6;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type7:(UIButton *)sender {
    NextViewController *vc = [[NextViewController alloc] init];
    vc.dsl_transitionType = DSLTransitionType7;
    vc.dsl_transition_height = [UIScreen mainScreen].bounds.size.height - 64 - 50;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type8:(UIButton *)sender {
    NextViewController *vc = [[NextViewController alloc] init];
    vc.view.layer.cornerRadius = 10;
    vc.view.layer.masksToBounds = YES;
    vc.dsl_transitionType = DSLTransitionType8;
    //vc.dsl_transition_size = CGSizeMake(250, 250);
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type9:(UIButton *)sender {
    NextViewController *vc = [[NextViewController alloc] init];
    vc.dsl_transitionType = DSLTransitionType9;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)type10:(UIButton *)sender {
    NextViewController *vc = [[NextViewController alloc] init];
    vc.dsl_transitionType = DSLTransitionType10;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Gesture
//右划出现抽屉的效果
- (void)presentUseType9:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            _nextVC.dsl_interactiveAnimator.isInteractive = YES;
            [self presentViewController:_nextVC animated:YES completion:nil];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [pan translationInView:pan.view];
            CGFloat percent = translation.x / 250.0;
            if (percent >= 1) {
                [_nextVC.dsl_interactiveAnimator finishInteractiveTransition];
            } else {
                [_nextVC.dsl_interactiveAnimator updateInteractiveTransition:percent];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint translation = [pan translationInView:pan.view];
            CGFloat percent = translation.x / 250.0;
            if (percent > 0.50) {
                [_nextVC.dsl_interactiveAnimator finishInteractiveTransition];
            } else {
                [_nextVC.dsl_interactiveAnimator cancelInteractiveTransition];
            }
            _nextVC.dsl_interactiveAnimator.isInteractive = NO;
        }
            break;
        default:
            break;
    }
}

@end
