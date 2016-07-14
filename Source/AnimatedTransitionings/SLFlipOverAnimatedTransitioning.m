//
//  SLFlipOverAnimatedTransitioning.m
//  Calico
//
//  Created by LingFeng-Li on 3/2/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import "SLFlipOverAnimatedTransitioning.h"
#import "SLSnapshot.h"

@interface SLFlipOverAnimatedTransitioning ()
@property (nonatomic, strong) NSMutableArray *snapshots;
@end

@implementation SLFlipOverAnimatedTransitioning
- (NSMutableArray *)snapshots {
    if (!_snapshots) {
        _snapshots = [NSMutableArray array];
    }
    return _snapshots;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    [toView layoutIfNeeded];
    
    UIWindow *keyWindow = fromView.window;
    UIView *baseView = [[keyWindow subviews] firstObject];
    NSInteger tag = 1203;
    
    CGFloat m34 = -1.0/5000.0;
    CATransform3D startTransform = CATransform3DIdentity;
    startTransform.m34 = m34;
    startTransform = CATransform3DRotate(startTransform, M_PI / 2.0, 0, 1, 0);
    CATransform3D endTransform = CATransform3DIdentity;
    endTransform.m34 = m34;
    
    if (self.operation == UINavigationControllerOperationPush) {
        UIView *snapshotView = [baseView snapshotViewAfterScreenUpdates:NO];
        snapshotView.frame = baseView.frame;
        UIView *maskView = [[UIView alloc] initWithFrame:snapshotView.bounds];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.0;
        maskView.tag = tag;
        [snapshotView addSubview:maskView];
        
        [containerView addSubview:toView];
        [keyWindow addSubview:snapshotView];
        [keyWindow bringSubviewToFront:baseView];
        
        CGPoint anchorPoint = baseView.layer.anchorPoint;
        CGPoint position = baseView.layer.position;
        baseView.layer.anchorPoint = CGPointMake(1, 0.5);
        baseView.layer.position = CGPointMake(position.x + baseView.layer.bounds.size.width / 2.0, position.y);
        baseView.layer.transform = startTransform;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            baseView.layer.transform = endTransform;
            maskView.alpha = 0.35;
        } completion:^(BOOL finished) {
            [snapshotView removeFromSuperview];
            baseView.layer.transform = CATransform3DIdentity;
            baseView.layer.anchorPoint = anchorPoint;
            baseView.layer.position = position;
            
            SLSnapshot *snapshot = nil;
            for (SLSnapshot *sp in self.snapshots) {
                if (sp.viewController == fromVC) {
                    snapshot = sp;
                    break;
                }
            }
            if (snapshot) {
                snapshot.snapshotView = snapshotView;
            } else {
                snapshot = [[SLSnapshot alloc] init];
                snapshot.snapshotView = snapshotView;
                snapshot.viewController = fromVC;
                [self.snapshots addObject:snapshot];
            }
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    } else if (self.operation == UINavigationControllerOperationPop) {
        SLSnapshot *result = nil;
        for (int i = (int)self.snapshots.count - 1; i >= 0; i--) {
            SLSnapshot *snapshot = [self.snapshots objectAtIndex:i];
            if (snapshot.viewController == toVC) {
                result = snapshot;
                break;
            }
        }
        
        if (result) {
            NSUInteger index = [self.snapshots indexOfObject:result];
            [self.snapshots removeObjectsInRange:NSMakeRange(index, self.snapshots.count - index)];
            if (result.snapshotView.frame.size.width == baseView.frame.size.height || result.snapshotView.frame.size.height == baseView.frame.size.width) {
                result = nil;
            }
        }
        
        if (result) {
            UIView *snapshotView = result.snapshotView;
            UIView *maskView = [snapshotView viewWithTag:tag];
            
            [keyWindow addSubview:snapshotView];
            [keyWindow bringSubviewToFront:baseView];
            
            CGPoint anchorPoint = baseView.layer.anchorPoint;
            CGPoint position = baseView.layer.position;
            baseView.layer.anchorPoint = CGPointMake(1, 0.5);
            baseView.layer.position = CGPointMake(position.x + baseView.layer.bounds.size.width / 2.0, position.y);
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                maskView.alpha = 0.0;
                baseView.layer.transform = startTransform;
            } completion:^(BOOL finished) {
                baseView.layer.transform = CATransform3DIdentity;
                baseView.layer.anchorPoint = anchorPoint;
                baseView.layer.position = position;
                [containerView addSubview:toView];
                [snapshotView removeFromSuperview];
                
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        } else {
            [super animateTransition:transitionContext];
        }
    } else {
        [super animateTransition:transitionContext];
    }
}
@end
