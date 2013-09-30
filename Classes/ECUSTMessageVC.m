//
//  ECUSTMessageVC.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-9.
//
//

#import "ECUSTMessageVC.h"
#import "DDLog.h"
#import "iPhoneXMPPAppDelegate.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "ChatViewController.h"
#import "ECUSTbuddyMessageInfoCell.h"
#import "JSBadgeView.h"
#import "XMPPMessage.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"

#define kDidReceiveChat @"didReceiveChat"
@interface ECUSTMessageVC (){
    iPhoneXMPPAppDelegate *_appDelegate;
}

@property (strong, nonatomic) XMPPMessageArchivingCoreDataStorage *xmppMsgStorage;
@property (strong, nonatomic) UITableView *messageTableView;
@property (strong, nonatomic) UISearchBar *searchMessageBar;
@property (strong, nonatomic) UISearchDisplayController *messageSearchControl;
@property (strong, nonatomic) XMPPMessageArchiving_Contact_CoreDataObject *selectedUser;
//@property (strong, nonatomic) NSFetchedPropertyDescription *fetchedResultsController;


@end

@implementation ECUSTMessageVC

- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)awakeFromNib{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"动画聊天" image:nil tag:2];
    [item setFinishedSelectedImage:[UIImage imageNamed:@"BottomActionbarIcon2_2"]
       withFinishedUnselectedImage:[UIImage imageNamed:@"BottomActionbarIcon2_1"]];
    
    self.tabBarItem = item;
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
    _appDelegate = [self appDelegate];
    self.xmppMsgStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    
   

    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setupView];
    [self.messageTableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChat) name:kDidReceiveChat object:self];


}

-(void) receiveChat
{
    [self.messageTableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSFetchedResultsController *) fetchedContactResultsController
{
	if (fetchedContactController == nil)
	{
		NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_message];
		
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
		                                          inManagedObjectContext:moc];
		
        //		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"mostRecentMessageTimestamp" ascending:NO];
		
        //		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
        //		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
        //		                                                               managedObjectContext:moc
        //		                                                                 sectionNameKeyPath:@"sectionNum"
        //		                                                                          cacheName:nil];
        fetchedContactController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:nil		                                                                          cacheName:nil];
		[fetchedContactController setDelegate:self];
        //        [fetchedResultsController]
		
		NSError *error = nil;
		if (![fetchedContactController performFetch:&error])
		{
            //			DDLogError(@"Error performing fetch: %@", error);
		}
        
	}
	
	return fetchedContactController;
}


- (NSFetchedResultsController *) fetchedMessageResultsController
{
	if (fetchedMessageController == nil)
	{
		NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_message];
		
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
		                                          inManagedObjectContext:moc];
		
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSString *predicateFrmt = @"bareJidStr == %@";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,self.selectedUser.bareJidStr];
        [fetchRequest setPredicate:predicate];
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
        
	}
	return fetchedMessageController;
}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
	[self.messageTableView reloadData];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark BasicViews
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)setupView{
    
    
//    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 390, 40)];
//    searchBarView.backgroundColor = [UIColor clearColor];
//    self.searchMessageBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 390, 40)];
//    self.searchMessageBar.delegate = self;
//    self.searchMessageBar.barStyle = UIBarStyleBlackTranslucent;
//    self.searchMessageBar.autocorrectionType = UITextAutocapitalizationTypeNone;
//    self.searchMessageBar.placeholder = @"search";
//    self.searchMessageBar.keyboardType = UIKeyboardTypeDefault;
//    self.searchMessageBar.showsCancelButton = NO;
//    //    [self.searchBuddyBar sizeToFit];
////    UIView *searchBarBkg = [self.searchMessageBar.subviews objectAtIndex:0];
////    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar.png"]];
//    [searchBarView addSubview:self.searchMessageBar];
////    [searchBarBkg addSubview:bgImg];
//    [self.view addSubview:searchBarView];
    UIImageView *frameBKG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 480, 295)];
    frameBKG.image = [UIImage imageNamed:@"bkg_Mes_Contact"];
    [self.view addSubview:frameBKG];
    
    UIImageView *topCover = [[UIImageView alloc]initWithFrame:CGRectMake(13, 0, 453, 58)];
    topCover.image = [UIImage imageNamed:@"topCover_Mes_Contact"];
    [self.view addSubview:topCover];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ViewBKG_Mes_Contact"]]];
    
    
    
    
    
    self.messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(25, 58, 451, 295-58) style:UITableViewStylePlain];
    self.messageTableView.backgroundColor = [UIColor whiteColor];
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.tag = 201;
    [self.messageTableView setRowHeight:50];
    [self.messageTableView setBackgroundColor:[UIColor clearColor]];
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.messageTableView];
    
    
    self.messageTableView.tableHeaderView = self.searchMessageBar;
    self.messageSearchControl = [[UISearchDisplayController alloc] initWithSearchBar:self.searchMessageBar contentsController:self];
    //    self.searchDisplayCrl.searchBar.autoresizesSubviews = NO;
    self.messageSearchControl.delegate = self;
    self.messageSearchControl.searchResultsDataSource = self;
    self.messageSearchControl.searchResultsDelegate = self;
    
}



