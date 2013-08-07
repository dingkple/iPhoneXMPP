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

@end



@implementation SettingsViewController

- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)viewDidLoad{
    isForLogin = NO;
    isForReg = NO;
    isAllreadyLogin = NO;
    isAllreadyReg = NO;
    
//    CATransition *animation = [CATransition animation];
//    
//    [animation setDelegate:self];
//    [animation setType:kCATransitionPush];
//    [animation setSubtype:kCATransitionFromRight];
//    
//    [animation setDuration:3];
//    [animation setTimingFunction:
//     [CAMediaTimingFunction functionWithName:
//      kCAMediaTimingFunctionEaseInEaseOut]];
//    
//     [self.navigationController.view.layer addAnimation:animation forKey:kCATransition];
//    [self.view.layer addAnimation:animation forKey:kCATransition];
//    self.prepareView = _prepareView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"successfulLogin" object:nil];
    
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1.loginAndReg.png"]];
  
  //jidField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
  //passwordField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
//    CGRect prepareView = CGRectMake(0, 0, 320, 480);
//    CGRect loginButton = CGRectMake(163, 74, 155, 44);
//    CGRect regButton = CGRectMake(163, 152, 155, 44);
//    if(!isAllreadyLogin&&!isAllreadyReg){
//        CGRect theViewRect = CGRectMake(0, 0, 320, 480);
////        prepareView = [[beforeAllViews alloc]initWithFrame:theViewRect];
////        [self.view insertSubview:prepareView aboveSubview:self.view ];
//    }
    
//    CATransition *animation = [CATransition animation];
//    animation.delegate = self;
//    animation.duration = kDuration;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = kCATransitionFade;
//    NSInteger prepareViewInteger = [[self.view subviews] indexOfObject:self.myLoginAndReg];
//    NSInteger loginViewInterger = [[self.view subviews] indexOfObject: self.myLoginView];
//    [self.view exchangeSubviewAtIndex:loginViewInterger withSubviewAtIndex:prepareViewInteger];
//    [[self.view layer] addAnimation:animation forKey:@"animation"];
    
    
    
    /////////////////////////////////////
    ////////////////////////////////////
//    jidField.text = @"ios@vg-71c9051cc725";
//    jidField.text = @"ios@kingtekimacbook-pro.local/ios";
    jidField.text = @"ios";
    
    
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

- (IBAction)done:(id)sender
{
   // NSMutableString *realJID = [[NSMutableString alloc] initWithString:jidField.text];
    //[realJID appendString:@"cdn-2412b6cf3dc"];
    //jidField.text = realJID;
    [[self appDelegate] disconnect];
    if(isForReg){
//        NSMutableString *realJID = [[NSMutableString alloc] initWithString:jidField.text];
//        //    NSError *err;
//        NSRange range = [realJID rangeOfString:@"@"];
//        if(range.location == NSNotFound){
////            [realJID appendString:@"@cdn-2412b6cf3dc"];
//            
//        }
//        jidField.text = realJID;
//           [self setField:jidField forKey:kXMPPmyJID];
//        //    [self setField:passwordField forKey:kXMPPmyPassword];
//        [[self appDelegate] setRegister:YES];
//        if(jidField.text.length>0&&passwordField.text.length>0){
//            //        [self dismissViewControllerAnimated:YES completion:NULL];
//            if([[self appDelegate] anonymousConnect]){
//                [[[self appDelegate] xmppStream] setMyJID:[XMPPJID jidWithString:jidField.text]];
//                
//            }
//            
//        }
//        else {
//            //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login error" message:@"check ur JID and PW" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//            //        [alert show];
//            [self loginError:self];
//        }
        
    }
    else{
        [[self appDelegate] setRegister:NO];
        [self setField:jidField forKey:kXMPPmyJID];
        [self setField:passwordField forKey:kXMPPmyPassword];
        //    [[self appDelegate ] disconnect];
        //    [[self appDelegate] connect];
        //    if([[[self appDelegate] xmppStream] isConnected]){
        if(jidField.text.length>0&&passwordField.text.length>0){
            //        [self dismissViewControllerAnimated:YES completion:NULL];
            [[self appDelegate] connect];
        }
        else {
            //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login error" message:@"check ur JID and PW" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            //        [alert show];
            [self loginError:self];
            [[self appDelegate] disconnect];
        }

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

-(IBAction)loginError:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login error" message:@"check ur JID and PW" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];

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
    UIAlertView* noteView = [[UIAlertView alloc] initWithTitle:nil message:@"SettingView receive a noti for successlogin!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [noteView show];
    [self performSegueWithIdentifier:@"successfulLogin" sender:self];
//    [noteView release];
}


- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender {
    [self.jidField resignFirstResponder];
    [self.passwordField resignFirstResponder];
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
