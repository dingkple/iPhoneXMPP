//
//  ECUSTbuddyInfoCell.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-14.
//
//

#import <UIKit/UIKit.h>

@interface ECUSTbuddyMessageInfoCell : UITableViewCell

@property (strong, nonatomic) UIImageView *userPhotoView;
@property (strong, nonatomic) UILabel *authoLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *messageNotReadLabel;
@property (strong, nonatomic) UIView *anchor;



-(void)setPhoto:(UIImage *)image;
@end
