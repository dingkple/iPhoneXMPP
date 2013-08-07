//
//  ECUSTmySegueOfReplace.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-30.
//
//

#import "ECUSTmySegueOfPush.h"
#import <QuartzCore/QuartzCore.h>


@implementation ECUSTmySegueOfPush

-(void)perform{
//    UIViewController *dst = [self destinationViewController];
//    UIViewController *src = [self sourceViewController];
//    [dst viewWillAppear:NO];
//    [dst viewDidAppear:NO];
//    
////    [src retain];
//    
//    [src.view addSubview:dst.view];
//    
//    CGRect original = dst.view.frame;
//    
//    dst.view.frame = CGRectMake(dst.view.frame.origin.x, 0-dst.view.frame.size.height, dst.view.frame.size.width, dst.view.frame.size.height);
//    
//    [UIView beginAnimations:nil context:nil];
//    dst.view.frame = CGRectMake(original.origin.x, original.origin.y, original.size.height, original.size.width);
//    [UIView commitAnimations];
//    
//    [self performSelector:@selector(animationDone:) withObject:dst afterDelay:0.2f];
    UIViewController *current = self.sourceViewController;
    UIViewController *next =self.destinationViewController;
//    if(current isKindOfClass:[ecu])
    
    CATransition *transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = current;
    
    [current.view.layer addAnimation:transition forKey:nil];
    current.navigationController.navigationBarHidden = NO;
    [[current.view.superview layer] addAnimation:transition forKey:Nil];
//    [[current.navigationController.view layer] addAnimation:transition forKey:Nil];
    [current.navigationController pushViewController:next animated:YES];
//    [current.navigationController addChildViewController:next];
    
}



//- (void)animationDone:(id)vc{
//    UIViewController *dst = (UIViewController*)vc;
//    UINavigationController *nav = [[self sourceViewController] navigationController];
//    [nav popViewControllerAnimated:NO];
//    [nav pushViewController:dst animated:NO];
////    [[self sourceViewController] release];
//}

@end
