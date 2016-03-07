//
//  SLBaseAnimatedTransitioning.h
//  Calico
//
//  Created by LingFeng-Li on 1/27/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SLTransitioningDelegate.h"

@interface SLBaseAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) UINavigationControllerOperation operation;
@end
