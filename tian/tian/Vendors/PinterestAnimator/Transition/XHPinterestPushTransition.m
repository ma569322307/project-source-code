//
//  XHPinterestPushTransition.m
//  PinterestExample
//
//  Created by dw_iOS on 14-8-14.
//  Copyright (c) 2014年 广州华多网络科技有限公司 多玩事业部 iOS软件工程师 曾宪华. All rights reserved.
//

#import "XHPinterestPushTransition.h"

@implementation XHPinterestPushTransition

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController <XHTransitionProtocol> *fromViewController = (UIViewController <XHTransitionProtocol> * )([transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]);
    
    UIViewController <XHTransitionProtocol> *toViewController = (UIViewController <XHTransitionProtocol> * )([transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]);
    
    UIView *containerView = [transitionContext containerView];

    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;

    UICollectionView *waterFallView = [fromViewController transitionCollectionView];
    
    UICollectionView *pageView = [toViewController transitionCollectionView];
    
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    toView.hidden = YES;
    UIView *blankView = [[UIView alloc] initWithFrame:toView.frame]
    ;
    blankView.backgroundColor = [UIColor whiteColor];
    [containerView insertSubview:blankView belowSubview:fromView];
    
    NSIndexPath *indexPath = [waterFallView currentIndexPath];
    
    UIView <XHTansitionWaterfallGridViewProtocol> *gridView = (UIView <XHTansitionWaterfallGridViewProtocol> *)([waterFallView cellForItemAtIndexPath:indexPath]);
    
    CGPoint leftUpperPoint = [gridView convertPoint:CGPointZero toView:nil];
    
    pageView.hidden = YES;
    
    [pageView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    
    CGFloat offsetY  = fromViewController.navigationController.navigationBarHidden ? 0.0 : 64;
    
    
    CGFloat offsetStatuBar = fromViewController.navigationController.navigationBarHidden ? 0.0 : 64;
    
    UIView *snapShot = [gridView snapShotForTransition];
    [containerView addSubview:snapShot];
    [snapShot setOrigin:leftUpperPoint];
    
    CGFloat animationScale = [self animationScale]+0.01;
    [UIView animateWithDuration:[self animationDuration] animations:^{
        
        snapShot.transform = CGAffineTransformMakeScale(animationScale,
                                                        animationScale);
        
        [snapShot setOrigin:CGPointMake(kXHLargeGridItemPadding-0.5, offsetY + kXHLargeGridItemPadding-3)];
        
        fromView.alpha = 0;
        fromView.transform = snapShot.transform;
        fromView.frame = CGRectMake(-(leftUpperPoint.x)*animationScale+kXHLargeGridItemPadding,
                                    -(leftUpperPoint.y-offsetStatuBar)*animationScale+offsetStatuBar+kXHLargeGridItemPadding,
                                    fromView.frame.size.width,
                                    fromView.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (finished) {
            [snapShot removeFromSuperview];
            [blankView removeFromSuperview];
            pageView.hidden = NO;
            toView.hidden = NO;
            fromView.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:!self.canceled];
        }
    }];
}


@end
