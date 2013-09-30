//
//  ECUSTbuddyInfoCell.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-14.
//
//

#import "ECUSTbuddyMessageInfoCell.h"
#import "iPhoneXMPPAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ECUSTbuddyMessageInfoCell


- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGSize cellsize = {386,208};
        CGSize userPhotoSize = {45,45};
        CGSize authorLabel = {200,15};
        CGSize msgLabelSize = {150,13};
        CGSize msgTimeSize = {180, 13};
        
        UIImage *userPhoto = [UIImage imageNamed:@"defaultPerson.png"];
        CGRect photoRect= CGRectMake(15, 6, userPhotoSize.width, userPhotoSize.height);
        _userPhotoView = [[UIImageView alloc]initWithFrame:photoRect];
        _userPhotoView.contentMode = UIViewContentModeScaleAspectFit;
        CALayer *layer =_userPhotoView.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:6.0];
       
       
        
        _authoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 + userPhotoSize.width + 10 , 10, authorLabel.width , authorLabel.height)];
        _authoLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(18.0)];
        _authoLabel.backgroundColor = [UIColor clearColor];

        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 + userPhotoSize.width + 10, 35, msgLabelSize.width, msgLabelSize.height)];
        _messageLabel.font = [UIFont fontWithName:@"Arial" size:(15.0)];
        _messageLabel.backgroundColor = [UIColor clearColor];
        [_messageLabel setAlpha:0.7];
        
        
        _messageNotReadLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellsize.width - 80, 5, 30, 30)];
        _messageNotReadLabel.font = [UIFont fontWithName:@"Arial" size:(14.0)];
        _messageNotReadLabel.textColor = [UIColor redColor];
        
        _msgTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellsize.width - msgTimeSize.width,
                                                                     10,
                                                                     msgTimeSize.width,
                                                                     msgTimeSize.height)];
        _msgTimeLabel.font = [UIFont fontWithName:@"Arial" size:(13.0)];
        _msgTimeLabel.backgroundColor = [UIColor clearColor];
        
        
        
        
        
        _anchor = [[UIView alloc] initWithFrame:CGRectMake(cellsize.width - 50, 5, 50, 50)];
        
        
        
        [self.contentView addSubview:_userPhotoView];
        [self.contentView addSubview:_authoLabel];
        [self.contentView addSubview:_messageLabel];
        [self.contentView addSubview:_anchor];
        [self.contentView addSubview:_msgTimeLabel];
//        [self.contentView addSubview:_messageNotReadLabel];
        
//        UILabel *msg = [UILabel alloc]initWithFrame:(CGRect)
    }
    return self;
}


-(void)setPhoto:(UIImage *)image{
    if(image){
        [self.userPhotoView setImage:image];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
