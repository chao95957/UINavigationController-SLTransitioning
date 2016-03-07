//
//  UINavigationController+SLTransitioning.m
//  Shuraba
//
//  Created by LingFeng-Li on 1/26/16.
//  Copyright © 2016 MeiTuan. All rights reserved.
//

#import <objc/runtime.h>
#import "UINavigationController+SLTransitioning.h"
#import "SLTransitioningCache.h"

typedef enum : NSUInteger {
    TransitioningSourceDefault,
    TransitioningSourceViewController,
    TransitioningSourceDelegate,
} TransitioningSource;

@interface TransitioningProxy : NSProxy <UINavigationControllerDelegate>
@property (nonatomic, weak) id<UINavigationControllerDelegate> delegate;
@property (nonatomic, assign) BOOL symmetrical;
@property (nonatomic, assign) TransitioningSource source;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) NSMutableArray *transitioningCaches;

@property (nonatomic, assign) SLNavigationTransitioningStyle transitioningStyle;
@property (nonatomic, weak) SLBaseAnimatedTransitioning *animatedTransitioning;
@property (nonatomic, strong) SLFadeAnimatedTransitioning *fadeAnimatedTransitioning;
@property (nonatomic, strong) SLDivideAnimatedTransitioning *divideAnimatedTransitioning;
@property (nonatomic, strong) SLResignTopAnimatedTransitioning *resignTopAnimatedTransitioning;
@property (nonatomic, strong) SLResignLeftAnimatedTransitioning *resignLeftAnimatedTransitioning;
@property (nonatomic, strong) SLFlipOverAnimatedTransitioning *flipOverAnimatedTransitioning;
@property (nonatomic, strong) SLImageAnimatedTransitioning *imageAnimatedTransitioning;
@property (nonatomic, strong) SLCoverVerticalAnimatedTransitioning *coverVerticalAnimatedTransitioning;
// EXTEND: New Animated Transitioning
@end

@implementation TransitioningProxy
- (instancetype)init
{
    _delegate = nil;
    _symmetrical = YES;
    _source = TransitioningSourceDefault;
    _viewController = nil;
    _transitioningCaches = [NSMutableArray array];
    _transitioningStyle = SLNavigationTransitioningStyleSystem;
    _animatedTransitioning = nil;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation setTarget:self.delegate];
    [invocation invoke];
    return;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [(id)self.delegate methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, @selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)) || sel_isEqual(aSelector, @selector(navigationController:interactionControllerForAnimationController:))) {
        return YES;
    }
    return [self.delegate respondsToSelector:aSelector];
}

#pragma mark - Property
- (void)setTransitioningStyle:(SLNavigationTransitioningStyle)transitioningStyle {
    _transitioningStyle = transitioningStyle;
    self.animatedTransitioning = [self p_animatedTransitioningForStyle:self.transitioningStyle];
}

- (SLFadeAnimatedTransitioning *)fadeAnimatedTransitioning {
    if (!_fadeAnimatedTransitioning) {
        _fadeAnimatedTransitioning = [[SLFadeAnimatedTransitioning alloc] init];
    }
    return _fadeAnimatedTransitioning;
}

- (SLDivideAnimatedTransitioning *)divideAnimatedTransitioning {
    if (!_divideAnimatedTransitioning) {
        _divideAnimatedTransitioning = [[SLDivideAnimatedTransitioning alloc] init];
    }
    return _divideAnimatedTransitioning;
}

- (SLResignTopAnimatedTransitioning *)resignTopAnimatedTransitioning {
    if (!_resignTopAnimatedTransitioning) {
        _resignTopAnimatedTransitioning = [[SLResignTopAnimatedTransitioning alloc] init];
    }
    return _resignTopAnimatedTransitioning;
}

- (SLResignLeftAnimatedTransitioning *)resignLeftAnimatedTransitioning {
    if (!_resignLeftAnimatedTransitioning) {
        _resignLeftAnimatedTransitioning = [[SLResignLeftAnimatedTransitioning alloc] init];
    }
    return _resignLeftAnimatedTransitioning;
}

- (SLFlipOverAnimatedTransitioning *)flipOverAnimatedTransitioning {
    if (!_flipOverAnimatedTransitioning) {
        _flipOverAnimatedTransitioning = [[SLFlipOverAnimatedTransitioning alloc] init];
    }
    return _flipOverAnimatedTransitioning;
}

- (SLImageAnimatedTransitioning *)imageAnimatedTransitioning {
    if (!_imageAnimatedTransitioning) {
        _imageAnimatedTransitioning = [[SLImageAnimatedTransitioning alloc] init];
    }
    return _imageAnimatedTransitioning;
}

