//
//  TableViewController.m
//  Demo
//
//  Created by LingFeng-Li on 3/8/16.
//  Copyright © 2016 Soul-Beats. All rights reserved.
//

#import "TableViewController.h"
#import "UINavigationController+SLTransitioning.h"
#import "HASViewController.h"

@interface TableViewController () <SLTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) UITableViewCell *cell;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {}

#pragma mark <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *defaultSegueIdentifier = @"Default Segue";
    NSString *imageSegueIdentifier = @"Image Segue";
    NSString *mixSegueIdentifier = @"Mix Segue";
    if (indexPath.section == 0) {
        self.navigationTransitioningStyle = SLNavigationTransitioningStyleNone;
        switch (indexPath.row) {
            case 0:
                self.navigationController.transitioningStyle = SLNavigationTransitioningStyleSystem;
                [self performSegueWithIdentifier:defaultSegueIdentifier sender:nil];
                break;
            case 1:
                self.navigationController.transitioningStyle = SLNavigationTransitioningStyleFade;
                [self performSegueWithIdentifier:defaultSegueIdentifier sender:nil];
                break;
            case 2:
                self.navigationController.transitioningStyle = SLNavigationTransitioningStyleDivide;
                [self performSegueWithIdentifier:defaultSegueIdentifier sender:nil];
                break;
            case 3:
                self.navigationController.transitioningStyle = SLNavigationTransitioningStyleResignTop;
                [self performSegueWithIdentifier:defaultSegueIdentifier sender:nil];
                break;
            case 4:
                self.navigationController.transitioningStyle = SLNavigationTransitioningStyleResignLeft;
                [self performSegueWithIdentifier:defaultSegueIdentifier sender:nil];
                break;
            case 5:
                self.navigationController.transitioningStyle = SLNavigationTransitioningStyleFlipOver;
                [self performSegueWithIdentifier:defaultSegueIdentifier sender:nil];
                break;
            case 6:
                self.navigationController.transitioningStyle = SLNavigationTransitioningStyleImage;
                [self performSegueWithIdentifier:imageSegueIdentifier sender:nil];
                break;
            case 7:
                self.navigationController.transitioningStyle = SLNavigationTransitioningStyleCoverVertical;
                self.navigationController.coverDirection = SLCoverDirectionFromTop;
                [self performSegueWithIdentifier:defaultSegueIdentifier sender:nil];
                break;
            case 8:
                self.navigationController.transitioningStyle = SLNavigationTransitioningStyleCoverVertical;
                self.navigationController.coverDirection = SLCoverDirectionFromBottom;
                [self performSegueWithIdentifier:defaultSegueIdentifier sender:nil];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            self.navigationController.transitioningStyle = SLNavigationTransitioningStyleFlipOver;
            self.navigationTransitioningStyle = arc4random() % 8;
            while (self.navigationTransitioningStyle == SLNavigationTransitioningStyleImage || self.navigationTransitioningStyle == SLNavigationTransitioningStyleFlipOver) {
                self.navigationTransitioningStyle = arc4random() % 8;
            }
            [self performSegueWithIdentifier:mixSegueIdentifier sender:nil];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Mix Segue"] && [segue.destinationViewController isKindOfClass:[HASViewController class]]) {
        ((HASViewController *)segue.destinationViewController).mixMode = YES;
    }
}

- (NSDictionary *)transitioningInfoAsFrom:(id<UIViewControllerAnimatedTransitioning>)transitioning context:(id<UIViewControllerContextTransitioning>)context {
    if ([transitioning isKindOfClass:[SLDivideAnimatedTransitioning class]]) {
        CGRect rect = [self.view.window convertRect:self.cell.frame fromView:self.cell.superview];
        return @{SLDivideAnimatedTransitioningInfoPositionKey: @(rect.origin.y + rect.size.height / 2.0)};
    }
    if ([transitioning isKindOfClass:[SLImageAnimatedTransitioning class]]) {
        return @{SLImageAnimatedTransitioningInfoImageViewKey: self.imageView};
    }
    return nil;
}

- (NSDictionary *)transitioningInfoAsTo:(id<UIViewControllerAnimatedTransitioning>)transitioning context:(id<UIViewControllerContextTransitioning>)context {
    if ([transitioning isKindOfClass:[SLCoverVerticalAnimatedTransitioning class]]) {
        return @{SLCoverVerticalAnimatedTransitioningInfoBackgroundColorKey: [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]};
    }
    if ([transitioning isKindOfClass:[SLImageAnimatedTransitioning class]]) {
        CGRect rect = [self.view convertRect:self.imageView.frame fromCoordinateSpace:self.imageView.superview];
        rect.origin.y += 64;
        return @{SLImageAnimatedTransitioningInfoImageViewKey: self.imageView,
                 SLImageAnimatedTransitioningInfoEndFrameForImageViewKey: [NSValue valueWithCGRect:rect]};
    }
    return nil;
}
@end
