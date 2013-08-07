//
//  ECUSTmySegueOfPop.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-30.
//
//

#import "ECUSTmySegueOfPop.h"
#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ECUSTmyPopAndPush.h"


//@interface UINavigationController(popAdnPush){
//   
//    
//}
//- (UIViewController *)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition) transition;
//- (void)pushViewController: (UIViewController*)controller animatedWithTransition: (UIViewAnimationTransition)transition;
//- (void)pushAnimationDidStop ;
//
//@end

@implementation ECUSTmySegueOfPop
#define  TT_FLIP_TRANSITION_DURATION 0.7
//#import <QuartzCore/QuartzCore.h>


-(void)perform{
    /* sourcecode1 
     
     CATransition *transition = [CATransition animation];
     transition.duration = 0.3f;     
     transition.timingFunction = [CAMediaTimingFunctionfunctionWithName:kCAMediaTimingFunctionEaseInEaseOut];     
     transition.type = kCATransitionPush;     
     transition.subtype = kCATransitionFromLeft;     
     transition.delegate = self;     
     [self.view.superview.layer addAnimation:transition forKey:nil];   
     [self.view removeFromSuperview];
        
     *////////////////////////////////////
    
    UIViewController *current = self.sourceViewController;
    UIViewController *next =self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = next;
    current.navigationController.navigationBarHidden = NO;
//    [current.navigationController pushViewController:next animated:YES];
//    [current.navigationController popToViewController:next animated:YES];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:TT_FLIP_TRANSITION_DURATION];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
//    [UIView setAnimationTransition:transition forView:[self.destinationViewController view] cache:YES];
//    for (UIViewController *temp in current.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[SettingsViewController class]]) {
//            [current.navigationController popViewControllerAnimated:YES];
//        }
//    }
    [current.navigationController popViewControllerAnimated:YES];
//    [self.sourceViewController removeFromSuperview];
    
//    [UIView commitAnimations];
//    [self performs]
    [current.navigationController.view.layer addAnimation:transition forKey:nil];
//    [current.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];

}


@end
//
//@implementation UINavigationController
//
//- (void)pushViewController: (UIViewController*)controller
//    animatedWithTransition: (UIViewAnimationTransition)transition {
//    [[self navigationController] pushViewController:controller animated:NO];
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:TT_FLIP_TRANSITION_DURATION];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
//    [UIView setAnimationTransition:transition forView:[self view] cache:YES];
//    [UIView commitAnimations];
//}
//
//- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition {
//    UIViewController* poppedController = [self popViewControllerAnimated:NO];
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:TT_FLIP_TRANSITION_DURATION];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
//    [UIView setAnimationTransition:transition forView:[self view] cache:NO];
//    [UIView commitAnimations];
//    
//    return poppedController;
//}
//
//
//- (void)pushAnimationDidStop {
//}
//
//
//
//@end
