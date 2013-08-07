//
//  ECUSTmyPopAndPush.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-30.
//
//

#import <Foundation/Foundation.h>

@interface UINavigationController(ECUSTmyPopAndPush)
- (UIViewController *)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition) transition;
- (void)pushViewController: (UIViewController*)controller animatedWithTransition: (UIViewAnimationTransition)transition;
- (void)pushAnimationDidStop ;

@end
