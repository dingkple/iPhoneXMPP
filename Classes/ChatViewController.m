//
//  ChatViewController.m
//  iPhoneXMPP
//
//  Created by 高 欣 on 13-5-27.
//  Modified by King kz on 13-7-1
//

#import "ChatViewController.h"
#import "DDXML.h"
#import "iPhoneXMPPAppDelegate.h"
#import "XMPPMessage.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "ECUSTMessageVC.h"
#import "ECUSTsearchAllUsersVC.h"
#import "ECUSTTextInputVC.h"
#import "HYZBadgeView.h"
#import "ECUSTNotReadCell.h"
#import "JSBadgeView.h"
#import "myFileViewController.h"
#import "WalaNewMsgVC.h"

#define kDidReceiveChat @"didReceiveChat"

@interface ChatViewController (){
    iPhoneXMPPAppDelegate *_appDelegate;
    int userInSection;
}

//@property (strong, nonatomic) int *userInSection;

@property (strong,nonatomic) NSMutableDictionary *dicAccessoryView;
@property (strong, nonatomic) XMPPMessageArchivingCoreDataStorage *xmppMsgStorage;
@property (strong, nonatomic) XMPPJID *previousJid;
//@property (strong, nonatomic) NSFetchedResultsController *fetchedMessageController;
@end

@implementation ChatViewController


- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - Initialization
- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    return [UIButton defaultSendButton];
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
	// Do any additional setup after loading the view.
    _appDelegate=(iPhoneXMPPAppDelegate*)[UIApplication sharedApplication].delegate;
    //self.arrayChats=_appDelegate.arrayChats;
    self.arrayChats = [[NSMutableArray alloc]init];
    self.delegate = self;
    self.dataSource = self;
    self.inputView.textView.delegate = self;
    [[self navigationController] setNavigationBarHidden:NO];
    self.xmppMsgStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveChatInputText:) name:@"newInputText" object:nil];

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self readChatFromFetchController];
    [self.tableView reloadData];
    [self.xmppMsgStorage updateContactWithJID:self.chatUserJid andSetMessageNotReadZero:YES streamBareJid:[self appDelegate].xmppStream.myJID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChat:) name:kDidReceiveChat object:nil];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[[self fetchedMessageResultsController]fetchedObjects]count]-1 inSection:0];
//    if ([indexPath row]>0) {
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom  animated:YES];
//    }
    [super scrollToBottomAnimated:YES];
    
    UILabel *labelJid = (UILabel *)[self.view viewWithTag:2003];
    labelJid.text = self.chatUserJid.bare;
    
    //notReadTable hidden = YES:
    self.notReadTableView.hidden = YES;
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDidReceiveChat object:nil];
    
}



- (void) recieveChatInputText:(NSNotification *)note{
    if([note.name isEqualToString:@"newInputText"]){
        NSString *inputText = [[note userInfo] objectForKey:@"MessageBody"];
        [self sendPressedwithText:inputText];
    }
    
}

-(void)backToTable{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) receiveChat:(NSNotification *)sender
{
    NSMutableDictionary *userInfo = sender.userInfo;
    XMPPMessage *newMsg = [userInfo objectForKey:@"message"];
    if([newMsg.from.bare isEqualToString:[self appDelegate].xmppStream.myJID.bare]){
        [self.tableView reloadData];
        [self readChatFromFetchController];
        [self.xmppMsgStorage updateContactWithJID:self.chatUserJid andSetMessageNotReadZero:YES streamBareJid:[self appDelegate].xmppStream.myJID];
        [super scrollToBottomAnimated:YES];
    }
    else {
        
    }
    
    [self.notReadTableView reloadData];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
       [self.tableView reloadData];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_appDelegate.arrayChats.count-1 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom  animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    int num = [[[self fetchedMessageResultsController] fetchedObjects]count];
    if(tableView == self.tableView){
        return [self.arrayChats count];
    }
    else {
        return [[[self fetchedContactResultsController]fetchedObjects]count];
    }
//    return num;
    
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *cleaerBkg = [[UIView alloc]init];
    cleaerBkg.backgroundColor = [UIColor clearColor];
    return cleaerBkg;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.notReadTableView){
        [self.arrayChats removeAllObjects];
        XMPPMessageArchiving_Contact_CoreDataObject *contact = [[[self fetchedContactController] fetchedObjects] objectAtIndex:[indexPath row]];
        [self.xmppMsgStorage updateContactWithJID:contact.bareJid andSetMessageNotReadZero:YES streamBareJid:[self appDelegate].xmppStream.myJID];
        self.chatUserJid = contact.bareJid;
        [self fetchedMessageResultsController];
//        [self.view setNeedsDisplay];
        self.notReadTableView.hidden = YES;
        [self readChatFromFetchController];
        [self.tableView reloadData];
        [self.notReadTableView reloadData];
        [self scrollToBottomAnimated:YES];
    }
}




