//
//  ECUSTmyBuddylistViewController.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-30.
//
//

#import "ECUSTmyBuddylistViewController.h"
#import "iPhoneXMPPAppDelegate.h"
#import "ChatViewController.h"
#import "XMPPFramework.h"
#import "DDLog.h"
#import "InfoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MJPopupBackgroundView.h"
#import "MJDetailViewController.h"
#import "KxMenu.h"
#import "UIViewController+MJPopupViewController.h"

#define kPopupModalAnimationDuration 0.35
#define kMJSourceViewTag 23941
#define kMJPopupViewTag 23942
#define kMJBackgroundViewTag 23943
#define kMJOverlayViewTag 23945

#define kServername @"127.0.0.1"



// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface ECUSTmyBuddylistViewController (){
    MJDetailViewController *detailViewController;
}

@property (strong, nonatomic) InfoCell *cell;

@property (strong, nonatomic) NSArray *arrayOfCharacters;
@property (strong, nonatomic) UISearchDisplayController *searchDisplayCrl;
@property (strong, nonatomic) NSMutableArray *searchResultArray;
@property (strong, nonatomic) XMPPUserCoreDataStorageObject *selectedUser;
@property (nonatomic) BOOL isNewRequestExists;
-(void) savedSubscription;

@end


@implementation ECUSTmyBuddylistViewController
//@synthesize arrayOfCharacters;

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
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"newSubscription" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"didSelectRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"newPresence" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self.requestTableview selector:@selector(receiveNotification:) name:@"savedSubscription" object:nil];
	// Do any additional setup after loading the view.
    if(!self.allRequestsArray){
        self.allRequestsArray = [[NSMutableArray alloc]init];
    }
    _arrayOfCharacters = [[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    _isNewRequestExists = NO;
    [self showTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void) setupView{
    const CGFloat W = self.view.bounds.size.width;
    const CGFloat H = self.view.bounds.size.height;
    UIButton *addNewButton;
    UIButton *backToLogin;
    
    backToLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backToLogin.frame = CGRectMake(6, 10, 40, 30);
    backToLogin.tag = 101;
    [backToLogin setTitle:@"back" forState:UIControlStateNormal];
    [backToLogin addTarget:self action:@selector(disconnect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToLogin];
    
    addNewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addNewButton.frame = CGRectMake(W-40, 10, 40, 30);
    addNewButton.tag = 102;
    [addNewButton setTitle:@"new" forState:UIControlStateNormal];
    [addNewButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addNewButton];
    
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 386, 40)];
    searchBarView.backgroundColor = [UIColor clearColor];
    self.searchBuddyBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 386, 40)];
    self.searchBuddyBar.delegate = self;
    self.searchBuddyBar.barStyle = UIBarStyleBlackTranslucent;
    self.searchBuddyBar.autocorrectionType = UITextAutocapitalizationTypeNone;
    self.searchBuddyBar.placeholder = @"search";
    self.searchBuddyBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBuddyBar.showsCancelButton = NO;
        
    UIView *searchBarBkg = [self.searchBuddyBar.subviews objectAtIndex:0];
    [searchBarView addSubview:self.searchBuddyBar];
    searchBarBkg.bounds = searchBarBkg.frame;
    [self.view addSubview:searchBarView];
    
    [self showTableViews];
    
    self.searchDisplayCrl = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBuddyBar contentsController:self];
    self.searchDisplayCrl.delegate = self;
    self.searchDisplayCrl.searchResultsDataSource = self;
    self.searchDisplayCrl.searchResultsDelegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setupView];
    [self.requestTableview reloadData];
    [self.buddyTableView reloadData];
}

