//
//  ECUSTmyRegViewController.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-30.
//
//

#import <UIKit/UIKit.h>

//extern NSString *const kXMPPmyJID;
//extern NSString *const kXMPPmyPassword;



@interface ECUSTmyRegViewController : UIViewController{
    NSString *phoneNumber;
    NSString *identifycondeFromServer;
    BOOL isMotionSetted;
    BOOL isAngel;
}

@property (strong, nonatomic) IBOutlet UITextField *phoneText;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *identifycodeText;
@property (strong, nonatomic) IBOutlet UITextField *firstPasswordText;
@property (strong, nonatomic) IBOutlet UITextField *secondPasswordText;
@property (strong, nonatomic) NSString *identifycondeFromServer;
//@property (strong, nonatomic) 


- (IBAction)phoneIsReady:(id)sender;
- (IBAction)regInfoIsReady:(id)sender;

@end
