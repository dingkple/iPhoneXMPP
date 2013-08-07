//
//  ECUSTRoundView.h
//  ThreeColor
//
//  Created by King Kz on 13-6-28.
//  Copyright (c) 2013年 King Kz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECUSTpurpleRoundView.h"



@interface ECUSTRoundView : UIView{
    UIBezierPath *bezierpath;

}

-(void) myInit;
-(void) swipe:(UISwipeGestureRecognizer *)gesture;

static inline void drawArc(CGContextRef ctx, CGPoint point, float angle_start, float angle_end, UIColor* color);
static inline float radians(double degrees);

@property (nonatomic, weak) UIBezierPath *bezierpath;

@end
