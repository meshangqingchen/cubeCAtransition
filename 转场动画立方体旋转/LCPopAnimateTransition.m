//
//  LCPopAnimateTransition.m
//  AnimationTransition_OC
//
//  Created by 3D on 2017/4/17.
//  Copyright © 2017年 TOMO. All rights reserved.
//

#import "LCPopAnimateTransition.h"

@implementation LCPopAnimateTransition
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.75;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSLog(@"%@",fromVC);
    NSLog(@"%@",toVC);
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    CATransform3D identity = CATransform3DIdentity;
    UIView *fromView = [fromVC.view snapshotViewAfterScreenUpdates:NO];//这里用快照 原因是我们还有手势 根据手势[recognizer translationInView:self.view].y 控制pop动画的进度 如果直接用fromVC.view 那么这个view有事旋转 又是平移的 手势.y 根本没法控制进程... 巨坑..
    fromView.alpha = 1.0;
    [containerView addSubview:fromView];
    fromVC.view.hidden = YES;

    fromView.layer.transform = identity; //现复原在转换坐标 巨坑
    fromView.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
    fromView.layer.position = CGPointMake(fromView.frame.size.width/2, fromView.frame.origin.y);
    fromView.layer.anchorPoint = CGPointMake(0.5, 0);
    fromView.layer.transform = CATransform3DIdentity;
    
    UIView *toView = toVC.view;
    toView.alpha = 0.0;
    toView.layer.transform = identity; //现复原在转换坐标
    toView.frame = [containerView convertRect:toView.frame fromView:toView.superview];
    toView.layer.position = CGPointMake(toView.frame.size.width/2, toView.frame.origin.y+toView.frame.size.height);
    toView.layer.anchorPoint = CGPointMake(0.5, 1.0);
    identity.m34 = -1.0/5000;
    CATransform3D to3DRotateX = CATransform3DRotate(identity, M_PI_2, 1.0, 0.0, 0.0);
    CATransform3D to3DTranslateY = CATransform3DTranslate(identity,0, -toView.frame.size.height, 0);
    CATransform3D toAllTrans=  CATransform3DConcat(to3DRotateX, to3DTranslateY);
    toView.layer.transform = toAllTrans;
    
    
    [containerView addSubview:toView];
//    [containerView addSubview:fromView];
    [UIView animateWithDuration:duration animations:^{
        CATransform3D identity = CATransform3DIdentity;
        identity.m34 = -1.0/5000;
        CATransform3D from3DRotateX = CATransform3DRotate(identity, -M_PI_2, 1.0, 0.0, 0.0);
        CATransform3D from3DTranslateY = CATransform3DTranslate(identity,0, fromView.frame.size.height, 0);
        
        CATransform3D fromAllTrans=  CATransform3DConcat(from3DRotateX, from3DTranslateY);
        fromView.layer.transform = fromAllTrans;
        fromView.alpha = 0.0;
        toView.layer.transform = identity;
        toView.alpha = 1.0;
    } completion:^(BOOL finished) {
        fromVC.view.hidden = NO;
        [fromView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

@end
