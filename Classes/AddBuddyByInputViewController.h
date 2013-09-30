//
//  AddBuddyByInputViewController.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-8-27.
//
//

#import <UIKit/UIKit.h>

@interface AddBuddyByInputViewController : UIViewController <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *jidTextField;


@property (strong, nonatomic) UIButton *addBuddyBtn;



@property (strong, nonatomic) id rootVC;
@end
