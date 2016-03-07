//
//  SLNavigationTransitioningStyle.h
//  Calico
//
//  Created by LingFeng-Li on 3/1/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#ifndef SLNavigationTransitioningStyle_h
#define SLNavigationTransitioningStyle_h

// EXTEND: New Navigation Transitioning Style
typedef enum : NSUInteger {
    SLNavigationTransitioningStyleSystem = 0,
    SLNavigationTransitioningStyleFade,
    SLNavigationTransitioningStyleDivide,
    SLNavigationTransitioningStyleResignTop,
    SLNavigationTransitioningStyleResignLeft,
    SLNavigationTransitioningStyleFlipOver,
    SLNavigationTransitioningStyleImage,
    SLNavigationTransitioningStyleCoverVertical,
    SLNavigationTransitioningStyleNone = NSUIntegerMax // Only Used by UIViewcontroller
} SLNavigationTransitioningStyle;

#endif /* SLNavigationTransitioningStyle_h */
