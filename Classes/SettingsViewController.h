//
//  SettingsViewController.h
//  iPhoneXMPP
//
//  Created by Eric Chamberlain on 3/18/11.
//  Copyright 2011 RF.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "beforeAllViews.h"
#import "ECUSTmyLoginVIew.h"
#import "ECUSTLoginAndReg.h"


extern NSString *const kXMPPmyJID;
extern NSString *const kXMPPmyPassword;
//extern NSString *const serverText;


@interface SettingsViewController : UIViewController 
{
    UITextField *jidField;
    UITextField *passwordField;
//    beforeAllViews *prepareView;
}

@property (weak, nonatomic) IBOutlet ECUSTLoginAndReg *myLoginAndReg;
//@property (strong, nonatomic) IBOutlet beforeAllViews *beforeAllViews;
@property (weak, nonatomic) IBOutlet ECUSTmyLoginVIew *myLoginView;
@property (nonatomic,strong) IBOutlet UITextField *jidField;
@property (nonatomic,strong) IBOutlet UITextField *passwordField;
//@property (strong, nonatomic) IBOutlet beforeAllViews *prepareView;


- (void)setField:(UITextField *)field forKey:(NSString *)key;
- (IBAction)done:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)loginError:(id)sender;
- (IBAction)registerXMPP:(id)sender;
- (IBAction)buttonForReg:(id)sender;
- (IBAction)buttonForLogin:(id)sender;

- (IBAction)buttonForPrepare:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender ;

@end
