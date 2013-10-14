//
//  JSMessagesViewController.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSMessagesViewController.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+JSMessagesView.h"
#import "ECUSTMessageVC.h"
#import <AVFoundation/AVFoundation.h>


#define INPUT_HEIGHT 40.0f

@interface JSMessagesViewController (){
    CGSize currentSize;
}

@property (strong,nonatomic) NSMutableArray *arrayChats;

- (void)setup;
- (void)backButtonClicked;

@end



@implementation JSMessagesViewController

#pragma mark - Initialization
- (void)setup
{
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    self.navigationController.navigationBarHidden = NO;
    CGRect viewFrame = CGRectMake(0, 0, 480, 320);
    [self.view setFrame:viewFrame];
    
    
    
    
    
    CGSize size = CGSizeMake(480, 320);


    
    CGRect rectNotReadList = CGRectMake(90, 0, 70, 22);
    UIButton *buttonNotRead = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonNotRead.frame = rectNotReadList;
    [buttonNotRead setTitle:@"NotRead" forState:UIControlStateNormal];
    buttonNotRead.backgroundColor = [UIColor clearColor];
    buttonNotRead.tag = 2002;
    [buttonNotRead addTarget:self action:@selector(showOrHideNotReadList:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:buttonNotRead];

    
   
    
    
    
    CGRect tableFrame = CGRectMake(0.0f, 0.f, size.width, size.height);
	self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
//	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewResign)];
    [self.tableView addGestureRecognizer:tap];
    
	[self.view addSubview:self.tableView];
	
    [self setBackgroundColor:[UIColor messagesBackgroundColor]];
//    
//    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
//    self.inputView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
//    
//    UIButton *sendButton = [self sendButton];
//    sendButton.enabled = NO;
//    sendButton.frame = CGRectMake(self.inputView.frame.size.width - 65.0f, 8.0f, 59.0f, 26.0f);
//    [sendButton addTarget:self
//                   action:@selector(sendPressed:)
//         forControlEvents:UIControlEventTouchUpInside];
//    [self.inputView setSendButton:sendButton];
//    [self.view addSubview:self.inputView];
    
    CGRect notReadTableFrame = CGRectMake(90.0f, 22.0f, 90.0f, size.height-72);
	self.notReadTableView = [[UITableView alloc] initWithFrame:notReadTableFrame style:UITableViewStylePlain];
	self.notReadTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.notReadTableView.dataSource = self;
	self.notReadTableView.delegate = self;
    self.notReadTableView.backgroundColor = [UIColor clearColor];
//    self.notReadTableView.allowsSelection = YES;
//    self.notReadTableView.allowsMultipleSelection = NO;
//    self.notReadTableView.userInteractionEnabled = YES;
    
//    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewResign)];
//    [self.notReadTableView addGestureRecognizer:tap2];
    
	[self.view addSubview:self.notReadTableView];
    [self.view bringSubviewToFront:self.notReadTableView];
	
//    [self setBackgroundColor:[UIColor messagesBackgroundColor]];
    CGRect newMsgNoteRect = CGRectMake(20, 100, 50, 50);
    UIImageView *notReadMsgNote = [[UIImageView alloc]initWithFrame:newMsgNoteRect];
    notReadMsgNote.tag = 500; 
    notReadMsgNote.hidden =YES;
    [self.view addSubview:notReadMsgNote];
    
    
    
    
    //buttons on the bottom of the View
    CGRect bottomBkg = CGRectMake(10, 260, size.width-20, 50);
    UIView *bottomButtonBkg = [[UIView alloc]initWithFrame:bottomBkg];
    
//    CGRect button1Rect = CGRectMake(15,5,50,30);
//    UIButton *bottomButtonSwitch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    bottomButtonSwitch.frame = button1Rect;
//    [bottomButtonSwitch setTitle:@"state" forState:UIControlStateNormal];
//    bottomButtonSwitch.backgroundColor = [UIColor clearColor];
//    bottomButtonSwitch.tag = 3001;
//    [bottomButtonSwitch addTarget:self action:@selector(bottomButtonSwitchClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:bottomButtonSwitch];
//    [bottomButtonBkg addSubview:bottomButtonSwitch];
//    
//    
//    CGRect button2Rect = CGRectMake(80,5,80,30);
//    UIButton *bottomButtonNewMsg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    bottomButtonNewMsg.frame = button2Rect;
//    [bottomButtonNewMsg setTitle:@"new" forState:UIControlStateNormal];
//    bottomButtonNewMsg.backgroundColor = [UIColor clearColor];
//    bottomButtonNewMsg.tag = 3002;
//    [bottomButtonNewMsg addTarget:self action:@selector(bottomButtonNewMsgClicked:) forControlEvents:UIControlEventTouchUpInside];
////    [self.view addSubview:bottomButtonNewMsg];
//    [bottomButtonBkg addSubview:bottomButtonNewMsg];
//    
//    CGRect button3Rect = CGRectMake(175,5,80,30);
//    UIButton *bottomButtonSoundInput = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    bottomButtonSoundInput.frame= button3Rect;
//    [bottomButtonSoundInput setTitle:@"sound" forState:UIControlStateNormal];
//    bottomButtonSoundInput.backgroundColor = [UIColor clearColor];
//    bottomButtonSoundInput.tag = 3003;
//    [bottomButtonSoundInput addTarget:self action:@selector(bottomButtonSoundInputClicked:) forControlEvents:UIControlEventTouchUpInside];
////    [self.view addSubview:bottomButtonSoundInput];
//    [bottomButtonBkg addSubview:bottomButtonSoundInput];
    
    CGRect button4Rect = CGRectMake(270,5,80,30);
    UIButton *bottomButtonAttach = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bottomButtonAttach.frame = button4Rect;
    [bottomButtonAttach setTitle:@"attach" forState:UIControlStateNormal];
    bottomButtonAttach.backgroundColor = [UIColor clearColor];
    bottomButtonAttach.tag = 3004;
    [bottomButtonAttach addTarget:self action:@selector(bottomButtonAttachClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:bottomButtonAttach];
    [bottomButtonBkg addSubview:bottomButtonAttach];
    
    CGRect button5Rect = CGRectMake(385,5,75,30);
    UIButton *bottomButtonReply = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bottomButtonReply.frame = button5Rect;
    [bottomButtonReply setTitle:@"send" forState:UIControlStateNormal];
    bottomButtonReply.backgroundColor = [UIColor clearColor];
    bottomButtonReply.tag = 3005;
    [bottomButtonReply addTarget:self action:@selector(bottomButtonReplyClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:bottomButtonReply];
    [bottomButtonBkg addSubview:bottomButtonReply];
    [self.view addSubview: bottomButtonBkg];
    
    
    
   
    UIButton *soundMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    soundMsgBtn.frame =  CGRectMake(0,243,70,57);
    [soundMsgBtn setBackgroundImage:[UIImage imageNamed:@"soundMsgButton_Chatview"] forState:UIControlStateNormal];
    soundMsgBtn.tag = 4001;
    [soundMsgBtn addTarget:self action:@selector(bottomButtonReplyClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:bottomButtonReply];
    [self.view addSubview: soundMsgBtn];
    
    UIButton *animateMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    animateMsgBtn.frame =  CGRectMake(412,243,68,57);
    [animateMsgBtn setBackgroundImage:[UIImage imageNamed:@"animateMsgBtn_Chatview"] forState:UIControlStateNormal];
    animateMsgBtn.tag = 4002;
    [animateMsgBtn addTarget:self action:@selector(bottomButtonReplyClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:bottomButtonReply];
    [self.view addSubview: animateMsgBtn];
    
    
    
    
    
    CGRect rectBack = CGRectMake(13, 3, 49, 41);
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = rectBack;
    //    [buttonBack setTitle:@"BACK" forState:UIControlStateNormal];
    buttonBack.backgroundColor = [UIColor clearColor];
    buttonBack.tag = 2000;
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backbutton_Chatview"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    
    UIImageView *topcover = [[UIImageView alloc]initWithFrame:CGRectMake(90, 0, 304, 39)];
    topcover.image = [UIImage imageNamed:@"topcover_Chatview"];
    [self.view addSubview:topcover];
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//    swipe.direction = UISwipeGestureRecognizerDirectionDown;
//    swipe.numberOfTouchesRequired = 1;
//    [self.inputView addGestureRecognizer:swipe];
    
    UIButton *topcoverButtonChangeBuddy = [UIButton buttonWithType:UIButtonTypeCustom];
    topcoverButtonChangeBuddy.frame = CGRectMake(110, 5, 25, 22);
    [topcoverButtonChangeBuddy setBackgroundImage:[UIImage imageNamed:@"topcoverbuttonChagephoto_Chatview"] forState:UIControlStateNormal];
    topcoverButtonChangeBuddy.tag = 3001;
    [self.view addSubview:topcoverButtonChangeBuddy];
    
    
    UIButton *topcoverButtonListMode = [UIButton buttonWithType:UIButtonTypeCustom];
    topcoverButtonListMode.frame = CGRectMake(310, 7, 24, 16);
    [topcoverButtonListMode setBackgroundImage:[UIImage imageNamed:@"topcoverbuttonListmode_Chatview"] forState:UIControlStateNormal];
    topcoverButtonListMode.tag = 3002;
    [self.view addSubview:topcoverButtonListMode];
    
    UIButton *topcoverButtonMore = [UIButton buttonWithType:UIButtonTypeCustom];
    topcoverButtonMore.frame = CGRectMake(350, 5, 20, 19);
    [topcoverButtonMore setBackgroundImage:[UIImage imageNamed:@"topcoverbuttonMore_Chatview"] forState:UIControlStateNormal];
    topcoverButtonMore.tag = 3003;
    [self.view addSubview:topcoverButtonMore];
    
    CGRect rectUserJidLabel = CGRectMake(200, 4, 150, 22);
    _labelUserJid = [[UILabel alloc]initWithFrame:rectUserJidLabel];
    _labelUserJid.backgroundColor = [UIColor clearColor];
    _labelUserJid.tag = 3004;
    [self.view addSubview: _labelUserJid];

    

}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//   
//}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self scrollToBottomAnimated:NO];
    [self.view setAutoresizingMask:UIViewAutoresizingNone];
    
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(handleWillShowKeyboard:)
//												 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(handleWillHideKeyboard:)
//												 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"*** %@: didReceiveMemoryWarning ***", self.class);
}

#pragma mark - View rotation

- (void) textViewResign
{
    [self.inputView.textView resignFirstResponder];
}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (toInterfaceOrientation != self.interfaceOrientation) {
        CGSize newSize;
        // 20 is the status bar height
        newSize.width = self.view.bounds.size.height + 20;
        newSize.height = self.view.bounds.size.width - 20;
        currentSize = newSize;
        //any other necessary code
    }
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

#pragma mark - Actions
-(void) bottomButtonSwitchClicked:(id)sender{
    
}

- (void) bottomButtonNewMsgClicked:(id)sender{
//    ECUSTMessageVC *newmsg = [[ECUSTMessageVC alloc] init];
//    [self.navigationController pushViewController:newmsg animated:YES];
    [self.delegate bottomButtonNewMsgClicked:self];
}

- (void) bottomButtonSoundInputClicked:(id)sender{
    
}

- (void) bottomButtonAttachClicked :(id)sender{
    [self.delegate bottomButtonAttachClicked:self];
    
}

- (void) bottomButtonReplyClicked :(id)sender{
    [self.delegate bottomButtonReplyClicked:self];
    
}



- (void)sendPressed:(UIButton *)sender
{
    [self.delegate sendPressed:sender
                      withText:[self.inputView.textView.text trimWhitespace]];
}

- (void)handleSwipe:(UIGestureRecognizer *)guestureRecognizer
{
    [self.inputView.textView resignFirstResponder];
}

- (void)showOrHideNotReadList:(id)sender{
    self.notReadTableView.hidden = !self.notReadTableView.hidden;
    [self.view bringSubviewToFront:self.notReadTableView];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView){
        JSBubbleMessageStyle style = [self.delegate messageStyleForRowAtIndexPath:indexPath];
        BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
        
//        NSString *photoUrl;
        UIImage *image;
        if([self.dataSource respondsToSelector:@selector(photoForRowAtIndexPath:)]){
            image=[self.dataSource photoForRowAtIndexPath:indexPath];
        }
        BOOL hasPhoto=image!=nil;
        UIView *accessoryView;
        if([self.dataSource respondsToSelector:@selector(accessoryViewForRowAtIndexPath:)]){
            accessoryView=[self.dataSource accessoryViewForRowAtIndexPath:indexPath];
        }
        
        NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d", style, hasTimestamp];
        JSBubbleMessageCell *cell = (JSBubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
        
        if(!cell) {
            cell = [[JSBubbleMessageCell alloc] initWithBubbleStyle:style
                                                       hasTimestamp:hasTimestamp hasPhoto:hasPhoto
                                                    reuseIdentifier:CellID];
        }
        else {
            [cell.animationView startAnimating];
        }
        
        if(hasTimestamp)
            [cell setTimestamp:[self.dataSource timestampForRowAtIndexPath:indexPath]];
        
        [cell setMessage:[self.dataSource textForRowAtIndexPath:indexPath]];
        [cell setAnimationImage:[self.dataSource imagenameForRowAtIndexPath:indexPath]];
        [cell setSoundFileUrl:[self getSoundUrl:[self.dataSource textForRowAtIndexPath:indexPath]]];
        if(image){
//            [cell setPhoto:photoUrl];
            [cell setPhotoWithImage:image];
        }
        if(accessoryView){
            [cell addAccessoryView:accessoryView];
        }
        [cell setBackgroundColor:tableView.backgroundColor];
         return cell;
    }
    else {
        NSString *cellID = @"notReadCell";
        ECUSTNotReadCell *cell =(ECUSTNotReadCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[ECUSTNotReadCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        [self.dataSource configureNotReadCell:cell withIndex: indexPath];
        return cell;
    }
    
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *cleaerBkg = [[UIView alloc]init];
    cleaerBkg.backgroundColor = [UIColor clearColor];
    return cleaerBkg;
}



#pragma mark - Table view delegate



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat dateHeight = [self shouldHaveTimestampForRowAtIndexPath:indexPath] ? DATE_LABEL_HEIGHT : 0.0f;
//    
//    return [JSBubbleView cellHeightForText:[self.dataSource textForRowAtIndexPath:indexPath]] + dateHeight;
    
//    ********************************************************************
    return 240;
}

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate timestampPolicyForMessagesView]) {
        case JSMessagesViewTimestampPolicyAll:
            return YES;
            break;
        case JSMessagesViewTimestampPolicyAlternating:
            return indexPath.row % 2 == 0;
            break;
        case JSMessagesViewTimestampPolicyEveryThree:
            return indexPath.row % 3 == 0;
            break;
        case JSMessagesViewTimestampPolicyEveryFive:
            return indexPath.row % 5 == 0;
            break;
        case JSMessagesViewTimestampPolicyCustom:
            return NO;
            break;
    }
    
    return NO;
}

- (void)finishSend
{
    [self.inputView.textView setText:nil];
    [self textViewDidChange:self.inputView.textView];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}


- (CGRect)rectForFooterInSection:(NSInteger)section{
    return CGRectZero;
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    CGFloat textViewContentHeight = textView.contentSize.height;
    if(self.previousTextViewContentHeight == 0){
        self.previousTextViewContentHeight = 36.0;
    }
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    changeInHeight = (textViewContentHeight + changeInHeight >= maxHeight) ? 0.0f : changeInHeight;
    
    if(!isShrinking)
        [self.inputView adjustTextViewHeightBy:changeInHeight];
    
    if(changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, self.tableView.contentInset.bottom + changeInHeight, 0.0f);
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                            
                             [self scrollToBottomAnimated:NO];
                            
                             CGRect inputViewFrame = self.inputView.frame;
                             self.inputView.frame = CGRectMake(0.0f,
                                                               inputViewFrame.origin.y - changeInHeight,
                                                               inputViewFrame.size.width,
                                                               inputViewFrame.size.height + changeInHeight);
                         }
                         completion:^(BOOL finished) {
                             if(isShrinking)
                                 [self.inputView adjustTextViewHeightBy:changeInHeight];
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    self.inputView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;

                         self.inputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                           inputViewFrameY,
                                                           inputViewFrame.size.width,
                                                           inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.view.frame.size.height - self.inputView.frame.origin.y - INPUT_HEIGHT,
                                                                0.0f);
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
}


-(void) backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSURL *)getSoundUrl:(NSString *)soundFileName{
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //  get a name for the sound file
    NSMutableString *soundFileStr = [[NSMutableString alloc]initWithString:strUrl];
    [soundFileStr appendString:@"/"];
    [soundFileStr appendString:soundFileName];
    [soundFileStr appendString:@"lll.aac"];
    NSURL *soundFileUrl = [NSURL fileURLWithPath:soundFileStr];
   
    return soundFileUrl;

}
@end