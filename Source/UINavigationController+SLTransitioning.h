//
//  UINavigationController+SLTransitioning.h
//  Shuraba
//
//  Created by LingFeng-Li on 1/26/16.
//  Copyright © 2016 MeiTuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+SLTransitioning.h"
#import "SLFadeAnimatedTransitioning.h"
#import "SLDivideAnimatedTransitioning.h"
#import "SLResignTopAnimatedTransitioning.h"
#import "SLResignLeftAnimatedTransitioning.h"
#import "SLFlipOverAnimatedTransitioning.h"
#import "SLImageAnimatedTransitioning.h"
#import "SLCoverVerticalAnimatedTransitioning.h"

@interface UINavigationController (SLTransitioning)
@property (nonatomic, assign) SLNavigationTransitioningStyle transitioningStyle;
@property (nonatomic, assign) BOOL symmetrical;
@property (nonatomic, assign) SLCoverDirection coverDirection;
@end
