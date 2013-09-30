//
//  ECUSTRoundView.m
//  ThreeColor
//
//  Created by King Kz on 13-6-28.
//  Copyright (c) 2013年 King Kz. All rights reserved.
//

#import "ECUSTRoundView.h"

@interface ECUSTRoundView ()


{
    CGFloat percent;
    CGPoint redPoint;
    CGPoint bluePoint;
    CGPoint greenPoint;
    CGPoint startPoint;
    CGPoint *currentRound;
    float radius;
    float lastScale;
}

//@property (nonatomic, weak) UIBezierPath bezierPath;

@end



@implementation ECUSTRoundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    pinchZoom = NO;
    previousDistance = 0.0f;
    zoomFactor = 1.0f;
    radius = 50;
    
    UIPinchGestureRecognizer *recognizer;
    recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    // 不同的 Recognizer 有不同的实体变数
    // 例如 SwipeGesture 可以指定方向
    // 而 TapGesture 則可以指定次數recognizer.direction = UISwipeGestureRecognizerDirectionUp
    [recognizer setDelegate:self];
    [self addGestureRecognizer:recognizer];
//    [recognizer release];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#define PI 3.14159265358979323846  
//#define  radius 50


static inline void drawArc(CGContextRef ctx, CGPoint point, float angle_start, float angle_end, UIColor* color, float radius) {
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


- (void)handlePinch{
    
}


-(CGPoint *) findCentre: (CGPoint) fingerPoint{
    float redDistance = (fingerPoint.x - redPoint.x)*(fingerPoint.x - redPoint.x)+(fingerPoint.y - redPoint.y)*(fingerPoint.y - redPoint.y);
    float blueDistance = (fingerPoint.x - bluePoint.x)*(fingerPoint.x - bluePoint.x)+(fingerPoint.y - bluePoint.y)*(fingerPoint.y - bluePoint.y);
    float greenDistance = (fingerPoint.x - greenPoint.x)*(fingerPoint.x - greenPoint.x)+(fingerPoint.y - greenPoint.y)*(fingerPoint.y - greenPoint.y);
        
    if(redDistance>2500&&blueDistance>2500&&greenDistance>2500)
        return nil;
    if(redDistance>=blueDistance){
        //r>b
//        return blueDistance>=greenDistance?greenPoint
        if(blueDistance>=greenDistance)
            return &greenPoint;
        else
            return &bluePoint;
    }
    else {// r<b  b&g
        if(greenDistance<=redDistance)
            return &greenPoint;
        
        else
            return &redPoint;
    }
    
    
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存触摸起始点位置
    if(touches.count == 1){
        CGPoint point = [[touches anyObject] locationInView:self];
        startPoint = point;
        currentRound = [self findCentre:point];
        
        //该view置于最前
        [[self superview] bringSubviewToFront:self];
        pinchZoom = NO;
    }

    else if(event.allTouches.count == 2) {
        pinchZoom = YES;
        NSArray *touches = [event.allTouches allObjects];
        CGPoint pointOne = [[touches objectAtIndex:0] locationInView:self];
        CGPoint pointTwo = [[touches objectAtIndex:1] locationInView:self];
        previousDistance = sqrt(pow(pointOne.x - pointTwo.x, 2.0f) +
                                pow(pointOne.y - pointTwo.y, 2.0f));
    }
    else {
        pinchZoom = NO;
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //计算位移=当前位置-起始位置
    if(touches.count == 1){
        CGPoint point = [[touches anyObject] locationInView:self];
        
        float dx = point.x - startPoint.x;
        float dy = point.y - startPoint.y;
    
        if(currentRound !=nil){
            currentRound->x = point.x;
            currentRound->y = point.y;
        }
        
        //计算移动后的view中心点
        CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
        
        
        /* 限制用户不可将视图托出屏幕 */
        float halfx = CGRectGetMidX(self.bounds);
        //x坐标左边界
        newcenter.x = MAX(halfx, newcenter.x);
        //    roundToMove->x = MAX(halfx, newcenter.x);
        //x坐标右边界
        newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
        //    roundToMove->x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
        
        //y坐标同理
        float halfy = CGRectGetMidY(self.bounds);
        newcenter.y = MAX(halfy, newcenter.y);
        newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
        //    roundToMove->y = MAX(halfy, newcenter.y);
        //     roundToMove->y  = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
        
        
        //移动view
        //    self.center = newcenter;
        [self setNeedsDisplay];
    }

    
    else if(YES == pinchZoom && event.allTouches.count == 2) {
        NSArray *touches = [event.allTouches allObjects];
        CGPoint pointOne = [[touches objectAtIndex:0] locationInView:self];
        CGPoint pointTwo = [[touches objectAtIndex:1] locationInView:self];
        CGFloat distance = sqrt(pow(pointOne.x - pointTwo.x, 2.0f) +
                                pow(pointOne.y - pointTwo.y, 2.0f));
        zoomFactor += (distance - previousDistance) / previousDistance;
        zoomFactor = fabs(zoomFactor);
        previousDistance = distance;
//        self.robotLayer.transform = CATransform3DMakeScale(zoomFactor, zoomFactor, 1.0f);
        radius = distance;
        [self setNeedsDisplay];
        
    }
}

-(void)swipe:(UISwipeGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateChanged ||
       gesture.state == UIGestureRecognizerStateEnded){
//        CGPoint start = [gesture lo];
//        CGPoint end
    }
}

//- (void)


-(void)scale:(UIPinchGestureRecognizer*)sender {
    
    //当手指离开屏幕时,将lastscale设置为1.0
    if([sender state] == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        return;
     }
    
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    radius = radius*scale;
    lastScale = [sender scale];
    [self setNeedsDisplay];
    
}

-(void) myInitWithFrame:(CGRect)frame{
    redPoint.x = 100;
    redPoint.y = 130;
//    ECUSTpurpleRoundView *purpleView = [[ECUSTpurpleRoundView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    [purpleView setBackgroundColor:[UIColor clearColor]];
//    [self addSubview:purpleView];
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 2.0);
//    CGRect theRect = CGRectMake(95.0, 95.0, 100.0, 100);
//    CGContextAddEllipseInRect(context, theRect);
//    
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextFillPath(context);
//    CGContextSetAlpha(context, 0.3);
//    CGContextStrokePath(context);
    
    CGPoint arcCenter=self.center;
//    UIBezierPath *_bezierpath=[UIBezierPath   bezierPathWithArcCenter:arcCenter
//                                                               radius:20
//                                                           startAngle:-M_PI_2
//                                                             endAngle:2*M_PI*percent -M_PI_2
//                                                            clockwise:YES];
//    _bezierpath=[UIBezierPath   bezierPathWithArcCenter:arcCenter
//                                                               radius:20
//                                                           startAngle:-M_PI_2
//                                                             endAngle:2*M_PI*percent -M_PI_2
//                                                            clockwise:YES];
//    
//    [_bezierpath addLineToPoint:self.center];
//    [_bezierpath closePath];
//    self->bezierpath = _bezierpath;
////    [_bezierpath release];
//    
//    CAShapeLayer *_shapeLayer=[CAShapeLayer layer];
//    _shapeLayer.fillColor=[UIColor blackColor].CGColor;
//    _shapeLayer.path = bezierpath.CGPath;
//    _shapeLayer.position =CGPointMake(-self.center.x+self.frame.size.width/2,-self.center.y+self.frame.size.height/2);
//    self.shapeLayer = _shapeLayer;
//    [_shapeLayer release];
//    [self.layer addSublayer:self.shapeLayer];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.frame);
    CGFloat startAngle = radians(0);
    CGFloat endAngle = radians(360);
    drawArc(context, self->redPoint, startAngle, endAngle, [UIColor yellowColor],radius);
    
}


@end
