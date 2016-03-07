//
//  UIViewController+SLTransitioning.m
//  Calico
//
//  Created by LingFeng-Li on 3/1/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import "UIViewController+SLTransitioning.h"
#import <objc/runtime.h>

@implementation UIViewController (SLTransitioning)

- (SLNavigationTransitioningStyle)navigationTransitioningStyle {
    NSNumber *style = objc_getAssociatedObject(self, @selector(navigationTransitioningStyle));
    if (!style) {
        style = @(SLNavigationTransitioningStyleNone);
        self.navigationTransitioningStyle = [style unsignedIntegerValue];
    }
    return [style unsignedIntegerValue];
}

- (void)setNavigationTransitioningStyle:(SLNavigationTransitioningStyle)navigationTransitioningStyle {
    objc_setAssociatedObject(self, @selector(navigationTransitioningStyle), @(navigationTransitioningStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
