//
//  UIViewController+SLTransitioning.h
//  Calico
//
//  Created by LingFeng-Li on 3/1/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLNavigationTransitioningStyle.h"

@interface UIViewController (SLTransitioning)
@property (nonatomic, assign) SLNavigationTransitioningStyle navigationTransitioningStyle;
@end