#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    NSString *messageStr = text;
    
    if([messageStr length] > 0)
    {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];
        NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
        NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应

        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:[self.chatUserJid full]];
        [message addChild:body];
        [_appDelegate.arrayChats addObject:message];
        [self.arrayChats addObject:message];
       
        XMPPMessage *newmsg = [[XMPPMessage alloc] initWithType:@"chat" to:self.chatUserJid];
        [newmsg addBody:messageStr];
        [_appDelegate.xmppStream sendElement:newmsg];
        [self.xmppMsgStorage archiveMessage:newmsg outgoing:YES xmppStream:[_appDelegate xmppStream]];
//        [[_appDelegate xmppStream] sendMessage:newmsg withTag:interval];
        self.inputView.textView.text=@"";
        [self.inputView adjustTextViewHeightBy:0];
        [self.tableView reloadData];
        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_appDelegate.arrayChats.count-1 inSection:0];
//        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom  animated:NO];
    }
}

- (void)sendPressedwithText:(NSString *)text
{
    NSString *messageStr = text;
    
    if([messageStr length] > 0)
    {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];
        NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
        NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应
        
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:[self.chatUserJid full]];
        [message addChild:body];
//        [_appDelegate.arrayChats addObject:message];
//        if(![self.arrayChats containsObject:message]){
//            [self.arrayChats addObject:message];
//        }
        
//        send sound message:
//        ***********************
//        <message from="rios@127.0.0.1/ios" type="chat" to="vios@127.0.0.1" id="sound">
//        <body>sound file name here</body>
//        </message>
//        XMPPMessage *newmsg = [[XMPPMessage alloc] initWithType:@"chat" to:self.chatUserJid elementID:@"sound"];
        
        
        
        XMPPMessage *newmsg = [[XMPPMessage alloc] initWithType:@"chat" to:self.chatUserJid elementID:@"sound"];
        [newmsg addBody:messageStr];
        [_appDelegate.xmppStream sendElement:newmsg];
        [self.xmppMsgStorage archiveMessage:newmsg outgoing:YES xmppStream:[_appDelegate xmppStream]];
        //        [[_appDelegate xmppStream] sendMessage:newmsg withTag:interval];
//        self.inputView.textView.text=@"";
//        [self.inputView adjustTextViewHeightBy:0];
        [self readChatFromFetchController];
        [self.tableView reloadData];
        
        
    }
}



- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *message=[self.arrayChats objectAtIndex:indexPath.row];
    if(message.isOutgoing){
        return JSBubbleMessageStyleOutgoingDefault;
    }
    else {
        return JSBubbleMessageStyleIncomingDefault;
    }
}

- (JSMessagesViewTimestampPolicy)timestampPolicyForMessagesView
{
    return JSMessagesViewTimestampPolicyAll;
}

- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // custom implementation here, if using `JSMessagesViewTimestampPolicyCustom`
    return [self shouldHaveTimestampForRowAtIndexPath:indexPath];
}

#pragma mark - Messages view data source
- (NSFetchedResultsController *) fetchedMessageResultsController
{
	if (fetchedMessageController == nil || (self.previousJid == nil || self.previousJid != self.chatUserJid))
	{
		NSManagedObjectContext *moc = [_appDelegate managedObjectContext_message];
		
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
		                                          inManagedObjectContext:moc];
		
//        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"bareJidStr" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
		
        //		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSString *predicateFrmt = @"bareJidStr == %@";
        NSPredicate *predicateJID = [NSPredicate predicateWithFormat:predicateFrmt,self.chatUserJid.bare];
        [fetchRequest setPredicate:predicateJID];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:100];
        fetchedMessageController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:@"bareJidStr"		                                                                          cacheName:nil];
		[fetchedMessageController setDelegate:self];
        //        [fetchedResultsController]
		
		NSError *error = nil;
		if (![fetchedMessageController performFetch:&error])
		{
            //			DDLogError(@"Error performing fetch: %@", error);
		}
        self.previousJid = self.chatUserJid;
        
	}
    
	return fetchedMessageController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    NSMutableArray *chatMutableArray = [[NSMutableArray alloc]initWithArray:[[self fetchedMessageResultsController] sections]];
