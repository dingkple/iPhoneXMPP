//
//  walaBuddycell.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-9-4.
//
//

#import "WalaBuddycell.h"

@implementation WalaBuddycell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGSize userPhotoSize = {45 , 45};
        CGSize userNameLabelSize = {139 , 12};
        CGSize userDiscriptionBkgSize = {108,23};
        CGSize userDiscriptionLabelSize = {92,17};
        CGSize allContents = {446, 54};
        
        CGFloat leftInset = 15;
        CGFloat rightInset = 20;
        
        _userPhotoView = [[UIImageView alloc]initWithFrame:CGRectMake(leftInset, 5, userPhotoSize.width, userPhotoSize.height)];
        
        
        UIColor *userNametextColor = [UIColor colorWithRed:0  green:0 blue:0.6 alpha:1];
        
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 21, userNameLabelSize.width, userNameLabelSize.height)];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor = userNametextColor;
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        
        
        UIColor *userDiscriptionColor = [UIColor colorWithRed:0.455 green:0.282 blue:0.129 alpha:1];
        _userDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(allContents.width-leftInset-userDiscriptionBkgSize.width + 5, 17, userDiscriptionLabelSize.width, userDiscriptionLabelSize.height)];
        _userDescriptionLabel.backgroundColor = [UIColor clearColor];
        _userDescriptionLabel.textColor = userDiscriptionColor;
        _userDescriptionLabel.backgroundColor = [UIColor clearColor];
        _userDescriptionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];

        
        _userDescriptionView = [[UIImageView alloc]initWithFrame:CGRectMake(allContents.width-rightInset-userDiscriptionBkgSize.width, 15, userDiscriptionBkgSize.width, userDiscriptionBkgSize.height)];
        _userDescriptionView.image = [UIImage imageNamed:@"4.3Signature.png"];
        
        
        _delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delButton setBackgroundImage:[UIImage imageNamed:@"delBuddyBtn_Buddylist.png"] forState:UIControlStateNormal];
        [_delButton setFrame:CGRectMake(300, 5, 109, 43)];
        
        [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"buddyCell_Buddylist"]]];
       
//        [_delButton addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
        
        _delButton.hidden = YES;
        
        [self.contentView addSubview:_userPhotoView];
        [self.contentView addSubview:_userNameLabel];
        [self.contentView addSubview:_userDescriptionView];
        [self.contentView addSubview:_userDescriptionLabel];
        [self.contentView addSubview:_delButton];
        
    }
    return self;
}

- (void)setPhoto:(UIImage *)image{
    _userPhotoView.image = image;
    _userPhotoView.contentMode = UIViewContentModeScaleAspectFit;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