- (void)showRequestTableAndAdjustView{
    //if one or two of the table is nil, then alloc them
    if (!self.requestTableview || !self.buddyTableView) {
        self.requestTableview = [[UITableView alloc] initWithFrame:CGRectMake(50, 40, 386, 80) style:UITableViewStylePlain];
        self.requestTableview.backgroundColor = [UIColor whiteColor];
        self.requestTableview.delegate = self;
        self.requestTableview.dataSource = self;
        self.requestTableview.tag = 201;
        [self.requestTableview setRowHeight:50];
        self.requestTableview.bounces = NO;
        self.requestTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.requestTableview.hidden = NO;
        [self.view addSubview:self.requestTableview];
        
        if(!self.buddyTableView){
            self.buddyTableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 124, 386, 128) style:UITableViewStylePlain];
            self.buddyTableView.backgroundColor = [UIColor whiteColor];
            self.buddyTableView.delegate = self;
            self.buddyTableView.dataSource = self;
            self.buddyTableView.tag = 202;
            [self.buddyTableView setRowHeight:50];
            [self.view addSubview:self.buddyTableView];
        }
    }
    else {
        //reset the TableViews' frame
        self.buddyTableView.frame = CGRectMake(50, 124, 386, 128);
        self.requestTableview.hidden = NO;
    }

}

- (void) hideRequestViewAndAdjustView{
    if (!self.requestTableview || !self.buddyTableView) {
        self.requestTableview = [[UITableView alloc] initWithFrame:CGRectMake(50, 40, 386, 80) style:UITableViewStylePlain];
        self.requestTableview.backgroundColor = [UIColor whiteColor];
        self.requestTableview.delegate = self;
        self.requestTableview.dataSource = self;
        self.requestTableview.tag = 201;
        [self.requestTableview setRowHeight:50];
        self.requestTableview.bounces = NO;
        self.requestTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.requestTableview.hidden = NO;
        [self.view addSubview:self.requestTableview];
        
        if(!self.buddyTableView){
            self.buddyTableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 124, 386, 208) style:UITableViewStylePlain];
            self.buddyTableView.backgroundColor = [UIColor whiteColor];
            self.buddyTableView.delegate = self;
            self.buddyTableView.dataSource = self;
            self.buddyTableView.tag = 202;
            [self.buddyTableView setRowHeight:50];
            [self.view addSubview:self.buddyTableView];
        }
    }

    //only need to reset the buddyTable's frame, the requestTable could be nil
    self.requestTableview.hidden = YES;
    self.buddyTableView.frame = CGRectMake(50, 40, 386, 208);
}

- (void) showTableViews {
    if([self.allRequestsArray count]>0 ){
        _isNewRequestExists = YES;
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self showRequestTableAndAdjustView];
                         }
                         completion:^(BOOL finished){
                             
                         }];

    }
    else if ([self.allRequestsArray count]==0) {
        _isNewRequestExists = NO;
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self hideRequestViewAndAdjustView];
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}


-(void)receiveNotification:(NSNotification*)note{
    
    if([note.name isEqualToString:@"newPresence"]){
        NSString *preType = [[note userInfo] objectForKey:@"presenceType"];
        if([preType isEqualToString:@"subscribe"]){
            NSString *newJID = [[note userInfo]objectForKey:@"JIDuser"];
            if(![self.allRequestsArray containsObject:newJID]){
                [self.allRequestsArray addObject:newJID];
                [self.allRequestsArray writeToFile:[[self appDelegate]dataFilePath]  atomically:YES];
            }
            [self showTableViews];
            [self.requestTableview reloadData];
        }
        else if([preType isEqualToString:@"available"]){
        }
        else if([preType isEqualToString:@"unavailable"]){
            
        }
    }
       
    else if([note.name isEqualToString:@"didSelectRequest"]){
        
        NSString *bareJid = [[note userInfo] objectForKey:@"JID"];
        detailViewController = [[MJDetailViewController alloc]initWithNibName:@"MJDetailViewController" bundle:nil];
        detailViewController = [detailViewController init];

        detailViewController.jidText = [[NSMutableString alloc]init];
        UILabel *userLabel =(UILabel *)[detailViewController.view viewWithTag:101];
        userLabel.text = bareJid;
        UIButton *accept = (UIButton *)[detailViewController.view viewWithTag:106];
        [accept addTarget:self action:@selector(acceptBuddyRequest:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *reject = (UIButton *)[detailViewController.view viewWithTag:107];
        [reject addTarget:self action:@selector(rejectPresenceSubscriptionRequestFrom:) forControlEvents:UIControlEventTouchUpInside];
        [self presentPopupViewController:detailViewController animationType:MJPopupViewAnimationFade];
    }
    else {
        [self.buddyTableView reloadData];
    }
}




- (NSFetchedResultsController *) fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
		NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_roster];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
		                                          inManagedObjectContext:moc];
		
