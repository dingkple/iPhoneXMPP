//
//  ECUSTTextInputVC.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-11.
//
//

#import <UIKit/UIKit.h>
#import "JSMessageInputView.h"
#import "ChatViewController.h"


@interface ECUSTTextInputVC : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) JSMessageInputView *inputView;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property (strong, nonatomic) ChatViewController *sourceViewController;
@property (strong, nonatomic) XMPPJID *chatJID;
@end
