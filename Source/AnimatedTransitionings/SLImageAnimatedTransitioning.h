//
//  SLImageAnimatedTransitioning.h
//  Calico
//
//  Created by LingFeng-Li on 3/3/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import "SLBaseAnimatedTransitioning.h"

/*
 Image view whose position is animated when transitioning.
 
 Required. Used in transitioningInfoAsFrom:context: and transitioningInfoAsTo:context:.
 */
static NSString *const SLImageAnimatedTransitioningInfoImageViewKey = @"SLImageAnimatedTransitioningInfoImageViewKey";

/*
 Its value is the rendered frame of image view  which belongs to the toViewController. 
 IMPORTANT: the frame is in the coordiate system of window. So you should always make it the actual value, even you manually calculate it.
 
 Required. Used in transitioningInfoAsTo:context:.
 */
static NSString *const SLImageAnimatedTransitioningInfoEndFrameForImageViewKey = @"SLImageAnimatedTransitioningInfoEndFrameForImageViewKey";

@interface SLImageAnimatedTransitioning : SLBaseAnimatedTransitioning

@end
