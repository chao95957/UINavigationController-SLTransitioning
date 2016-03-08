//
//  ImageViewController.m
//  Demo
//
//  Created by LingFeng-Li on 3/8/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import "ImageViewController.h"
#import "SLTransitioningDelegate.h"
#import "SLImageAnimatedTransitioning.h"

@interface ImageViewController () <SLTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)transitioningInfoAsFrom:(id<UIViewControllerAnimatedTransitioning>)transitioning context:(id<UIViewControllerContextTransitioning>)context {
    return @{SLImageAnimatedTransitioningInfoImageViewKey: self.imageView};
}

- (NSDictionary *)transitioningInfoAsTo:(id<UIViewControllerAnimatedTransitioning>)transitioning context:(id<UIViewControllerContextTransitioning>)context {
    CGSize imageSize = self.imageView.image.size;
    CGRect rect = CGRectMake((self.view.frame.size.width - imageSize.width) / 2.0, (self.view.frame.size.height - imageSize.height) / 2.0, imageSize.width, imageSize.height);
    return @{SLImageAnimatedTransitioningInfoImageViewKey: self.imageView,
             SLImageAnimatedTransitioningInfoEndFrameForImageViewKey: [NSValue valueWithCGRect:rect]};
    
}

@end
