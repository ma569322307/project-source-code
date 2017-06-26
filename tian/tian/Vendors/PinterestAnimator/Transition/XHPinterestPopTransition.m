//
//  XHPinterestPopTransition.m
//  PinterestExample
//
//  Created by dw_iOS on 14-8-14.
//  Copyright (c) 2014年 广州华多网络科技有限公司 多玩事业部 iOS软件工程师 曾宪华. All rights reserved.
//

#import "XHPinterestPopTransition.h"

@implementation XHPinterestPopTransition

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController <XHTransitionProtocol> *fromViewController = (UIViewController <XHTransitionProtocol> * )([transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]);
    
    UIViewController <XHTransitionProtocol> *toViewController = (UIViewController <XHTransitionProtocol> * )([transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]);
//    toViewController.navigationController.navigationBar.translucent = NO;
//    toViewController.extendedLayoutIncludesOpaqueBars = NO;
//    toViewController.edgesForExtendedLayout = UIRectEdgeNone;
//    
//    fromViewController.navigationController.navigationBar.translucent = NO;
//    fromViewController.extendedLayoutIncludesOpaqueBars = NO;
//    fromViewController.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIView *containerView = [transitionContext containerView];
    
    UIView *toView = toViewController.view;

    [containerView addSubview:toView];
//    CGRect frame = toView.frame;
//    frame.origin.y -= 64;
//    toView.frame = frame;
    
//    CGRect containerFrame = containerView.frame;
//    containerFrame.origin.y += 64;
//    containerView.frame = containerFrame;
    
    
    toView.hidden = YES;
    
    UICollectionView *waterFallView = [toViewController transitionCollectionView];
    
    UICollectionView *pageView = [fromViewController transitionCollectionView];
    
    
    [waterFallView layoutIfNeeded];
    
    NSIndexPath *indexPath = pageView.currentIndexPath;
    
    UIView <XHTansitionWaterfallGridViewProtocol> *gridView = (UIView <XHTansitionWaterfallGridViewProtocol> *)([waterFallView cellForItemAtIndexPath:indexPath]);
    
    [waterFallView performBatchUpdates:^{
        
    } completion:NULL];
    
    
    CGPoint leftUpperPoint = [gridView convertPoint:CGPointZero toView:nil];
    
    UIView *snapShot = [gridView snapShotForTransition];
    
    
    CGFloat animationScale = [self animationScale]+0.01;
    
    snapShot.transform = CGAffineTransformMakeScale(animationScale, animationScale);
    
    CGFloat pullOffsetY = [(UIViewController <XHHorizontalPageViewControllerProtocol> *)fromViewController pageViewCellScrollViewContentOffset].y;
    
    CGFloat offsetY = fromViewController.navigationController.navigationBarHidden ? 0.0 : 64;
    [snapShot setOrigin:CGPointMake(kXHLargeGridItemPadding-0.5, -pullOffsetY+offsetY + kXHLargeGridItemPadding-3)];
    
//    CGRect snapShotFrame = snapShot.frame;
//    snapShotFrame.origin.y -= 64;
//    snapShot.frame = snapShotFrame;
    
    [containerView addSubview:snapShot];
    
    
    toView.hidden = NO;
    
    toView.alpha = 0.0;
    toView.transform = snapShot.transform;
    
    toView.frame = CGRectMake(-(leftUpperPoint.x * animationScale)+kXHLargeGridItemPadding, (-((leftUpperPoint.y-offsetY) * animationScale + pullOffsetY+offsetY))+128+kXHLargeGridItemPadding,
                              toView.frame.size.width, toView.frame.size.height);
    
    
    UIView *whiteViewContainer = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    whiteViewContainer.backgroundColor = [UIColor whiteColor];
    
    [containerView addSubview:whiteViewContainer];
    [containerView insertSubview:whiteViewContainer belowSubview:toView];
    
    [UIView animateWithDuration:[self animationDuration] animations:^{
        snapShot.transform = CGAffineTransformIdentity;
        [snapShot setOrigin:CGPointMake(leftUpperPoint.x, leftUpperPoint.y)];
        
        toView.transform = CGAffineTransformIdentity;
        [toView setOrigin:CGPointMake(0., 64)];
        toView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [snapShot removeFromSuperview];
            [whiteViewContainer removeFromSuperview];
            [transitionContext completeTransition:!self.canceled];
        }
        
    }];
}

@end