- (SLCoverVerticalAnimatedTransitioning *)coverVerticalAnimatedTransitioning {
    if (!_coverVerticalAnimatedTransitioning) {
        _coverVerticalAnimatedTransitioning = [[SLCoverVerticalAnimatedTransitioning alloc] init];
        _coverVerticalAnimatedTransitioning.direction = SLCoverDirectionFromTop;
    }
    return _coverVerticalAnimatedTransitioning;
}

// EXTEND: New Animated Transitioning
#pragma mark - Private
- (SLBaseAnimatedTransitioning *)p_animatedTransitioningForStyle:(SLNavigationTransitioningStyle)style {
    SLBaseAnimatedTransitioning *animatedTransitioning = nil;
    switch (style) {
        case SLNavigationTransitioningStyleSystem:
            animatedTransitioning = nil;
            break;
        case SLNavigationTransitioningStyleFade:
            animatedTransitioning = self.fadeAnimatedTransitioning;
            break;
        case SLNavigationTransitioningStyleDivide:
            animatedTransitioning = self.divideAnimatedTransitioning;
            break;
        case SLNavigationTransitioningStyleResignTop:
            animatedTransitioning = self.resignTopAnimatedTransitioning;
            break;
        case SLNavigationTransitioningStyleResignLeft:
            animatedTransitioning = self.resignLeftAnimatedTransitioning;
            break;
        case SLNavigationTransitioningStyleFlipOver:
            animatedTransitioning = self.flipOverAnimatedTransitioning;
            break;
        case SLNavigationTransitioningStyleImage:
            animatedTransitioning = self.imageAnimatedTransitioning;
            break;
        case SLNavigationTransitioningStyleCoverVertical:
            animatedTransitioning = self.coverVerticalAnimatedTransitioning;
            break;
            
        // EXTEND: New Case
        default:
            break;
    }
    return animatedTransitioning;
}

