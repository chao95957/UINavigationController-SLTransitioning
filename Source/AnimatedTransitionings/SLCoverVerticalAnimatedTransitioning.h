//
//  SLCoverVerticalAnimatedTransitioning.h
//  Calico
//
//  Created by LingFeng-Li on 3/4/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import "SLBaseAnimatedTransitioning.h"

/* 
 Optional. Used in transitioningInfoAsTo:context:.
 */
static NSString *const SLCoverVerticalAnimatedTransitioningInfoBackgroundColorKey = @"SLCoverVerticalAnimatedTransitioningInfoBackgroundColorKey";

typedef enum : NSUInteger {
    SLCoverDirectionFromTop,
    SLCoverDirectionFromBottom
} SLCoverDirection;
@interface SLCoverVerticalAnimatedTransitioning : SLBaseAnimatedTransitioning
@property (nonatomic, assign) SLCoverDirection direction;
@end
