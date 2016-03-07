//
//  SLCoverVerticalAnimatedTransitioning.m
//  Calico
//
//  Created by LingFeng-Li on 3/4/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import "SLCoverVerticalAnimatedTransitioning.h"
#import "SLSnapshot.h"

@interface SLCoverVerticalAnimatedTransitioning ()
@property (nonatomic, strong) NSMutableArray *snapshots;
@end

@implementation SLCoverVerticalAnimatedTransitioning
- (NSMutableArray *)snapshots {
    if (!_snapshots) {
        _snapshots = [NSMutableArray array];
    }
    return _snapshots;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    [toView layoutIfNeeded];
    
    UIWindow *keyWindow = fromView.window;
    UIView *baseView = [[keyWindow subviews] firstObject];
    
    UIColor *originalColor = keyWindow.backgroundColor;
    UIColor *newColor = originalColor;
    if ([toVC conformsToProtocol:@protocol(SLTransitioningDelegate)] && [(id<SLTransitioningDelegate>)toVC respondsToSelector:@selector(transitioningInfoAsTo:context:)]) {
        newColor = [[(id<SLTransitioningDelegate>)toVC transitioningInfoAsTo:self context:transitionContext] valueForKey:SLCoverVerticalAnimatedTransitioningInfoBackgroundColorKey];
    }
    
    CGFloat ratio = 0.50;
    CGFloat offset = 4;
    if (self.operation == UINavigationControllerOperationPush) {
        keyWindow.backgroundColor = newColor;
        
        UIView *snapshotView = [baseView snapshotViewAfterScreenUpdates:NO];
        snapshotView.frame = baseView.frame;
        [keyWindow addSubview:snapshotView];
        [containerView addSubview:toView];
        
        CGRect originalFrame = baseView.frame;
        CGRect newFrame = baseView.frame;
        if (self.direction == SLCoverDirectionFromTop) {
            newFrame.origin.y -= newFrame.size.height;
        } else if (self.direction == SLCoverDirectionFromBottom) {
            newFrame.origin.y += newFrame.size.height;
        }
        baseView.frame = newFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] * ratio delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = snapshotView.frame;
            if (self.direction == SLCoverDirectionFromTop) {
                frame.origin.y += frame.size.height;
            } else if (self.direction == SLCoverDirectionFromBottom) {
                frame.origin.y -= frame.size.height;
            }
            snapshotView.frame = frame;
            
            frame = originalFrame;
            if (self.direction == SLCoverDirectionFromTop) {
                frame.origin.y += offset;
            } else if (self.direction == SLCoverDirectionFromBottom) {
                frame.origin.y -= offset;
            }
            baseView.frame = frame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] * (1 - ratio) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                baseView.frame = originalFrame;
            } completion:^(BOOL finished) {
                keyWindow.backgroundColor = originalColor;
                [snapshotView removeFromSuperview];
                
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
            keyWindow.backgroundColor = newColor;
            
            UIView *snapshotView = result.snapshotView;
            [keyWindow addSubview:snapshotView];
            
            CGRect originalFrame = baseView.frame;
            CGRect newFrame = originalFrame;
            if (self.direction == SLCoverDirectionFromTop) {
                newFrame.origin.y += newFrame.size.height;
            } else if (self.direction == SLCoverDirectionFromBottom) {
                newFrame.origin.y -= newFrame.size.height;
            }
            snapshotView.frame = newFrame;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] * ratio delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGRect frame = baseView.frame;
                if (self.direction == SLCoverDirectionFromTop) {
                    frame.origin.y -= newFrame.size.height;
                } else if (self.direction == SLCoverDirectionFromBottom) {
                    frame.origin.y += newFrame.size.height;
                }
                baseView.frame = frame;
                
                frame = originalFrame;
                if (self.direction == SLCoverDirectionFromTop) {
                    frame.origin.y -= offset;
                } else if (self.direction == SLCoverDirectionFromBottom) {
                    frame.origin.y += offset;
                }
                snapshotView.frame = frame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:[self transitionDuration:transitionContext] * (1 - ratio) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    snapshotView.frame = originalFrame;
                } completion:^(BOOL finished) {
                    keyWindow.backgroundColor = originalColor;
                    
                    baseView.frame = originalFrame;
                    [containerView addSubview:toView];
                    [snapshotView removeFromSuperview];
                    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                }];
            }];
        } else {
            [super animateTransition:transitionContext];
        }
    } else {
        [super animateTransition:transitionContext];
    }
}

@end
