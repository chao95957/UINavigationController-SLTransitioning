//
//  SLDivideAnimatedTransitioning.h
//  Calico
//
//  Created by LingFeng-Li on 1/27/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLBaseAnimatedTransitioning.h"

/*
 Origin.y reference to UIWindow.
 
 Optional. Used in transitioningInfoAsFrom:context.
 */
static NSString *const SLDivideAnimatedTransitioningInfoPositionKey = @"SLDivideAnimatedTransitioningInfoPositionKey";

@interface SLDivideAnimatedTransitioning : SLBaseAnimatedTransitioning

@end
