//
//  SLSnapshot.h
//  Calico
//
//  Created by LingFeng-Li on 2/28/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLSnapshot : NSObject
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) UIView *snapshotView;
@end
