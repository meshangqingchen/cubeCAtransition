//
//  ViewController1.m
//  AnimationTransition_OC
//
//  Created by 3D on 2017/4/16.
//  Copyright © 2017年 TOMO. All rights reserved.
//

#import "ViewController1.h"
#import "ViewController2.h"
#import "LCPushAnimateTransition.h"
#import "LCPopAnimateTransition.h"
@interface ViewController1 ()<UINavigationControllerDelegate>
@property(nonatomic,strong) UIView *tview;
@end

CGFloat w;
CGFloat h;

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
     w = self.view.frame.size.width;
     h = self.view.frame.size.height;
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, w , h-64)];
    bt.layer.position = CGPointMake(w/2, h);
    bt.layer.anchorPoint = CGPointMake(0.5, 1.0);
    bt.layer.transform = CATransform3DIdentity;
    [bt setTitle:@"push" forState:0];
    bt.backgroundColor = [UIColor redColor];
    [bt addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    
    UIView *tview = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, w , h-64)];
    tview.layer.position = CGPointMake(w/2,  64);
    tview.layer.anchorPoint = CGPointMake(0.5, 0);
    tview.backgroundColor = [UIColor grayColor];
    [self.view addSubview:tview];
    
    CATransform3D identity = CATransform3DIdentity;
    identity.m34 = -1.0/5000.0;
    CATransform3D aaa = CATransform3DRotate(identity, -M_PI_2, 1.0, 0.0, 0.0);
    CATransform3D bbb = CATransform3DTranslate(identity,0, 0, 0);
    CATransform3D ccc = CATransform3DTranslate(identity,0, (h-64), 0);
    
    CATransform3D dd =  CATransform3DConcat(aaa, bbb);
    CATransform3D ff=  CATransform3DConcat(dd, ccc);
    tview.layer.transform = ff;
    self.tview = tview;
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
    
    ViewController2 *vc2 = [ViewController2 new];
    [self.navigationController pushViewController:vc2 animated:YES];
    CATransform3D identity = CATransform3DIdentity;
    identity.m34 = -1.0/8000.0;
    
//    CATransform3D aaa = CATransform3DRo(identity, M_PI_2, 1.0, 0.0, 0.0);
//    CATransform3D aaa = CATransform3DMakeRotation(M_PI_2, 1.0, 0.0, 0.0);
//    CATransform3D bbb = CATransform3DMakeTranslation(0, 0, h/2);
//    CATransform3D ccc = CATransform3DMakeTranslation(0, h/2, 0);

    CATransform3D aaa = CATransform3DRotate(identity, M_PI_2, 1.0, 0.0, 0.0);
    CATransform3D bbb = CATransform3DTranslate(identity,0, 0, 0);
    CATransform3D ccc = CATransform3DTranslate(identity,0, -(h-64), 0);
    
    CATransform3D dd =  CATransform3DConcat(aaa, bbb);
    CATransform3D ff=  CATransform3DConcat(dd, ccc);


    
    [UIView animateWithDuration:3 animations:^{
//        sender.layer.anchorPoint = CGPointMake(0.5, 1.0);
//        sender.layer.transform = ff;
//        self.tview.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        
    }];


}

#pragma mark UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a DSLSecondViewController
    if (UINavigationControllerOperationPush == operation) {
        return [LCPushAnimateTransition new];
    }
    else if(UINavigationControllerOperationPop == operation) {
        return [LCPopAnimateTransition new];
    }else{
        return nil;
    }
}


@end