#pragma mark <UINavigationControllerDelegate>
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    SLTransitioningCache *lastPushCache = nil;
    if (operation == UINavigationControllerOperationPop) {
        for (SLTransitioningCache *cache in self.transitioningCaches) {
            if (cache.viewController == toVC) {
                lastPushCache = cache;
                break;
            }
        }
        if (lastPushCache) {
            NSInteger index = [self.transitioningCaches indexOfObject:lastPushCache];
            [self.transitioningCaches removeObjectsInRange:NSMakeRange(index, self.transitioningCaches.count - index)];
        }
    }
    
    id<UIViewControllerAnimatedTransitioning> transitioning = nil;
    // Source: Delegate
    if ([self.delegate respondsToSelector:_cmd]) {
        transitioning = [self.delegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
        if (transitioning) {
            self.source = TransitioningSourceDelegate;
            return transitioning;
        }
    }
    
    // Source: View Controller
    if (self.symmetrical && operation == UINavigationControllerOperationPop) {
        if ([toVC conformsToProtocol:@protocol(UINavigationControllerDelegate)] && [toVC respondsToSelector:_cmd]) {
            transitioning = [(id<UINavigationControllerDelegate>)toVC navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
            if (transitioning) {
                self.source = TransitioningSourceViewController;
                self.viewController = toVC;
                return transitioning;
            }
        }
    } else {
        if ([fromVC conformsToProtocol:@protocol(UINavigationControllerDelegate)] && [fromVC respondsToSelector:_cmd]) {
            transitioning = [(id<UINavigationControllerDelegate>)fromVC navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
            if (transitioning) {
                self.source = TransitioningSourceViewController;
                self.viewController = fromVC;
                return transitioning;
            }
        }
    }
    
    // Source: Default
    self.source = TransitioningSourceDefault;
    switch (operation) {
        case UINavigationControllerOperationNone: {
            transitioning = nil;
            return transitioning;
        }
        case UINavigationControllerOperationPush: {
            SLTransitioningCache *cache = [[SLTransitioningCache alloc] init];
            cache.viewController = fromVC;
            
            SLNavigationTransitioningStyle style = fromVC.navigationTransitioningStyle;
            if (style != SLNavigationTransitioningStyleNone) {
                SLBaseAnimatedTransitioning *animatedTransitioning = [self p_animatedTransitioningForStyle:style];
                animatedTransitioning.operation = operation;
                transitioning = animatedTransitioning;
                cache.transitioningStyle = style;
            } else {
                self.animatedTransitioning.operation = operation;
                transitioning = self.animatedTransitioning;
                cache.transitioningStyle = self.transitioningStyle;
            }
            [self.transitioningCaches addObject:cache];
            return transitioning;
        }
        case UINavigationControllerOperationPop: {
            if (self.symmetrical) {
                if (lastPushCache) {
                    SLNavigationTransitioningStyle style = lastPushCache.transitioningStyle;
                    SLBaseAnimatedTransitioning *animatedTransitioning = [self p_animatedTransitioningForStyle:style];
                    animatedTransitioning.operation = operation;
                    transitioning = animatedTransitioning;
                } else {
                    SLNavigationTransitioningStyle style = toVC.navigationTransitioningStyle;
                    if (style != SLNavigationTransitioningStyleNone) {
                        SLBaseAnimatedTransitioning *animatedTransitioning = [self p_animatedTransitioningForStyle:style];
                        animatedTransitioning.operation = operation;
                        transitioning = animatedTransitioning;
                    } else {
                        self.animatedTransitioning.operation = operation;
                        transitioning = self.animatedTransitioning;
                    }
                }
            } else {
                SLNavigationTransitioningStyle style = fromVC.navigationTransitioningStyle;
                if (style != SLNavigationTransitioningStyleNone) {
                    SLBaseAnimatedTransitioning *animatedTransitioning = [self p_animatedTransitioningForStyle:style];
                    animatedTransitioning.operation = operation;
                    transitioning = animatedTransitioning;
                } else {
                    self.animatedTransitioning.operation = operation;
                    transitioning = self.animatedTransitioning;
                }
            }
            return transitioning;
        }
    }
    return transitioning;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    switch (self.source) {
        case TransitioningSourceDelegate:
            if ([self.delegate respondsToSelector:_cmd]) {
                return [self.delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
            } else {
                return nil;
            }
        case TransitioningSourceViewController:
            if ([self.viewController conformsToProtocol:@protocol(UINavigationControllerDelegate)] && [self.viewController respondsToSelector:_cmd]) {
                return [(id)self.viewController navigationController:navigationController interactionControllerForAnimationController:animationController];
            } else {
                return nil;
            }
        case TransitioningSourceDefault:
            return nil;
        default:
            break;
    }
    return nil;
}
@end

@interface UINavigationController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) TransitioningProxy *proxy;
@end

@implementation UINavigationController (SLTransitioning)
+ (void)load {
    // Method Swizzling
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        NSArray *originalSelectors = @[@"viewDidLoad", @"setDelegate:", @"delegate"];
        NSArray *swizzledSelectors = @[@"ms_viewDidLoad", @"ms_setDelegate:", @"ms_delegate"];
        
        for (int i = 0; i < originalSelectors.count; i++) {
            SEL originalSelector = NSSelectorFromString([originalSelectors objectAtIndex:i]);
            SEL swizzledSelector = NSSelectorFromString([swizzledSelectors objectAtIndex:i]);
            
            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            
            BOOL result = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
            if (result) {
                class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    });
}

#pragma mark - Method Swizzling
- (void)ms_viewDidLoad {
    [self ms_viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self.delegate;
}

- (void)ms_setDelegate:(id<UINavigationControllerDelegate>)delegate {
    self.proxy.delegate = delegate;
    [self ms_setDelegate:self.proxy];
}

- (id<UINavigationControllerDelegate>)ms_delegate {
    return self.proxy.delegate;
}

#pragma mark - Property
- (TransitioningProxy *)proxy {
    TransitioningProxy *proxy = objc_getAssociatedObject(self, @selector(proxy));
    if (!proxy) {
        proxy = [[TransitioningProxy alloc] init];
        self.proxy = proxy;
    }
    return proxy;
}

- (void)setProxy:(TransitioningProxy *)proxy {
    objc_setAssociatedObject(self, @selector(proxy), proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)symmetrical {
    return self.proxy.symmetrical;
}

- (void)setSymmetrical:(BOOL)symmetrical {
    self.proxy.symmetrical = symmetrical;
}

- (SLNavigationTransitioningStyle)transitioningStyle {
    return self.proxy.transitioningStyle;
}

- (void)setTransitioningStyle:(SLNavigationTransitioningStyle)transitioningStyle {
    if (transitioningStyle == SLNavigationTransitioningStyleNone) {
        transitioningStyle = SLNavigationTransitioningStyleSystem;
    }
    self.proxy.transitioningStyle = transitioningStyle;
}

- (SLCoverDirection)coverDirection {
    return self.proxy.coverVerticalAnimatedTransitioning.direction;
}

- (void)setCoverDirection:(SLCoverDirection)coverDirection {
    self.proxy.coverVerticalAnimatedTransitioning.direction = coverDirection;
}
@end
