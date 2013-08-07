//
//  ECUSTbuddyInfoCell.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-14.
//
//

#import "ECUSTbuddyMessageInfoCell.h"
#import "iPhoneXMPPAppDelegate.h"

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
        CGSize userPhotoSize = {50,50};
        CGSize authorLabel = {200,20};
        CGSize msgLabelSize = {150,20};
        
        UIImage *userPhoto = [UIImage imageNamed:@"defaultPerson.png"];
        CGRect photoRect= CGRectMake(5, 10, userPhotoSize.width, userPhotoSize.height);
        _userPhotoView = [[UIImageView alloc]initWithFrame:photoRect];
       
       
        
        _authoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 +userPhotoSize.width + 10 , 6, authorLabel.width , authorLabel.height)];
        _authoLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(22.0)];
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 + userPhotoSize.width + 30, 50, msgLabelSize.width, msgLabelSize.height)];
        _messageLabel.font = [UIFont fontWithName:@"Arial" size:(15.0)];
        [_messageLabel setAlpha:0.7];
        _messageNotReadLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellsize.width - 80, 5, 30, 30)];
         _messageNotReadLabel.font = [UIFont fontWithName:@"Arial" size:(14.0)];
        _messageNotReadLabel.textColor = [UIColor redColor];
        _anchor = [[UIView alloc] initWithFrame:CGRectMake(cellsize.width - 50, 5, 50, 50)];
        
        
        
        [self.contentView addSubview:_userPhotoView];
        [self.contentView addSubview:_authoLabel];
        [self.contentView addSubview:_messageLabel];
        [self.contentView addSubview:_anchor];
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
