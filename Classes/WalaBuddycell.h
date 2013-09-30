//
//  walaBuddycell.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-9-4.
//
//

#import <UIKit/UIKit.h>

@interface WalaBuddycell : UITableViewCell

@property (strong, nonatomic) UIImageView *userPhotoView;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *userDescriptionLabel;
@property (strong, nonatomic) UIImageView *userDescriptionView;
@property (strong, nonatomic) UIButton *delButton;
@property (nonatomic) NSInteger tag;


- (void)setPhoto:(UIImage *)image;


@end
