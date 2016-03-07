//
//  SLImageAnimatedTransitioning.h
//  Calico
//
//  Created by LingFeng-Li on 3/3/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import "SLBaseAnimatedTransitioning.h"

static NSString *const SLImageAnimatedTransitioningInfoImageViewKey = @"SLImageAnimatedTransitioningInfoImageViewKey"; // image view whose position is animated when transitioning
/*
 Its value is the rendered frame of image view  which belongs to tthe oViewController. The value is sometimes different from imageView.frame because at that time the view of the toViewController hasn't been laid out or the cause of the navigation bar, especially when push. So you should always make it the actual value, even you manually calculate it.
 */
static NSString *const SLImageAnimatedTransitioningInfoEndFrameForImageViewKey = @"SLImageAnimatedTransitioningInfoEndFrameForImageViewKey";

@interface SLImageAnimatedTransitioning : SLBaseAnimatedTransitioning

@end
