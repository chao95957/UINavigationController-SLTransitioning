//
//  HASViewController.m
//  Demo
//
//  Created by LingFeng-Li on 3/8/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import "HASViewController.h"
#import "UIViewController+SLTransitioning.h"
#import "MJViewController.h"

@interface HASViewController ()

@end

@implementation HASViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.mixMode) {
        self.navigationTransitioningStyle = arc4random() % 8;
        while (self.navigationTransitioningStyle == SLNavigationTransitioningStyleImage || self.navigationTransitioningStyle == SLNavigationTransitioningStyleFlipOver) {
            self.navigationTransitioningStyle = arc4random() % 8;
        }
    } else {
        self.navigationTransitioningStyle = SLNavigationTransitioningStyleNone;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[MJViewController class]]) {
        ((MJViewController *)segue.destinationViewController).mixMode = self.mixMode;
    }
}

@end