- (void)showTabBar

{
//    if (self.tabBarController.tabBar.hidden == NO)
//    {
//        return;
//    }
//    UIView *contentView;
//    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
//        
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    
//    else
//        
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
//    self.tabBarController.tabBar.hidden = NO;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if editingStyle == UITableViewCellEditingStyleDelete
    //that means to delete all the messages sent from or to JID
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.selectedUser = [[self fetchedContactResultsController] objectAtIndexPath:indexPath];
        BOOL isOutgoing;
        for(XMPPMessageArchiving_Message_CoreDataObject *msgToDelete in [[self fetchedMessageResultsController] fetchedObjects]){
            isOutgoing = msgToDelete.isOutgoing;
            [self.xmppMsgStorage deleteAllMessage:msgToDelete.bareJid outgoing:msgToDelete.isOutgoing xmppStream:[_appDelegate xmppStream]];
        }
        [self fetchedMessageResultsController];

    [self.xmppMsgStorage deleteAllMessage:self.selectedUser.bareJid outgoing:isOutgoing xmppStream:[_appDelegate xmppStream]];


        

//        NSMutableArray *messageSectionArr = [[NSMutableArray alloc]initWithArray:[[self fetchedMessageResultsController]sections]];
//        NSMutableArray *contactSectionArr = [[NSMutableArray alloc]initWithArray:[[self fetchedContactResultsController]sections]];
//        NSInteger messageSectionNum = [[[self fetchedMessageResultsController] sections]count];
//        NSInteger contactSectionNum = [[[self fetchedContactResultsController] sections]count];
//        XMPPMessageArchiving_Contact_CoreDataObject *contact = [[self fetchedContactResultsController] objectAtIndexPath:indexPath];
//        NSString *jidToDelete = contact.bareJidStr;
//        int sectionIndex=0;
//        for(;sectionIndex<messageSectionNum;sectionIndex++){
//            //        rows = sectionsArr[j].
//            id <NSFetchedResultsSectionInfo> sectionInfo = [messageSectionArr objectAtIndex:sectionIndex];
//            NSString *sectionName = [[NSString alloc] initWithString:[sectionInfo name]];
//            if([[sectionInfo name] isEqualToString:jidToDelete]){
//                int rows = [sectionInfo numberOfObjects];
//                for(int rowIndex = 0 ;rowIndex < rows; rowIndex ++){
//                    NSIndexPath *msgIndex = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
//                    XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedMessageResultsController] objectAtIndexPath:msgIndex];
//                    XMPPJID *jid = message.bareJid;
//                    BOOL isOutgoing = message.isOutgoing;
//                    [self.xmppMsgStorage deleteAllMessage:message.bareJid outgoing:message.isOutgoing xmppStream:[_appDelegate xmppStream]];
////                    [self.xmppMsgStorage deleteAllMessage:message.bareJid outgoing:NO xmppStream:[_appDelegate xmppStream]];
//                }
//                break;
//            }
//            
//        }
        
//        if(sectionIndex == messageSectionNum){
//            XMPPJID *jid = [XMPPJID jidWithString:jidToDelete];
//            BOOL isOutgoing = YES;
//            [self.xmppMsgStorage deleteAllMessage:jid outgoing:isOutgoing xmppStream:[_appDelegate xmppStream]];
//        }
//        [[self xmppMsgStorage]deleteContact:contact];

    }
    [tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return [[[self fetchedContactResultsController] sections] count];
    return 1;
}

- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)section
{

//    NSArray *sections = [[self fetchedContactResultsController] sections];
//    
//    if (section < [sections count])
//    {
//        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
//        //
//        //            int section = [sectionInfo.name intValue];
//        //            switch (section)
//        //            {
//        //                case 0  : return @"Available";
//        //                case 1  : return @"Away";
//        //                default : return @"Offline";
//        //            }
//        return [sectionInfo name];
//    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
//    NSArray *sections = [[self fetchedContactResultsController] sections];
//    NSInteger returnNumber = 0;
//    if (sectionIndex < [sections count])
//    {
//        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
//        returnNumber =  sectionInfo.numberOfObjects;
//    }
//    return returnNumber;
    return [[[self fetchedContactResultsController]fetchedObjects]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    ECUSTbuddyMessageInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ECUSTbuddyMessageInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    XMPPMessageArchiving_Contact_CoreDataObject *contact = [[self fetchedContactResultsController]objectAtIndexPath:indexPath];
    
//    cell.textLabel.text = message.mostRecentMessageBody;
//    cell.detailTextLabel.text = message.bareJidStr;
    NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:contact.bareJid];
    if (photoData != nil)
        [cell setPhoto: [UIImage imageWithData:photoData]];
    else
//        cell.userPhotoView.image = [UIImage imageNamed:@"defaultPerson"];
        [cell setPhoto:[UIImage imageNamed:@"userPhotoSample_Mes_Contact"]];
    cell.authoLabel.text = contact.bareJid.user;
    cell.messageLabel.text = [XMPPMessageArchiving_Contact_CoreDataObject getMessageStringFromContactBody:contact];
    NSNumber *num = [NSNumber numberWithInteger:contact.notReadNum.integerValue];
    if (num.integerValue > 0 ) {
        NSString *stringOfNum = [[NSString alloc] initWithString: [num stringValue]];
        cell.messageNotReadLabel.text = @"";
        JSBadgeView *badge = [[JSBadgeView alloc]initWithParentView:cell.anchor alignment:JSBadgeViewAlignmentCenterLeft];
        badge.badgeText = stringOfNum;
        badge.badgeTextFont = [UIFont fontWithName:@"Helvetica" size:14.0];
        [cell.anchor addSubview:badge];
    }
    else cell.messageNotReadLabel.text = @"";
    cell.msgTimeLabel.text = contact.mostRecentMessageTimestamp.description;
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"messageItemBKG_Mes_Con"]];

    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XMPPMessageArchiving_Contact_CoreDataObject *contact = [[self fetchedContactResultsController] objectAtIndexPath:indexPath];
    self.selectedUser = contact;
    [self performSegueWithIdentifier:@"chatFromMessagelist" sender:self];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 58;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *cleaerBkg = [[UIView alloc]init];
    cleaerBkg.backgroundColor = [UIColor clearColor];
    return cleaerBkg;
}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//
//    return 
//    
//    
//}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"chatFromMessagelist"]){
        if([segue.destinationViewController isKindOfClass:[ChatViewController class]] ){
            ChatViewController *chatVC = (ChatViewController *)segue.destinationViewController;
            XMPPJID *jid = [XMPPJID jidWithString: [self.selectedUser bareJidStr]];
            chatVC.chatUserJid = jid;
        }
    }
}



@end
