//
//  JSBubbleMessageCell.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSBubbleMessageCell.h"
#import "UIColor+JSMessagesView.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>


#define photoEdgeInsets (UIEdgeInsets){2,4,2,4}
#define photoSize (CGSize){45,45}
#define bubbleSize (CGSize){421,234}

@interface JSBubbleMessageCell(){
    UIActivityIndicatorView *_indicatorView;
}

@property (strong, nonatomic) JSBubbleView *bubbleView;
@property (strong, nonatomic) UIImageView *bubbleViewBackground;
@property (strong, nonatomic) UIImageView *photoView;
@property (strong, nonatomic) UILabel *timestampLabel;
@property (nonatomic) JSBubbleMessageStyle *style;



- (void)setup;
- (void)configureTimestampLabel;
- (void)configureWithStyle:(JSBubbleMessageStyle)style timestamp:(BOOL)hasTimestamp photo:(BOOL) hasPhoto;

@end



@implementation JSBubbleMessageCell

@synthesize soundFileUrl;


#pragma mark - Initialization

- (void)setFrame:(CGRect)frame
{
//    frame.origin.x += 120;
//    frame.size.width -= 120;
    frame.size.width = 480;
    frame.size.height = 240;
//    frame.size.height-=160;
    [super setFrame:frame];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
    
}

- (void)configureTimestampLabel
{
    self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                                    4.0f,
                                                                    self.bounds.size.width,
                                                                    14.0f)];
    self.timestampLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.textAlignment = NSTextAlignmentCenter;
    self.timestampLabel.textColor = [UIColor messagesTimestampColor];
    self.timestampLabel.shadowColor = [UIColor whiteColor];
    self.timestampLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.timestampLabel.font = [UIFont boldSystemFontOfSize:11.5f];
    
    [self.contentView addSubview:self.timestampLabel];
    [self.contentView bringSubviewToFront:self.timestampLabel];
}

- (void)configureWithStyle:(JSBubbleMessageStyle)style timestamp:(BOOL)hasTimestamp photo:(BOOL) hasPhoto
{
    self.style = style;
    
    CGFloat bubbleY = 0.0f;
    
    if(hasTimestamp) {
        [self configureTimestampLabel];
        bubbleY = 14.0f;
    }
    CGFloat rightOffsetX=0.0f;
    CGFloat leftOffsetX=0.0f;
//    float temp;
//    float temp1 = self.contentView.frame.size.width;
//    float temp2 = self.contentView.frame.size.height;
//    float temp3 = photoSize.width;
//    float temp4= photoSize.height;

    
    
    if(hasPhoto){
        
        if(style==JSBubbleMessageStyleIncomingDefault||style==JSBubbleMessageStyleIncomingSquare){
            rightOffsetX=photoEdgeInsets.left+photoSize.width+photoEdgeInsets.right;
//            self.photoView=[[UIImageView alloc] initWithFrame:(CGRect){photoEdgeInsets.left,self.contentView.frame.size.height-photoEdgeInsets.bottom-photoSize.height,photoSize}];
            self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 70, 45, 45)];
        }else{
//            leftOffsetX=photoEdgeInsets.left+photoSize.width+photoEdgeInsets.right;
//            self.photoView=[[UIImageView alloc] initWithFrame:(CGRect){self.contentView.frame.size.width-photoEdgeInsets.right-photoSize.width,self.contentView.frame.size.height-photoEdgeInsets.bottom-photoSize.height,photoSize}];
//            self.photoView=[[UIImageView alloc] initWithFrame:(CGRect){430,-5,photoSize}];
        }
        [self.contentView addSubview:self.photoView];
        self.photoView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
//        UIImage *testImage=[UIImage imageNamed:@"send"];
//        self.photoView.image=testImage;
    }
    
    if(style==JSBubbleMessageStyleIncomingDefault||style==JSBubbleMessageStyleIncomingSquare){
        self.bubbleViewBackground = [[UIImageView alloc] initWithFrame:(CGRect){50, 5, bubbleSize}];
        UIImage *left = [UIImage imageNamed:@"msgIncoming_Chatview"];
        [self.bubbleViewBackground setImage:left];
        
    }
    else{
        self.bubbleViewBackground = [[UIImageView alloc] initWithFrame:(CGRect){50, 5, bubbleSize}];
        UIImage *right = [UIImage imageNamed:@"msgOutgoing_Chatview"];
        [self.bubbleViewBackground setImage:right];
    }
