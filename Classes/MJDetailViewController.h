//
//  MJDetailViewController.h
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJDetailViewController : UIViewController

@property (strong, nonatomic) NSMutableString *jidText;
@property (strong, nonatomic) IBOutlet UILabel *userBareJidLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userPhoto;
- (IBAction)acceptBuddyRequest:(id)sender;
- (IBAction)blockUser:(id)sender;
@end
