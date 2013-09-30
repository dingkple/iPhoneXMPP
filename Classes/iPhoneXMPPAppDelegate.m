#import "iPhoneXMPPAppDelegate.h"
#import "RootViewController.h"
#import "SettingsViewController.h"

#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "TURNSocket.h"


#import <CFNetwork/CFNetwork.h>
#define kDidReceiveChat @"didReceiveChat"
#define kSuccessfulReg @"successfulReg"
#define kNewPresence @"newPresence"
#define kPresenceType @"presenceType"



//#define kXMPPmyJID @"kXMPPmyJID"
//#define kXMPPmyPassword @"kXMPPmyPassword"
//#define kSuccess

//NSString *const kXMPPmyJID = @"kXMPPmyJID";
//NSString *const kXMPPmyPassword = @"kXMPPmyPassword";

// Log levels: off, error, warn, info, verbose
#if DEBUG
  static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
  static const int ddLogLevel = LOG_LEVEL_INFO;
#endif
//NSString const *serverText = @"vg-71c9051cc725";
//NSString const *serverText = @"kingtekimacbook-pro.local";
NSString const *serverText = @"127.0.0.1";

@interface iPhoneXMPPAppDelegate()

@property(strong, nonatomic)NSMutableArray *turnSockets;

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation iPhoneXMPPAppDelegate

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;

@synthesize window;
@synthesize navigationController;
@synthesize settingsViewController;
@synthesize addBuddyController;
@synthesize loginButton;

@synthesize turnSockets = _turnSockets;


@synthesize xmppMessageStorage;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Configure logging framework
	
	[DDLog addLogger:[DDTTYLogger sharedInstance]];

  // Setup the XMPP stream
  
	[self setupStream];
    self.arrayChats=[NSMutableArray array];

	// Setup the view controllers

//	[window setRootViewController:navigationController];
//	[window makeKeyAndVisible];

	if (![self connect])
	{
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			
//			[navigationController presentViewController:settingsViewController animated:YES completion:NULL];
//            [self.myRootViewController performSegueWithIdentifier:@"successLogin" sender:self];
		});
	}
    
		
	return YES;
}

-(const NSString *)getServerText{
    return serverText;
}

- (void)dealloc
{
	[self teardownStream];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

-(NSManagedObjectContext *) managedObjectContext_message {
    return [xmppMessageStorage mainThreadManagedObjectContext];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
    isAllreadyLogin = NO;
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	// 
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.

	xmppStream = [[XMPPStream alloc] init];
	
	#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		// 
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
	#endif
	
	// Setup reconnect
	// 
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Setup roster
	// 
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
//	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	// Setup vCard support
	// 
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	// Setup capabilities
	// 
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	// 
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	// 
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];

    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    //setup Message Storage
    xmppMessageStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];

	// Activate xmpp modules

	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];

	// Add ourself as a delegate to anything we may be interested in

	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];

	// Optional:
	// 
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	// 
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	// 
	// If you don't specify a hostPort, then the default (5222) will be used.
	
// 	[xmppStream setHostName:@"talk.google.com"];
// 	[xmppStream setHostPort:5222];	
	[xmppStream setHostName:@"127.0.0.1"];
//    [xmppStream setHostName:@"119.1.109.53"];
//    [xmppStream setHostName:@"203.156.196.11"];
    //[xmppStream setHostName:@"xmpp.himaiduo.com"];
    //[xmppStream setHostName:@"172.31.20.47"];
 	[xmppStream setHostPort:5222];
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
// 
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
// 
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
// 
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}

	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];

	//
	// If you don't want to use the Settings view to set the JID, 
	// uncomment the section below to hard code a JID and password.
	// 
//	 myJID = @"user@gmail.com/xmppframework";
//	 myPassword = @"";
   // myJID = @"ios@cdn-2412b6cf3dc";
    //password = @"123";
//    myJID = @"ios@kingtekimacbook-pro.local";
//    password = @"123";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}

	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	password = myPassword;

	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting" 
		                                                    message:@"See console for error details." 
		                                                   delegate:nil 
		                                          cancelButtonTitle:@"Ok" 
		                                          otherButtonTitles:nil];
		[alertView show];

		DDLogError(@"Error connecting: %@", error);

		return NO;
	}

	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}


