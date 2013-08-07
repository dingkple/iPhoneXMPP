//
//  ECUSTNotReadCell.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-22.
//
//

#import "ECUSTNotReadCell.h"

@implementation ECUSTNotReadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGSize photoSize = {40 , 40 };
        _photoView = [[UIImageView alloc]initWithFrame:CGRectMake(5,10,photoSize.width,photoSize.height)];
        [self.contentView addSubview:_photoView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