//    NSInteger *chatArrayNum = [chatMutableArray count];
//    for(int sectionIndex = 0 ; sectionIndex < chatArrayNum; sectionIndex++){
//        id<NSFetchedResultsSectionInfo> sectionInfo = [chatMutableArray objectAtIndex:sectionIndex];
//        if([[sectionInfo name] isEqualToString: [self.chatUserJid bare]]){
//            for(int rowIndex=0; rowIndex < [sectionInfo numberOfObjects]; rowIndex ++){
//                NSIndexPath *index = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
//                XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedMessageResultsController] objectAtIndexPath:index];
//                [self.arrayChats addObject:message];
//            }
//        }
//    }
    
    [self readChatFromFetchController];
	[self.tableView reloadData];
    [self.notReadTableView reloadData];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[[self fetchedMessageResultsController]fetchedObjects]count]-1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom  animated:NO];
}

-(void) readChatFromFetchController{
//    NSMutableArray *chatMutableArray = [[NSMutableArray alloc]initWithArray:[[self fetchedMessageResultsController] sections]];
//    int num = [[[self fetchedMessageResultsController] fetchedObjects ] count];
//    NSInteger chatArrayNum = [chatMutableArray count];
//    for(int sectionIndex = 0 ; sectionIndex < chatArrayNum; sectionIndex++){
//        id<NSFetchedResultsSectionInfo> sectionInfo = [chatMutableArray objectAtIndex:sectionIndex];
//        if([[sectionInfo name] isEqualToString: [self.chatUserJid bare]]){
//            self->userInSection = sectionIndex;
//            int rows = [sectionInfo numberOfObjects];
//            for(int rowIndex=0; rowIndex < [sectionInfo numberOfObjects]; rowIndex ++){
//                NSIndexPath *index = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
//                XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedMessageResultsController] objectAtIndexPath:index];
////                NSString *jidstr = [[NSString alloc] initWithString:message.bareJidStr];
////                NSString *msg = [[NSString alloc]initWithString:message.body];
////                BOOL isOut = message.isOutgoing;
//                if(![self.arrayChats containsObject:message]){
//                    [self.arrayChats addObject:message];
//                }
//                
//            }
//        }
//    }
    [self.arrayChats removeAllObjects];
    for(XMPPMessageArchiving_Message_CoreDataObject *msg in [[self fetchedMessageResultsController]fetchedObjects]){
        if(![self.arrayChats containsObject:msg]){
            [self.arrayChats addObject:msg];
        }
    }
//    [self scrollToBottomAnimated:YES];
//    [self scrollToBottomAnimated:YES];
    self.labelUserJid.text = self.chatUserJid.user;
}


- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [[[self fetchedMessageResultsController]fetchedObjects]count];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}



- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSXMLElement *message=[_appDelegate.arrayChats objectAtIndex:indexPath.row];
//    NSString *body = [[message elementForName:@"body"] stringValue];
//    NSInteger row = [indexPath row];
//    NSInteger section = [indexPath section];
    
    XMPPMessageArchiving_Message_CoreDataObject *message = [self.arrayChats objectAtIndex:[indexPath row]];
    return [XMPPMessageArchiving_Message_CoreDataObject getMessageStringFromMessageBody:message];
    //return [self.messages objectAtIndex:indexPath.row];
}


- (NSString *)imagenameForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPMessageArchiving_Message_CoreDataObject *message = [self.arrayChats objectAtIndex:[indexPath row]];
    NSString *imageNamStr = [XMPPMessageArchiving_Message_CoreDataObject getImageStringFromMessageBody:message];
    if(!imageNamStr){
        imageNamStr = @"019-0001";
    }
    return imageNamStr;
}


//change from applegate.array to self.array 
- (UIImage *)photoForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSXMLElement *message=[_appDelegate.arrayChats objectAtIndex:indexPath.row];
//    if([[message attributeStringValueForName:@"to"] isEqualToString:[self.chatUserJid full]]){
//        photoUrl=@"photo0";
//    }else{
//        photoUrl=@"photo1";
//    }
//    return photoUrl;
    