//		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		
//		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:@"sectionName"
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
		
		
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
			DDLogError(@"Error performing fetch: %@", error);
		}
        
	}
	
	return fetchedResultsController;
}




- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
	[self.buddyTableView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewCell helpers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
	// Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
	// We only need to ask the avatar module for a photo, if the roster doesn't have it.
	
	if (user.photo != nil)
	{
		cell.imageView.image = user.photo;
	}
	else
	{
		NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
		if (photoData != nil)
			cell.imageView.image = [UIImage imageWithData:photoData];
		else
			cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if(tableView == self.requestTableview )
        return  NO;
    else
        return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.buddyTableView){
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            XMPPJID *jid;
            XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            //        NSString *test = [[NSString alloc]initWithString:user.displayName];
            NSRange range = [user.displayName rangeOfString:@"@"];
            if(range.location == NSNotFound){
//                jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",(NSString *)user.displayName,@"127.0.0.1"]];
                jid = [XMPPJID jidWithString:user.displayName];
            }
            else {
                jid = [XMPPJID jidWithString:user.displayName];
            }
            //         XMPPJID *jid = [XMPPJID jidWithString:user.displayName];
            
            [[[self appDelegate] xmppRoster] removeUser:jid];
            //        [self.game removeObjectAtIndex:indexPath.row];
            //        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        [tableView reloadData];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.buddyTableView)
        return [[[self fetchedResultsController] sections] count];
    else if(tableView == self.requestTableview)
        return 1;
    else if(tableView == self.searchDisplayCrl.searchResultsTableView)
        return 1;
}

- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)section
{
    if(sender == self.requestTableview) {
        return @"new friends";
    }
    else if(sender == self.searchDisplayCrl.searchResultsTableView){
        return @"searchResult";
    }
//    if(sender == self.buddyTableView){
    else {
        NSArray *sections = [[self fetchedResultsController] sections];
        
        if (section < [sections count])
        {
            id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
            return [sectionInfo name];
        }
        
        return @"";
        
        
        //        if([_arrayOfCharacters count]==0)
        //
        //        {
        //
        //            return @"";
        //
        //        }
        //
        //            return [_arrayOfCharacters objectAtIndex:section];
    }


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{

    if(tableView == self.buddyTableView ){
        NSArray *sections = [[self fetchedResultsController] sections];
        
        if (sectionIndex < [sections count])
        {
            id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
            return sectionInfo.numberOfObjects;
        }
        
        return 0;
    }
    else if(tableView == self.searchDisplayCrl.searchResultsTableView)
        return [self.searchResultArray count];
    else return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(tableView == self.requestTableview){
        static NSString *cellname = @"cell";
        self.cell = (InfoCell *)[tableView dequeueReusableCellWithIdentifier:cellname];
        if (self.cell == nil){
            self.cell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellname];
        }else{
            self.cell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellname];
        }
        self.cell.allRequestsArray = self.allRequestsArray;
        self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cell;
    }
    else if(tableView == self.searchDisplayCrl.searchResultsTableView ){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
        }
        NSInteger row = [indexPath row];
        XMPPUserCoreDataStorageObject *user = [self.searchResultArray objectAtIndex:row];
        NSMutableString *userName = [[NSMutableString alloc]initWithString:user.displayName];
        NSRange range = [userName rangeOfString:@"@"];
        if(range.location != NSNotFound){
            [userName setString:[userName substringToIndex:range.location]];
        }
        cell.textLabel.text = userName;
        if(user.isOnline){
            cell.detailTextLabel.text = @"available";
        }
        else {
            cell.detailTextLabel.text = @"unavailable";
        }
        [self configurePhotoForCell:cell user:user];
        return cell;
    }
    //if(tableView == self.buddyTableView )
    else {
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
        }
        XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        NSMutableString *userName = [[NSMutableString alloc]initWithString:user.displayName];
        NSRange range = [userName rangeOfString:@"@"];
        if(range.location != NSNotFound){
            [userName setString:[userName substringToIndex:range.location]];
        }
        cell.textLabel.text = userName;
        if(user.isOnline){
            cell.detailTextLabel.text = @"available";
        }
        else {
            cell.detailTextLabel.text = @"unavailable";
        }
        [self configurePhotoForCell:cell user:user];
        return cell;
        
    }
    
       
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.buddyTableView){
        XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.selectedUser = user;
//        ChatViewController *chatVC=[[ChatViewController alloc] init];
//        chatVC.chatUserJid=user.jid;
//        [self.navigationController pushViewController:chatVC animated:YES];
        [self performSegueWithIdentifier:@"chatFromBuddylist" sender:self];
    }
    else  if (tableView == self.requestTableview){
        if ([indexPath section]==0) {
            NSLog(@"indexPath section%d",[indexPath section]);
            NSLog(@"rows === %d",[indexPath row]);
        }
    }
