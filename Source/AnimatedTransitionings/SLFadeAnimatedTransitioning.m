//
//  SLFadeAnimatedTransitioning.m
//  Calico
//
//  Created by LingFeng-Li on 1/26/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import "SLFadeAnimatedTransitioning.h"

@implementation SLFadeAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.30;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    [toView layoutIfNeeded];
    
    if (self.operation == UINavigationControllerOperationPush) {
        [containerView addSubview:toView];
        toView.alpha = 0.0;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    } else if (self.operation == UINavigationControllerOperationPop) {
        [containerView insertSubview:toView belowSubview:fromView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    } else {
        [super animateTransition:transitionContext];
    }
}

@end
