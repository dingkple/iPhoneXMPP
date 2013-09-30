//
//  WalaTextEditVC.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-9-11.
//
//

#import <UIKit/UIKit.h>
#import "JSMessageInputView.h"


@protocol textEditing <NSObject>

- (void)setText:(NSString *)text;

@end

@interface WalaTextEditVC : UIViewController<UITextViewDelegate, textEditing>
@property (strong, nonatomic)NSString *text;
@property (strong, nonatomic)UITextView *inputView;
@property (strong, nonatomic)UIViewController *rootVC;
@property (weak, nonatomic) id<textEditing> textDelegate;
@end
