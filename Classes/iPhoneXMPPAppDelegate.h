#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ECUSTmyRootViewController.h"
#import "ECUSTServerInfo.h"

#import "XMPPFramework.h"

@class SettingsViewController;
@class addBuddyViewController;
extern NSString const *serverText;
//UIResponder <UIApplicationDelegate>

@interface iPhoneXMPPAppDelegate : UIResponder <UIApplicationDelegate, XMPPRosterDelegate>
{
	XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    NSString const *serverText;
    
    XMPPMessageArchivingCoreDataStorage *xmppMessageStorage;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
    BOOL isRegister;
    BOOL registerSuccess;
	BOOL isAllreadyLogin;
    
	UIWindow *window;
	UINavigationController *navigationController;
    ECUSTmyRootViewController *myRootViewController;
    SettingsViewController *loginViewController;
    addBuddyViewController *addNewBuddyController;
    UIBarButtonItem *loginButton;
    
    NSString *password;
}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;


//From the previous coder, array to hold the messages, now in the chatViewController;
@property (strong,nonatomic) NSMutableArray *arrayChats;

//array to hold the Not-Read messages, obj is contact
@property (strong, nonatomic) NSMutableArray *arrayNotReadMessage;


@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) IBOutlet SettingsViewController *settingsViewController;
@property (nonatomic, strong) IBOutlet addBuddyViewController *addBuddyController;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *loginButton;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSMutableArray *subscribeRequests;
////////////////////////////////////////////////////////////////////////////////////
@property (nonatomic, strong) NSMutableArray *requestsForSubscribe;
@property (strong, nonatomic)  ECUSTmyRootViewController *myRootViewController;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageStorage;



- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (NSManagedObjectContext *) managedObjectContext_message;

- (BOOL)connect;
- (void)disconnect;
- (void) setRegister:(BOOL)yesOrNot;
- (BOOL)anonymousConnect;
-(const NSString *)getServerText;
- (void) saveSubscribePresence;
- (NSString *)dataFilePath;

@end