//    else if (tableView == self.searchDisplayController.searchResultsTableView){
    else {
        XMPPUserCoreDataStorageObject *user = [self.searchResultArray objectAtIndex:[indexPath row]];
        self.selectedUser = user;
        [self performSegueWithIdentifier:@"chatFromBuddylist" sender:self];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.requestTableview){
        return 50;
    }
    else
        return 50;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == self.buddyTableView){
        NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
        
        for(char c = 'A';c<='Z';c++)
            
            [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
        
        return toBeReturned;
    }
    else return nil;
}

- (NSInteger) indexOfTitle:(NSString *)title{
    NSInteger count = 0;
    for(NSString *string in _arrayOfCharacters){
        if([title isEqualToString:string]){
            return count;
        }
        count++;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(tableView == self.buddyTableView){
        NSInteger theIndexOfTitle = [self indexOfTitle:title];
        NSInteger temp = 0;
        NSInteger indexOfSection = 0;
        
        
//        NSInteger count = 0;
        NSArray *sections = [[self fetchedResultsController]sections];
        int section = 0;
//        if (section < [sections count])
//        {
//            id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
//            return [sectionInfo name];
//        }
        NSUInteger sectionIndex = 0;
        for(;sectionIndex<[sections count];sectionIndex++)
            
        {
            id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
            indexOfSection = [self indexOfTitle:[sectionInfo name]];
            if(indexOfSection == theIndexOfTitle)
                return sectionIndex-1>-1?sectionIndex-1:sectionIndex;
            else if(indexOfSection>theIndexOfTitle && temp < theIndexOfTitle){
                return sectionIndex;
            }
            else {
                temp = indexOfSection;
            }
            
        }
        
        return 0;
    }
    else return  nil;

}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//    if([_arrayOfCharacters count]==0)
//        
//    {
//        
//        return @"";
//        
//        ｝
//        
//        return [arrayOfCharacters objectAtIndex:section];
//    
//}

- (void)viewDidUnload {
//    [self setBuddyTableView:nil];
////    [self setBuddyJID:nil];
//    [self setRequestTableView:nil];
    [self setSearchBuddyBar:nil];
    [super viewDidUnload];
}
- (IBAction)disconnect:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[self appDelegate] disconnect];
    
}



- (IBAction)addBuddy:(id)sender {
    
//    XMPPJID *friendJID = [XMPPJID jidWithString:self.buddyJID.text];
//    [[self appDelegate].xmppRoster addUser:friendJID withNickname:nil];
//    
    
}


- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark buttonActions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)acceptBuddyRequest:(id)sender {
    if([self.allRequestsArray containsObject:self.cell.selectedJID]){
        NSString *filePath = [[self appDelegate] dataFilePath];
        NSMutableString *newJid = [[NSMutableString alloc ] initWithString:self.cell.selectedJID];
        [newJid appendString:@"@"];
        [newJid appendString:kServername];
        [[self appDelegate].xmppRoster acceptPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:newJid] andAddToRoster:YES];
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        [self.allRequestsArray removeObject:self.cell.selectedJID];
        [self.allRequestsArray writeToFile:filePath atomically:YES];
        [self.requestTableview reloadData];
    }
    [self showTableViews];
}

