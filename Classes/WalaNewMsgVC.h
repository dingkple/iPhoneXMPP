//
//  WalaNewMsgVC.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-9-10.
//
//

#import <UIKit/UIKit.h>
#import "JSMessageInputView.h"
#import "ChatViewController.h"
#import "WalaNewmsgTextboxView.h"
#import "MJDetailViewController.h"
#import "WalaTextEditVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "TURNSocket.h"




@interface WalaNewMsgVC : UIViewController<UITextViewDelegate, textEditing, AVAudioPlayerDelegate,AVAudioRecorderDelegate, TURNSocketDelegate>{
    NSURL *recordedFile;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
//    BOOL isRecording;
    NSTimer *timer;
    NSURL *urlPlay;
}

@property (nonatomic) BOOL isRecording;
@property (strong, nonatomic) JSMessageInputView *inputView;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property (strong, nonatomic) ChatViewController *sourceViewController;
@property (strong, nonatomic) XMPPJID *chatJID;
@property (strong, nonatomic) UIImageView *animationView;
@property (retain, nonatomic) WalaTextEditVC *aWalaTextEditVC;
@property (strong, nonatomic) WalaNewmsgTextboxView *textview;

@property (strong, nonatomic)NSString *imageNameStr;

@property (strong, nonatomic)UIImageView *imageView;

@property (strong, nonatomic) TURNSocket *turnSocket;

@end
