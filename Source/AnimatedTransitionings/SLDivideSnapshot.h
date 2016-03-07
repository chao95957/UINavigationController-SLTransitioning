//
//  SLDivideSnapshot.h
//  Calico
//
//  Created by 李凌峰 on 2/5/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLDivideSnapshot : NSObject
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) UIView *snapshotTop;
@property (nonatomic, strong) UIView *snapshotBottom;
@end
