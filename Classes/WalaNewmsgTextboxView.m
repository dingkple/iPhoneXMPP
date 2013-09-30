//
//  WalaNewmsgTextboxView.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-9-11.
//
//

#import "WalaNewmsgTextboxView.h"
#import "JSBubbleView.h"

@implementation WalaNewmsgTextboxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (void)setup{
    [self setBackgroundColor:[UIColor clearColor]];
}


- (void)drawRect:(CGRect)frame
{
    // Drawing code
    UIImage *image = [UIImage imageNamed:@"chat_textbox.png"];
    //    CGSize bubbleSize = [JSBubbleView bubbleSizeForText:self.text];
//    CGSize bubbleSize = {101, 175};
    //	CGRect bubbleFrame = CGRectMake(([self styleIsOutgoing] ? 160.0f :self.frame.size.width - bubbleSize.width-160.0f),
    //                                    kMarginTop,
    //                                    bubbleSize.width,
    //                                    bubbleSize.height);
    CGRect bubbleFrame = CGRectMake(0, 0, 101, 175);
    
	[image drawInRect:bubbleFrame];
    
    CGSize textSize = [JSBubbleView textSizeForText:self.text];
	
    CGRect textFrame = CGRectMake(10,
                                  10,
                                  textSize.width,
                                  textSize.height);
    
	[self.text drawInRect:textFrame
                 withFont:[JSBubbleView font]
            lineBreakMode:NSLineBreakByWordWrapping
                alignment:NSTextAlignmentLeft];

    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
