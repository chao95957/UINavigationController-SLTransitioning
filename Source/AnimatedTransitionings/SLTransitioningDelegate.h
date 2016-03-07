//
//  SLTransitioningDelegate.h
//  Shuraba
//
//  Created by LingFeng-Li on 1/25/16.
//  Copyright © 2016 MeiTuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SLTransitioningDelegate <NSObject>
@optional
- (NSDictionary *)transitioningInfoAsFrom:(id <UIViewControllerAnimatedTransitioning>)transitioning context:(id <UIViewControllerContextTransitioning>)context;
- (NSDictionary *)transitioningInfoAsTo:(id <UIViewControllerAnimatedTransitioning>)transitioning context:(id <UIViewControllerContextTransitioning>)context;
@end
