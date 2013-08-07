//
//  addBuddyViewController.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-25.
//
//

#import <UIKit/UIKit.h>

@interface addBuddyViewController : UIViewController{
    UITextField *buddyJID;
    UITextField *buddyNick;
}
@property (strong, nonatomic) IBOutlet UITextField *buddyJID;
@property (strong, nonatomic) IBOutlet UITextField *buddyNick;
- (IBAction)addBuddy:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;

@end
