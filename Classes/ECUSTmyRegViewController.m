//
//  ECUSTmyRegViewController.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-30.
//
//

#import "ECUSTmyRegViewController.h"
#import "iPhoneXMPPAppDelegate.h"
#import "SettingsViewController.h"
#import "MJPopupBackgroundView.h"


//#define kXMPPmyJID @"kXMPPmyJID"
//#define kXMPPmyPassword @"kXMPPmyPassword"

//NSString *const kXMPPmyJID = @"kXMPPmyJID";
//NSString *const kXMPPmyPassword = @"kXMPPmyPassword";



@interface ECUSTmyRegViewController ()


@end

@implementation ECUSTmyRegViewController
@synthesize phoneNumber;


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
    self.identifycondeFromServer = @"111";
    self.phoneNumber = phoneNumber;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"successfulReg" object:nil];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString: @"phoneIsReady"]){
        if([segue.destinationViewController isKindOfClass:[ECUSTmyRegViewController class]]){
            ECUSTmyRegViewController *myReg = (ECUSTmyRegViewController *)segue.destinationViewController;
            myReg.phoneNumber = self.phoneText.text;
        }
    }
}


- (void)viewDidUnload {
    [self setPhoneText:nil];
    [self setIdentifycodeText:nil];
    [self setFirstPasswordText:nil];
    [super viewDidUnload];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark buttonActions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)phoneIsReady:(id)sender {
    //    self.phoneText =
//    NSString *userPhone =
    [[self appDelegate] disconnect];
    self.phoneNumber = self.phoneText.text;
    if(self.phoneNumber.length >0 ){
        [self performSegueWithIdentifier:@"phoneIsReady" sender:self];
    }
    
}

- (IBAction)regInfoIsReady:(id)sender {
    if([self.identifycodeText.text isEqualToString:self.identifycondeFromServer]){
        if([self.firstPasswordText.text isEqualToString: self.secondPasswordText.text]){
            NSMutableString *realJID = [[NSMutableString alloc] initWithString:self.phoneNumber];
            //    NSError *err;
            NSRange range = [realJID rangeOfString:@"@"];
            if(range.location == NSNotFound){
//                [realJID appendString:@"@cdn-2412b6cf3dc"];
                [realJID appendString:@"@"];
                NSString *serverText = [[self appDelegate].xmppStream.myJID domain];
                [realJID appendString:serverText];
            }
//            self.phoneNumber = realJID;
            [self setField:realJID forKey: kXMPPmyJID];
            [self setField:self.firstPasswordText.text forKey: kXMPPmyPassword];
            [[self appDelegate] setRegister:YES];
            [[self appDelegate] setPassword:self.firstPasswordText.text];

            if([[self appDelegate] anonymousConnect]){
                [[[self appDelegate] xmppStream] setMyJID:[XMPPJID jidWithString:realJID]];
            }

        }
    }
    
}

- (void)setField:(NSString *)field forKey:(NSString *)key
{
    if (field != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:field forKey:key];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Notifications
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)receiveNotification:(NSNotification*)note{
    UIAlertView* noteView = [[UIAlertView alloc] initWithTitle:nil message:@"regView recieve Success Note" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [noteView show];
//    [self performSegueWithIdentifier:@"successfulLogin" sender:self];
    //    [noteView release];
}


@end
