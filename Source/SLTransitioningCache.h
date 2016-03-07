//
//  SLTransitioningCache.h
//  Calico
//
//  Created by LingFeng-Li on 3/1/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SLNavigationTransitioningStyle.h"

@interface SLTransitioningCache : NSObject
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, assign) SLNavigationTransitioningStyle transitioningStyle;
@end
