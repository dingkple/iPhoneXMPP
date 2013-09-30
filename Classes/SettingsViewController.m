//
//  SettingsViewController.m
//  iPhoneXMPP
//
//  Created by Eric Chamberlain on 3/18/11.
//  Copyright 2011 RF.com. All rights reserved.
//

#import "SettingsViewController.h"
#import "iPhoneXMPPAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.7   // 动画持续时间(秒)


NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";
//NSString *const serverText = @"vg-71c9051cc725";

@interface SettingsViewController(){
    BOOL *isForLogin;
    BOOL *isForReg;
    BOOL *isAllreadyLogin;
    BOOL *isAllreadyReg;
}

@property (strong, nonatomic) UIImageView *wrongPasswordView;
@end



@implementation SettingsViewController

- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)setupViews{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"back_ground"]]];
    
    UIImageView *topbar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 480, 79)];
    topbar.image = [UIImage imageNamed:@"topbar"];
    [self.view addSubview:topbar];
    
    CGRect backButtonRect = CGRectMake(5, 28, 49, 41);
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backButtonRect;
    [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 101;
    [self.view addSubview:backButton];
    
    CGRect loginConfirmRect = CGRectMake(375, 20, 101, 54);
    UIButton *loginConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    loginConfirm.frame = loginConfirmRect;
    [loginConfirm setBackgroundImage:[UIImage imageNamed:@"login_Confirm"] forState:UIControlStateNormal];
    [loginConfirm addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    loginConfirm.tag = 102;
    [self.view addSubview:loginConfirm];
    
    UIImageView *inputbarBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputbar"]];
    inputbarBackground.frame = CGRectMake(34, 83, 411, 46);
    [self.view addSubview:inputbarBackground];
    
    jidField = [[UITextField alloc]initWithFrame:CGRectMake(63, 95, 150, 36)];
    jidField.tag = 201;
    jidField.delegate = self;
    [self.view addSubview:jidField];
    
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(270, 95, 150, 36)];
    passwordField.tag = 202;
    [passwordField setSecureTextEntry:YES];
    passwordField.delegate = self;
    [self.view addSubview:passwordField];
    
    _wrongPasswordView = [[UIImageView alloc]initWithFrame:CGRectMake(270, 135, 177, 74)];
    _wrongPasswordView.image = [UIImage imageNamed:@"wrongPassword"];
    _wrongPasswordView.hidden = YES;
    [self.view addSubview: _wrongPasswordView];
    
    
    
}

-(void)viewDidLoad{
    isForLogin = NO;
    isForReg = NO;
    isAllreadyLogin = NO;
    isAllreadyReg = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"successfulLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"failedLogin" object:nil];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Init/dealloc methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)awakeFromNib {
  self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark View lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
    [self setupViews];
    jidField.text = @"rios";
    passwordField.text = @"123";
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)setField:(UITextField *)field forKey:(NSString *)key
{
  if (field.text != nil) 
  {
      if(field == self.jidField){
          NSMutableString *jid = [[NSMutableString alloc] initWithString:jidField.text];
          [jid appendString:@"@127.0.0.1/ios"];
          [[NSUserDefaults standardUserDefaults] setObject:jid forKey:key];
      }
      else {
          [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:key];
      }
     
  }
  else {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)done:(id)sender
{
    //disconnect if allready login
    [self.jidField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    
    [[self appDelegate] disconnect];
    
    [[self appDelegate] setRegister:NO];
    [self setField:jidField forKey:kXMPPmyJID];
    [self setField:passwordField forKey:kXMPPmyPassword];
    //    [[self appDelegate ] disconnect];
    //    [[self appDelegate] connect];
    //    if([[[self appDelegate] xmppStream] isConnected]){
    if(jidField.text.length>0&&passwordField.text.length>0){
        //        [self dismissViewControllerAnimated:YES completion:NULL];ssdssss
        [[self appDelegate] connect];
    }
    else {
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login error" message:@"check ur JID and PW" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        //        [alert show];
        [self loginError:self];
        [[self appDelegate] disconnect];
    }

}

-(IBAction)registerXMPP:(id)sender{
    NSMutableString *realJID = [[NSMutableString alloc] initWithString:jidField.text];
//    NSError *err;
    NSRange range = [realJID rangeOfString:@"@"];
    if(range.location == NSNotFound){
         [realJID appendString:serverText];
    }
    jidField.text = realJID;
//    [self setField:jidField forKey:kXMPPmyJID];
//    [self setField:passwordField forKey:kXMPPmyPassword];
    [[self appDelegate] setRegister:YES];
    if(jidField.text.length>0&&passwordField.text.length>0){
        //        [self dismissViewControllerAnimated:YES completion:NULL];
        if([[self appDelegate] anonymousConnect]){
            [[[self appDelegate] xmppStream] setMyJID:[XMPPJID jidWithString:jidField.text]];
            
        }
        
    }
    else {
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login error" message:@"check ur JID and PW" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        //        [alert show];
        [self loginError:self];
    }
}

- (IBAction)hideKeyboard:(id)sender {
  [sender resignFirstResponder];
  [self done:sender];
}

- (void)loginError:(id)sender{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login error" message:@"check ur JID and PW" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [alert show];
    _wrongPasswordView.hidden = NO;
    
}

- (void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark prepareLoginView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




- (IBAction)buttonForReg:(id)sender {
    isForLogin = NO;
    isForReg = YES;
//    [self.prepareView removeFromSuperview];
}

- (IBAction)buttonForLogin:(id)sender {
    isForLogin = YES;
    isForReg =NO;
//    if([self.view.subviews containsObject:prepareView]){
//        [self.prepareView removeFromSuperview];
//    }
//    [self.prepareView removeFromSuperview];
}

-(IBAction)buttonForPrepare:(id)sender{
    isForLogin = NO;
    isForReg =NO;
//    prepareView = [[beforeAllViews alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
//    [UIView transitionWithView:self.prepareView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
//                    animations:^{
//        [self.view addSubview:_prepareView];
//    }completion:NULL];
   
}

-(void)receiveNotification:(NSNotification*)note{
//    UIAlertView* noteView = [[UIAlertView alloc] initWithTitle:nil message:@"SettingView receive a noti for successlogin!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [noteView show];
    
    if([note.name isEqualToString:@"successfulLogin"]){
      [self performSegueWithIdentifier:@"successfulLogin" sender:self];  
    }
    
    if([note.name isEqualToString:@"failedLogin"]){
        _wrongPasswordView.hidden = NO;
    }
    
//    [noteView release];
}


- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender {
    [self.jidField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _wrongPasswordView.hidden = YES;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Getter/setter methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize jidField;
@synthesize passwordField;
//@synthesize beforeAllViews;
@synthesize myLoginView;

- (void)viewDidUnload {
//    [self setPrepareView:nil];
    [self setMyLoginView:nil];
//    [self setBeforeAllViews:nil];
    [self setMyLoginAndReg:nil];
    [super viewDidUnload];
}

@end