-(BOOL)anonymousConnect{
    NSError *err;
    NSString *tjid = [[NSString alloc] initWithFormat:@"anonymous@%@", serverText];
    [[self xmppStream] setMyJID:[XMPPJID jidWithString:tjid]];
    if ( ![self connect])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"连接服务器失败"
                                                            message:[err localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
        
    }
    return YES;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIApplicationDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationDidEnterBackground:(UIApplication *)application 
{
	// Use this method to release shared resources, save user data, invalidate timers, and store
	// enough application state information to restore your application to its current state in case
	// it is terminated later.
	// 
	// If your application supports background execution,
	// called instead of applicationWillTerminate: when the user quits.
	
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

	#if TARGET_IPHONE_SIMULATOR
	DDLogError(@"The iPhone simulator does not process background network traffic. "
			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
	#endif

	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)]) 
	{
		[application setKeepAliveTimeout:600 handler:^{
			
			DDLogVerbose(@"KeepAliveHandler");
			
			// Do other keep alive stuff here.
		}];
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application 
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket 
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
//    NSString *myPasswordforReg = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    NSString *myPasswordforReg = self.password;
    
    if(isRegister == YES){
        [[self xmppStream] registerWithPassword:myPasswordforReg error:nil];
        return ;
    }
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
//    [[self settingsViewController] performSegueWithIdentifier:@"successLogin" sender:self.settingsViewController];
    if(!isAllreadyLogin){
        isAllreadyLogin = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllreadyLogin" object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"successfulLogin" object:nil];
    }
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//    [[self settingsViewController] loginError:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"failedLogin" object:nil];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//  return NO;
    if([TURNSocket isOfferingFile:iq]){
//        [TURNSocket processOfferedFileAccepted:iq withXmppStream:self.xmppStream];
         NSMutableDictionary *note = [NSMutableDictionary dictionaryWithObject:iq forKey:@"iq"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newOfferedFile" object:self userInfo:note];
        [self startTurnSock:note];
//        NSArray *candidates = [NSArray arrayWithObjects:@"127.0.0.1",nil];
//        [TURNSocket setProxyCandidates:candidates];
//        TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[self xmppStream] incomingTURNRequest:iq];
//        if(!_turnSockets){
//            _turnSockets = [[NSMutableArray alloc]init];
//        }
//        [_turnSockets addObject:turnSocket];
//        [turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    if([TURNSocket isOfferedFileAccepted:iq]){
//         NSArray *candidates = [NSArray arrayWithObjects:@"127.0.0.1",nil];
//        [TURNSocket setProxyCandidates:candidates];
//        TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[self xmppStream] incomingTURNRequest:iq];
//        if(!_turnSockets){
//            _turnSockets = [[NSMutableArray alloc]init];
//        }
//        [_turnSockets addObject:turnSocket];
//        [turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSMutableDictionary *note = [NSMutableDictionary dictionaryWithObject:iq forKey:@"iq"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"offeredFileAccepted" object:self userInfo:note];
    }
    
//    if ([TURNSocket isNewStartTURNRequest:iq]) {
//        NSLog(@"IS NEW TURN request..");
//        NSMutableDictionary *note = [NSMutableDictionary dictionaryWithObject:iq forKey:@"iq"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"newOfferedFile" object:self userInfo:note];
////        NSArray *candidates = [NSArray arrayWithObjects:@"kingtekimacbook-pro.local",@"ios@kingtekimacbook-pro.local",nil];
////        [TURNSocket setProxyCandidates:candidates];
////        TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[self xmppStream] incomingTURNRequest:iq];
////        if(!_turnSockets){
////            _turnSockets = [[NSMutableArray alloc]init];
////        }
////        [_turnSockets addObject:turnSocket];
////        [turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    }
    
    return YES;
}

-(void)setRegister:(BOOL)yesOrNot{
    isRegister = yesOrNot;
}


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

	// A simple example of inbound message handling.

	if ([message isChatMessageWithBody])
	{
        [self.arrayChats addObject:message];
		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
		                                                         xmppStream:xmppStream
		                                               managedObjectContext:[self managedObjectContext_roster]];
        self.xmppMessageStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
		[self.xmppMessageStorage archiveMessage:message outgoing:NO xmppStream:self.xmppStream];
        [self.xmppMessageStorage updateContactWithJID:message.from andSetMessageNotReadZero:NO streamBareJid:self.xmppStream.myJID];
//		NSString *body = [[message elementForName:@"body"] stringValue];
//		NSString *displayName = [user displayName];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:message forKey:@"message"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidReceiveChat
                       object:self userInfo:userInfo];

//		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
//		{
//			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
//															  message:body 
//															 delegate:nil 
//													cancelButtonTitle:@"Ok" 
//													otherButtonTitles:nil];
//			[alertView show];
//		}
//		else
//		{
//			// We are not active, so use a local notification instead
//			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//			localNotification.alertAction = @"Ok";
//			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
//
//			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//		}
	}
}

//- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
//{
//	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
//}