//    [self.contentView addSubview:self.bubbleViewBackground];
//    [self.contentView subviews
//     self.photoView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    CGRect frame = CGRectMake(0,
                              0,
                              480,
                              248 - self.timestampLabel.frame.size.height);
//    CGRect frame = CGRectMake(rightOffsetX,
//                              bubbleY,
//                              self.contentView.frame.size.width+rightOffsetX-leftOffsetX,
//                              self.contentView.frame.size.height + self.timestampLabel.frame.size.height);
    
    self.bubbleView = [[JSBubbleView alloc] initWithFrame:frame
                                              bubbleStyle:style];
       
    
//    self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.contentView addSubview:self.bubbleView];
    [self.contentView sendSubviewToBack:self.bubbleView];
    
    UIButton *soundPlayBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    soundPlayBtn.titleLabel.text = @"play";
    if(self.style==JSBubbleMessageStyleIncomingDefault||self.style==JSBubbleMessageStyleIncomingSquare){
        soundPlayBtn.frame = CGRectMake(130, 185, 40, 20);
        
    }
    else{
        soundPlayBtn.frame = CGRectMake(150, 185, 40, 20);
    }
    [soundPlayBtn addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
    [soundPlayBtn setBackgroundColor:[UIColor yellowColor]];
    [self.contentView addSubview:soundPlayBtn];
   
}

- (id)initWithBubbleStyle:(JSBubbleMessageStyle)style hasTimestamp:(BOOL)hasTimestamp hasPhoto:(BOOL) hasPhoto reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
        [self configureWithStyle:style timestamp:hasTimestamp photo:hasPhoto];
    }
    return self;
}

#pragma mark - Setters
- (void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:color];
    [self.contentView setBackgroundColor:color];
    [self.bubbleView setBackgroundColor:color];
}

#pragma mark - Message Cell
- (void)setMessage:(NSString *)msg
{
    self.bubbleView.text = msg;
}


- (void)setAnimationImage:(NSString *)imageName{
    self.imageNameStr = imageName;
    
    NSMutableArray *images;
    if(!images){
        images = [[NSMutableArray alloc]init];
    }
    NSMutableString *imageNameTemp = [[NSMutableString alloc]initWithString:_imageNameStr];
    NSMutableString *temp = [[NSMutableString alloc]initWithString:[imageNameTemp substringToIndex:imageNameTemp.length-2]];
    for(int i=1;i<=100;i++){
        NSMutableString *imageString;
        if(i<10){
            imageString = [NSMutableString stringWithString:temp.copy];
            [imageString appendString:@"0"];
        }
        else {
            imageString = [NSMutableString stringWithString:temp.copy];
        }
        [imageString appendString:[NSString stringWithFormat:@"%d",i]];
        UIImage *newIMG = [UIImage imageNamed:imageString];
        if(newIMG){
            [images addObject:newIMG];
        }
        else break;
    }//    UIImageView *animationView;
    if(self.style==JSBubbleMessageStyleIncomingDefault||self.style==JSBubbleMessageStyleIncomingSquare){
        _animationView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 30, 180, 150)];
        
    }
    else{
        _animationView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 30, 180, 150)];
    }
    _animationView.animationImages = images;
    [_animationView setAnimationDuration:2.f];
    [_animationView setAnimationRepeatCount:0];
    [_animationView startAnimating];
    [_animationView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_animationView];

}

- (void) setPhoto:(NSString *)photoUrl
{
//    UIImage *image=[UIImage imageNamed:photoUrl];
//    self.photoView.image=image;
    [self.photoView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"default_avatar.jpg"]];
    CALayer *layer = self.photoView.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:0.7];
    
}

- (void) setPhotoWithImage: (UIImage *)image{
    if(image){
        [self.photoView setImage:image];
    }
    else
        [self.photoView setImage:[UIImage imageNamed:@"default_avatar.jpg"]];
    CALayer *layer = self.photoView.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:7];
}

- (void)setTimestamp:(NSDate *)date
{
    self.timestampLabel.text = [NSDateFormatter localizedStringFromDate:date
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterShortStyle];
}

- (void)addAccessoryView:(UIView*) view
{
    self.bubbleView.accessoryView=view;
}

- (void)setSoundFileUrl:(NSURL *)aSoundFileUrl{
   
    NSData *filedata = [[NSData alloc]initWithContentsOfURL:self.soundFileUrl];
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:aSoundFileUrl error:nil];
    _avPlay = newPlayer;
   
}

- (void)playSound:(id)sender{

    if(_avPlay){
        [_avPlay play];
    }
    
}
 

@end