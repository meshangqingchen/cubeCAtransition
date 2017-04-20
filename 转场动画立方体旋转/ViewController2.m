//
//  ViewController2.m
//  AnimationTransition_OC
//
//  Created by 3D on 2017/4/16.
//  Copyright © 2017年 TOMO. All rights reserved.
//

#import "ViewController2.h"
#import "ViewController3.h"
#import "LCPopAnimateTransition.h"
#import "LCPushAnimateTransition.h"
@interface ViewController2 ()<UINavigationControllerDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [bt setTitle:@"pop" forState:0];
    bt.backgroundColor = [UIColor redColor];
    [bt addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    UIButton *bt2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    [bt2 setTitle:@"继续push" forState:0];
    bt2.backgroundColor = [UIColor redColor];
    [bt2 addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt2];

    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:gesture];
}

#pragma mark UIViewController methods

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    self.navigationController.delegate = self;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}


-(void)click:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)click2:(UIButton *)sender{
    ViewController3 *vc3 = [ViewController3 new];
    [self.navigationController pushViewController:vc3 animated:YES];
}


#pragma mark UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    
    if (UINavigationControllerOperationPush == operation) {
        return [LCPushAnimateTransition new];
    }
    else if(UINavigationControllerOperationPop == operation) {
        return [LCPopAnimateTransition new];
    }else{
        return nil;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
    return self.interactivePopTransition;
}

- (void)handleGesture:(UIPanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].y / ((self.view.frame.size.height-64) * 1.0);
    NSLog(@" =  == %f",progress);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // Create a interactive transition and pop the view controller
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.5) {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
    
}

@end

