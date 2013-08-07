//
//  ECUSTpurpleRoundView.m
//  ThreeColor
//
//  Created by King Kz on 13-6-28.
//  Copyright (c) 2013年 King Kz. All rights reserved.
//

#import "ECUSTpurpleRoundView.h"

@implementation ECUSTpurpleRoundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define PI 3.14159265358979323846
#define  radius 50


static inline void drawArc(CGContextRef ctx, CGPoint point, float angle_start, float angle_end, UIColor* color) {
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextSetFillColor(ctx, CGColorGetComponents( [color CGColor]));
    CGContextAddArc(ctx, point.x, point.y, radius,  angle_start, angle_end, 0);
    //CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    CGContextSetAlpha(ctx, 0.5);
}

static inline float radians(double degrees) {
    return degrees * PI / 180;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
     CGContextRef context = UIGraphicsGetCurrentContext();
     //    CGContextClearRect(context, )
    CGPoint purple;
    purple.x = 0;
    purple.y = 0;
     CGFloat startAngle = radians(0);
     CGFloat endAngle = radians(360);
     drawArc(context,purple, startAngle, endAngle, [UIColor purpleColor]);
}

@end