//在次处理加好友
#pragma mark 收到好友上下线状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    //    DDLogVerbose(@"%@: %@ ^^^ %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //当前用户
    //    NSString *userId = [NSString stringWithFormat:@"%@", [[sender myJID] user]];
    //在线用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    NSLog(@"presenceType:%@",presenceType);
    NSLog(@"用户:%@",presenceFromUser);
    //这里再次加好友
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@",[presence from]]];
     NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithObject:jid.user forKey:@"JIDuser"];
    if ([presenceType isEqualToString:@"subscribed"]) {
        //********subscribed is NOT subscribe!!!!
//        [userinfo setObject:@"subscribe" forKey:kPresenceType];
    }
    else if([presenceType isEqualToString:@"available"]) {
        [userinfo setObject:@"available" forKey:kPresenceType];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"newPresence" object:nil];
        
    }
    else if([presenceType isEqualToString:@"unavailable"]){
        [userinfo setObject:@"unavailable" forKey:kPresenceType];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"newPresence" object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewPresence object:nil userInfo:userinfo];
   
}


//处理加好友
#pragma mark 处理加好友回调,加好友
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户kingtekimacbook-pro.local
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@@kingtekimacbook-pro.local", [[presence from] user]];
    NSLog(@"presenceType:%@",presenceType);
    
    NSLog(@"presence2:%@  sender2:%@",presence,sender);
    
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
//    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
//    NSString *filePath = [self dataFilePath];
//    if(!self.requestsForSubscribe){
//        self.requestsForSubscribe =  self.requestsForSubscribe = [[NSMutableArray alloc]init];
//    }
//    self.requestsForSubscribe = [self.requestsForSubscribe initWithContentsOfFile:filePath];
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithObject:jid.user forKey:@"JIDuser"];
    [userinfo setObject:@"subscribe" forKey:@"presenceType"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewPresence object:nil userInfo:userinfo];
//    allReq = [allReq initWithContentsOfFile:filePath];
//    self.requestsForSubscribe = allReq;
//    [self.requestsForSubscribe addObject: jid.user];
//    [self saveSubscribePresence];

   
}

- (void) saveSubscribePresence{
    
    NSString *filePath = [self dataFilePath];
    [self.requestsForSubscribe writeToFile:filePath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewPresence object:nil];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    registerSuccess = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSuccessfulReg object:nil];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建帐号成功,请用新帐号重新登录"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    [self disconnect];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建帐号失败"
                                                        message:@"用户名冲突"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    [self disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body 
		                                                   delegate:nil 
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	} 
	else 
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark DataPersistence
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"subscribeRequest.plist"];
}



-(void) startTurnSock:(NSMutableDictionary *)note{
    XMPPIQ *iq = [note objectForKey:@"iq"];
    NSArray *candidates = [NSArray arrayWithObjects:@"127.0.0.1",nil];
    [TURNSocket setProxyCandidates:candidates];
    TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[self xmppStream] incomingTURNRequest:iq];
    if(!_turnSockets){
        _turnSockets = [[NSMutableArray alloc]init];
    }
    [_turnSockets addObject:turnSocket];
    [turnSocket processOfferingFile:iq];
    [turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket {
    
    //    NSData *dataF = [[NSData alloc] initWithContentsOfFile:
    //                     [[NSBundle mainBundle] pathForResource:@"a1" ofType:@"png"]];
    //
    //    [socket writeData:dataF withTimeout:60.0f tag:0];
    //    NSString *path = [[NSBundle mainBundle] bundlePath];
    //    NSString *name = [NSString stringWithFormat:@"buddy.png"];
    //    NSString *finalPath = [path stringByAppendingPathComponent:name];
    //    NSData *fileData = [NSData dataWithContentsOfFile: finalPath];
    if(sender.isClient){
        [socket writeData:sender.fileData withTimeout:10000 tag:0];
    }
    else{
        //        NSMutableData *buffer = [[NSMutableData alloc]init];
        //        NSMutableString *filePath = [self dataFilePath];
        //        [filePath appendString:sender.fileName];
        //        [socket readDataWithTimeout:-1 buffer:sender.fileData bufferOffset:_offSet tag:SOCKS_ACCEPT_FILE];
        ////        [socket re]
        //        _offSet = sender.fileData.length+1;
        [socket readDataToLength:sender.fileSize withTimeout:-1 tag:0];
        //        [buffer writeToFile:filePath atomically:YES];
    }
    
    
}

- (void)turnSocketDidRecieveFile: (TURNSocket *)sender{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory = [[NSMutableString alloc]initWithString:[[paths objectAtIndex:0] description]];
    [documentsDirectory appendString:@"/"];
    [documentsDirectory appendString:sender.fileName];
    [sender.fileData writeToFile:documentsDirectory atomically:YES];
}



- (void)turnSocketDidFail:(TURNSocket *)sender{
    
}




@end
