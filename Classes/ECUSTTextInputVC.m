//
//  ECUSTTextInputVC.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-11.
//
//

#define INPUT_HEIGHT 40.0f

#import "ECUSTTextInputVC.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+JSMessagesView.h"


@interface ECUSTTextInputVC ()

@end

@implementation ECUSTTextInputVC

#pragma mark - Initialization

- (void) setup{
    CGRect viewFrame = CGRectMake(0, 0, 480, 320);
    [self.view setFrame:viewFrame];
    CGSize size = self.view.frame.size;
    
	CGRect rectBack = CGRectMake(0, 0, size.width, 22);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = rectBack;
    [button setTitle:@"BACK" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.tag = 2000;
    [button addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];

    UIButton *sendButton = [self sendButton];
    sendButton.enabled = NO;
    sendButton.frame = CGRectMake(self.inputView.frame.size.width - 65.0f, 8.0f, 59.0f, 26.0f);
    [sendButton addTarget:self
                   action:@selector(sendButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.inputView setSendButton:sendButton];
    [self.view addSubview:self.inputView];
    
    
    //make background clickable
//    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    dismissButton.backgroundColor = [UIColor clearColor];
//    dismissButton.frame = self.view.bounds;
//    [self.view addSubview:dismissButton];
}

- (UIButton *)sendButton
{
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
    UIImage *sendBack = [[UIImage imageNamed:@"send"] resizableImageWithCapInsets:insets];
    UIImage *sendBackHighLighted = [[UIImage imageNamed:@"send-highlighted"] resizableImageWithCapInsets:insets];
    [sendButton setBackgroundImage:sendBack forState:UIControlStateNormal];
    [sendButton setBackgroundImage:sendBack forState:UIControlStateDisabled];
    [sendButton setBackgroundImage:sendBackHighLighted forState:UIControlStateHighlighted];
    
    NSString *title = NSLocalizedString(@"Send", nil);
    [sendButton setTitle:title forState:UIControlStateNormal];
    [sendButton setTitle:title forState:UIControlStateHighlighted];
    [sendButton setTitle:title forState:UIControlStateDisabled];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    UIColor *titleShadow = [UIColor colorWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f];
    [sendButton setTitleShadowColor:titleShadow forState:UIControlStateNormal];
    [sendButton setTitleShadowColor:titleShadow forState:UIControlStateHighlighted];
    sendButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateDisabled];
    
    return sendButton;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void) viewWillAppear:(BOOL)animated{
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
//    [self scrollToBottomAnimated:YES];
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
//                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, self.tableView.contentInset.bottom + changeInHeight, 0.0f);
//                             self.tableView.contentInset = insets;
//                             self.tableView.scrollIndicatorInsets = insets;
                             
//                             [self scrollToBottomAnimated:NO];
                             
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



//this view does not contains keyboard anymore!!!

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
                         
//                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
//                                                                0.0f,
//                                                                self.view.frame.size.height - self.inputView.frame.origin.y - INPUT_HEIGHT,
//                                                                0.0f);
//                         self.tableView.contentInset = insets;
//                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
}



-(void) backButtonClicked:(id)sender{
    [self.navigationController popToViewController:self.sourceViewController animated:YES];
    [self.sourceViewController.tableView reloadData];
}

-(void) sendButtonPressed:(id) sedner{
    self.sourceViewController.chatUserJid = self.chatJID;
//    [self.sourceViewController.arrayChats removeAllObjects];
//    [[self.sourceViewController fetchedMessageController]performFetch:nil];
    NSString *inputText = [self.inputView.textView.text trimWhitespace];
    NSMutableDictionary *note = [NSMutableDictionary dictionaryWithObject:inputText forKey:@"InputText"];
    [note setObject:@"imaURL" forKey:@"imgURL"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newInputText" object:nil userInfo:note];
    [self.navigationController popToViewController:self.sourceViewController animated:YES];
}

@end
