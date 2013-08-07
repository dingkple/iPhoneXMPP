//
//  MJDetailViewController.m
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import "MJDetailViewController.h"
#import "iPhoneXMPPAppDelegate.h"
#import "XMPPJID.h"
#define kServername @"@127.0.0.1"



//These two variables better named userJidLabel
@implementation MJDetailViewController
@synthesize userBareJidLabel;
@synthesize jidText;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Accessors
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark ViewLifecircle
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidUnload {
    [self setUserBareJidLabel:nil];
    [self setUserPhoto:nil];
    [super viewDidUnload];
}
- (MJDetailViewController *) init{
    if(!self.jidText){
        self.jidText = [[NSMutableString alloc] init];
    }
    if(!self.userBareJidLabel){
        self.userBareJidLabel = [[UILabel alloc]init];
    }
    return self;
}



-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.userBareJidLabel.text = self.jidText;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark buttonActions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)acceptBuddyRequest:(id)sender {
    NSMutableString *newJid = [[NSMutableString alloc ] initWithString:self.userBareJidLabel.text];
    [newJid appendString:kServername];
    [[self appDelegate].xmppRoster acceptPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:newJid] andAddToRoster:YES];
}

- (IBAction)blockUser:(id)sender {
    NSMutableString *newJid = [[NSMutableString alloc ] initWithString:jidText];
    [newJid appendString:kServername];
    [[self appDelegate].xmppRoster rejectPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:newJid]];
}
@end