- (IBAction)rejectBuddyRequest:(id)sender {
    if([self.allRequestsArray containsObject:self.cell.selectedJID]){
        NSString *filePath = [[self appDelegate] dataFilePath];
        NSMutableString *newJid = [[NSMutableString alloc ] initWithString:self.cell.selectedJID];
        [newJid appendString:@"@"];
        [newJid appendString:kServername];
        [[self appDelegate].xmppRoster rejectPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:newJid]];
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        [self.allRequestsArray removeObject:self.cell.selectedJID];
        [self.allRequestsArray writeToFile:filePath atomically:YES];
        [self.requestTableview reloadData];
    }
    [self showTableViews];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark requests
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void) readAllRequests{
    NSString *filePath = [[self appDelegate] dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableArray *requests = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        for(NSString *string in requests){
            if(!self.allRequestsArray){
                self.allRequestsArray = [[NSMutableArray alloc] init];
                [self.allRequestsArray addObject:string];
            }
            if(![self.allRequestsArray containsObject:string]){
                [self.allRequestsArray addObject:string];
            }
            
        }
        
    }
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark popupMenu
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
//      
      [KxMenuItem menuItem:@"ACTION MENU"
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:@"输入昵称查找"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"邀请好友"
                     image:[UIImage imageNamed:@"check_icon"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"随缘吧"
                     image:[UIImage imageNamed:@"reload"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
//      [KxMenuItem menuItem:@"Search"
//                     image:[UIImage imageNamed:@"search_icon"]
//                    target:self
//                    action:@selector(pushMenuItem:)],
//      
//      [KxMenuItem menuItem:@"Go home"
//                     image:[UIImage imageNamed:@"home_icon"]
//                    target:self
//                    action:@selector(pushMenuItem:)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
}


#pragma mark - Searching

- (void)updateSearchString:(NSString*)aSearchString
{
    NSInteger rows;
    NSArray *sectionsArr = [[NSArray alloc] initWithArray:[[self fetchedResultsController]sections]];
    NSInteger sections = [sectionsArr count];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int sectionIndex=0;sectionIndex<sections;sectionIndex++){
//        rows = sectionsArr[j].
        id <NSFetchedResultsSectionInfo> sectionInfo = [sectionsArr objectAtIndex:sectionIndex];
        rows = [sectionInfo numberOfObjects];
        for(int rowIndex = 0;rowIndex < rows ;rowIndex++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            XMPPUserCoreDataStorageObject *usr = [[self fetchedResultsController]objectAtIndexPath:indexPath];
           
            NSMutableString *userName = [[NSMutableString alloc]initWithString:usr.displayName];
            NSRange range = [userName rangeOfString:@"@"];
            if(range.location != NSNotFound){
                [userName setString:[userName substringToIndex:range.location]];
            }

            if ([userName rangeOfString:aSearchString options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [array addObject:usr];
            }
            //array;
        }
       
    }
    self.searchResultArray = [[NSMutableArray alloc] initWithArray:array];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBuddyBar setShowsCancelButton:YES animated:YES];
//    self.tableView.allowsSelection = NO;
//    self.tableView.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBuddyBar setShowsCancelButton:NO animated:YES];
    [self.searchBuddyBar resignFirstResponder];
//    self.tableView.allowsSelection = YES;
//    self.tableView.scrollEnabled = YES;
//    self.searchBar.text=@"";
    [self.searchDisplayCrl.searchResultsTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    self.tableView.allowsSelection = YES;
//    self.tableView.scrollEnabled = YES;
    [self updateSearchString:self.searchBuddyBar.text];
    [self.searchBuddyBar resignFirstResponder];   //隐藏输入键盘
    [self.searchDisplayCrl.searchResultsTableView reloadData];
}


-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    
    CGRect f = self.view.frame;  // The tableView the search replaces
    CGRect s = self.searchBuddyBar.frame;
    CGRect newFrame = CGRectMake(f.origin.x+50,
                                 f.origin.y + s.size.height,
                                 f.size.width-94,
                                 f.size.height - s.size.height);
    
    tableView.frame = newFrame;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"chatFromBuddylist"]){
        if([segue.destinationViewController isKindOfClass:[ChatViewController class]] ){
            ChatViewController *chatVC = (ChatViewController *)segue.destinationViewController;
            chatVC.chatUserJid = [self.selectedUser jid] ;
        }
    }
}

@end
