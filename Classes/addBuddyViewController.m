//
//  addBuddyViewController.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-25.
//
//

#import "addBuddyViewController.h"
#import "iPhoneXMPPAppDelegate.h"

@interface addBuddyViewController ()

@end

@implementation addBuddyViewController

@synthesize buddyJID;
@synthesize buddyNick;

- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
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
    buddyJID.text = @"ios@cdn-2412b6cf3dc";
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    buddyJID.text = @"ios@cdn-2412b6cf3dc"; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBuddyJID:nil];
    [self setBuddyNick:nil];
    [super viewDidUnload];
}
- (IBAction)addBuddy:(id)sender {
//    NSMutableString *realJID = [[NSMutableString alloc] initWithString:buddyJID.text];
//    [realJID appendString:@"@cdn-2412b6cf3dc"];
//    buddyJID.text = realJID;
    XMPPJID *friendJID = [XMPPJID jidWithString:buddyJID.text];
    [[self appDelegate].xmppRoster addUser:friendJID withNickname:buddyNick.text];
}
-(IBAction)textFieldDoneEditing:(id)sender{
    [super resignFirstResponder];
}
@end
