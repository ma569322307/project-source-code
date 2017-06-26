//
//  XTBigImgPresentAnimation.m
//  tian
//
//  Created by loong on 15/7/1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTBigImgPresentAnimation.h"

@implementation XTBigImgPresentAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 1. Get controllers from transition context
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 2. Set init frame for toVC
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    NSLog(@"finalFrame ===== %@",NSStringFromCGRect(finalFrame));
    //UIImageView *imageView = (UIImageView *)self.animationInfo[@"imageView"];
    
    NSLog(@"self.animationInfo[rect] ===== %@",NSStringFromCGRect([self.animationInfo[@"rect"] CGRectValue]));
    
    toVC.view.frame = [self.animationInfo[@"rect"] CGRectValue];
    //toVC.view.alpha = 0.0f;
    // 3. Add toVC's view to containerView
    UIView *containerView = [transitionContext containerView];
    NSLog(@"containerView.frame === %@",NSStringFromCGRect(containerView.frame));

    [containerView addSubview:toVC.view];
    
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.8f
          initialSpringVelocity:0.2f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toVC.view.frame = finalFrame;
                         //toVC.view.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         // 5. Tell context that we completed.
                         [transitionContext completeTransition:YES];
                     }];
}



@end