//    MDChat *chat=self.arrayChats[indexPath.row];
//    NSString *photoUrl=chat.user.avatar?chat.user.avatar:@"";
//    return photoUrl;
    //return nil;
    UIImage *image;
    NSData *photoData;
    XMPPMessageArchiving_Message_CoreDataObject *msg = [self.arrayChats objectAtIndex:[indexPath row]];
    if(msg.isOutgoing){
        photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:self.chatUserJid];
    }
    else {
        photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:msg.bareJid];
    }
    if (photoData != nil){
        image = [[UIImage alloc]initWithData:photoData];
    }
    else
        image = nil;
    return image;
}

-(UIView*) accessoryViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *key=[NSString stringWithFormat:@"%d",indexPath.row];
//    UIView *accessoryView=[self.dicAccessoryView objectForKey:key];
//    return accessoryView;
    return nil;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MDChat *chat=self.arrayChats[indexPath.row];
//    return chat.createAt;
    return nil;
}

- (void)configureNotReadCell:(ECUSTNotReadCell *)cell withIndex:(id)indexPath{
    XMPPMessageArchiving_Contact_CoreDataObject *contact = [[[self fetchedContactResultsController]fetchedObjects]objectAtIndex:[indexPath row]];
//    cell.textLabel.text = contact.notReadNum.stringValue;
//    cell.detailTextLabel.text = contact.notReadNum.stringValue;
    NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:contact.bareJid];
    
    if (photoData != nil){
//         cell.imageView.image = [UIImage imageWithData:photoData];
        [cell.photoView setImage:[UIImage imageWithData:photoData]];
        JSBadgeView *badge = [[JSBadgeView alloc]initWithParentView:cell.photoView alignment:JSBadgeViewAlignmentTopRight];
        badge.badgeText = contact.notReadNum.stringValue;
    }
    else
        cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
}

#pragma mark - fetchContact

- (NSFetchedResultsController *) fetchedContactResultsController
{
	if (_fetchedContactController == nil)
	{
		NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_message];
		
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
		                                          inManagedObjectContext:moc];
		
        //		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"mostRecentMessageTimestamp" ascending:NO];
		
        //		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd2, nil];
        
        NSString *predicateFrmt = @"notReadNum != %d";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,0];
       

		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setPredicate:predicate];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
        //		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
        //		                                                               managedObjectContext:moc
        //		                                                                 sectionNameKeyPath:@"sectionNum"
        //		                                                                          cacheName:nil];
        _fetchedContactController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:nil		                                                                          cacheName:nil];
		[_fetchedContactController setDelegate:self];
        //        [fetchedResultsController]
		
		NSError *error = nil;
		if (![_fetchedContactController performFetch:&error])
		{
            //			DDLogError(@"Error performing fetch: %@", error);
		}
        
	}
	
	return _fetchedContactController;
}

#pragma mark - bottomButtonActions

-(void) bottomButtonSwitchClicked:(id)sender{
    
}

- (void) bottomButtonNewMsgClicked:(id)sender{
    [self performSegueWithIdentifier:@"chooseUserToChat" sender:self];
}

- (void) bottomButtonSoundInputClicked:(id)sender{
    
}

- (void) bottomButtonAttachClicked:(id)sender{
    [self performSegueWithIdentifier:@"allFiles" sender:self];
}

- (void) bottomButtonReplyClicked:(id)sender{
    [self performSegueWithIdentifier:@"inputChatTextToReply" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"chooseUserToChat"]){
        ECUSTsearchAllUsersVC *userTable = (ECUSTsearchAllUsersVC *)[segue destinationViewController];
        userTable.sourceViewController = self;
    }
    else if([segue.identifier isEqualToString: @"inputChatTextToReply"]){
        WalaNewMsgVC *chat = (WalaNewMsgVC *)[segue destinationViewController];
        chat.chatJID = self.chatUserJid;
        chat.sourceViewController = self;
    }
    else if([segue.identifier isEqualToString:@"allFiles"]){
        myFileViewController *myFileVC = (myFileViewController *)[segue destinationViewController];
        myFileVC.userJID = self.chatUserJid;
    }
}
@end
