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
#import "WalaBuddycell.h"
#import "AddBuddyByInputViewController.h"

#define kPopupModalAnimationDuration 0.35
#define kMJSourceViewTag 23941
#define kMJPopupViewTag 23942
#define kMJBackgroundViewTag 23943
#define kMJOverlayViewTag 23945

#define kServername @"127.0.0.1"

#define buddyCellSize 446,54



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
@property (nonatomic) CGRect buddyTableRectTop;
@property (nonatomic) CGRect buddyTableRectBottom;
@property (nonatomic) CGRect requestTableRect;
@property (nonatomic) CGRect requestTableBkgRect;


@property (strong, nonatomic) UIImageView *requestTableBkg;

@property (strong, nonatomic) AddBuddyByInputViewController *addBuddyViewPop;

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
- (void)awakeFromNib{
    self.tabBarController.tabBar.tintColor = [[UIColor alloc] initWithRed:0.141
                                                                    green:0.165
                                                                     blue:0.180
                                                                    alpha:1.0];
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"我的好友" image:nil tag:2];
    [item setFinishedSelectedImage:[UIImage imageNamed:@"BottomActionbarIcon1_2"]
       withFinishedUnselectedImage:[UIImage imageNamed:@"BottomActionbarIcon1_1"]];
    
    self.tabBarItem = item;
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
//    self.tabBarController.tabBar.tintColor = [[UIColor alloc] initWithRed:0.141
//                                                                    green:0.165
//                                                                     blue:0.180
//                                                                    alpha:1.0];
//    
//    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"我的好友" image:nil tag:2];
//    [item setFinishedSelectedImage:[UIImage imageNamed:@"BottomActionbarIcon1_1"]
//       withFinishedUnselectedImage:[UIImage imageNamed:@"BottomActionbarIcon1_2"]];
//    
//    self.tabBarItem = item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void) setupView{
    
    self.buddyTableRectBottom = CGRectMake(15, 155, 446, 128);
    self.buddyTableRectTop = CGRectMake(15, 75, 446, 208);
    self.requestTableRect = CGRectMake(15, 75, 446, 80);
    self.requestTableBkgRect = CGRectMake(15, 95, 446, 54);
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottomBackground_Buddylist"]]];
    
    
    
    
    const CGFloat W = self.view.bounds.size.width;
    const CGFloat H = self.view.bounds.size.height;
    UIButton *addNewButton;
    UIButton *backToLogin;
    
   
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(13, 0, 454, 300)];
    background.image = [UIImage imageNamed:@"background_Buddylist"];
    [self.view insertSubview:background atIndex:0];
    
    
//    backToLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    backToLogin.frame = CGRectMake(6, 10, 40, 30);
//    backToLogin.tag = 101;
//    [backToLogin setTitle:@"back" forState:UIControlStateNormal];
//    [backToLogin addTarget:self action:@selector(disconnect:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backToLogin];
//    
//    addNewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    addNewButton.frame = CGRectMake(W-40, 10, 40, 30);
//    addNewButton.tag = 102;
//    [addNewButton setTitle:@"new" forState:UIControlStateNormal];
//    [addNewButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:addNewButton];
    
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(40, 33, 200, 40)];
    searchBarView.backgroundColor = [UIColor clearColor];
    self.searchBuddyBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.searchBuddyBar.delegate = self;
    self.searchBuddyBar.barStyle = UIBarStyleDefault;
    self.searchBuddyBar.autocorrectionType = UITextAutocapitalizationTypeNone;
    self.searchBuddyBar.placeholder = @"search";
    self.searchBuddyBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBuddyBar.showsCancelButton = NO;
//    self.searchBuddyBar.tintColor = [UIColor colorWithRed:1 green:0.965 blue:0.898 alpha:1];
//    self.searchBuddyBar.inputView.backgroundColor = [UIColor colorWithRed:1 green:0.965 blue:0.898 alpha:1];
//    self.searchBuddyBar set
    [[self.searchBuddyBar.subviews objectAtIndex:0]removeFromSuperview];
    
//    UIView *searchBarBkg = [self.searchBuddyBar.subviews objectAtIndex:0];
    [searchBarView addSubview:self.searchBuddyBar];
//    searchBarBkg.bounds = searchBarBkg.frame;
    [self.view addSubview:searchBarView];
    
    
    UIButton *addBuddyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBuddyBtn.frame = CGRectMake(270, 15, 171, 58);
    addBuddyBtn.tag = 103;
    [addBuddyBtn setBackgroundImage:[UIImage imageNamed:@"addbuddyButton"] forState:UIControlStateNormal];
    [addBuddyBtn addTarget:self action:@selector(addNewBuddy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBuddyBtn];

    
    [self showTableViews];
    
//    self.searchDisplayCrl = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBuddyBar contentsController:self];
//    self.searchDisplayCrl.delegate = self;
//    self.searchDisplayCrl.searchResultsDataSource = self;
//    self.searchDisplayCrl.searchResultsDelegate = self;
    
    
    self.buddyTableView.backgroundColor = [UIColor clearColor];
    
    UIImageView *backgroundTopcover = [[UIImageView alloc]initWithFrame:CGRectMake(1, 0, 478, 67)];
    backgroundTopcover.image = [UIImage imageNamed:@"topCoverSmall_Buddylist"];
    [self.view addSubview:backgroundTopcover];
    
    
    
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
        if(!self.requestTableview){
            self.requestTableview = [[UITableView alloc] initWithFrame:self.requestTableRect style:UITableViewStylePlain];
            self.requestTableview.backgroundColor = [UIColor clearColor];
            self.requestTableview.delegate = self;
            self.requestTableview.dataSource = self;
            self.requestTableview.tag = 201;
            [self.requestTableview setRowHeight:50];
            self.requestTableview.bounces = NO;
            self.requestTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.requestTableview.hidden = NO;
            
            [self.view addSubview:self.requestTableview];
        }
        if(!self.buddyTableView){
            self.buddyTableView = [[UITableView alloc] initWithFrame:self.buddyTableRectBottom style:UITableViewStylePlain];
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
        self.buddyTableView.frame = self.buddyTableRectBottom;
        self.requestTableview.hidden = NO;
        self.requestTableview.backgroundColor = [UIColor clearColor];
        if(!_requestTableBkg){
            _requestTableBkg = [[UIImageView alloc]initWithFrame:self.requestTableBkgRect];
        }
        _requestTableBkg.image = [UIImage imageNamed:@"4.3Board_1.png"];
        [self.view addSubview:_requestTableBkg];
    }

}

- (void) hideRequestViewAndAdjustView{
    if (!self.requestTableview || !self.buddyTableView) {
        if(!self.requestTableview){
//            self.requestTableview = [[UITableView alloc] initWithFrame:CGRectMake(50, 40, 386, 80) style:UITableViewStylePlain];
            self.requestTableview = [[UITableView alloc] initWithFrame:self.requestTableRect style:UITableViewStylePlain];
        }
        self.requestTableview.backgroundColor = [UIColor clearColor];
        self.requestTableview.delegate = self;
        self.requestTableview.dataSource = self;
        self.requestTableview.tag = 201;
        [self.requestTableview setRowHeight:50];
        self.requestTableview.bounces = NO;
        self.requestTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.requestTableview.hidden = YES;
        [self.view addSubview:self.requestTableview];
        
        
        if(!self.buddyTableView){
            self.buddyTableView = [[UITableView alloc] initWithFrame:self.buddyTableRectTop style:UITableViewStylePlain];
        }
        self.buddyTableView.backgroundColor = [UIColor whiteColor];
        self.buddyTableView.delegate = self;
        self.buddyTableView.dataSource = self;
        self.buddyTableView.tag = 202;
        [self.buddyTableView setRowHeight:50];
        [self.view addSubview:self.buddyTableView];
    }

    //only need to reset the buddyTable's frame, the requestTable could be nil
    self.requestTableview.hidden = YES;
    self.buddyTableView.frame = self.buddyTableRectTop;
    self.requestTableBkg.hidden = YES;
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
//    else if([note.name isEqualToString:@"addNewBuddyByJID"]){
//        [self addBuddyBtnWithNotification:note];
//       
//    }
    else {
        [self.buddyTableView reloadData];
    }
}

//- (IBAction)acceptBuddyRequest:(id)sender {
//    NSMutableString *newJid = [[NSMutableString alloc ] initWithString:self.userBareJidLabel.text];
//    [newJid appendString:kServername];
//    [[self appDelegate].xmppRoster acceptPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:newJid] andAddToRoster:YES];
//}
//
//- (IBAction)blockUser:(id)sender {
//    NSMutableString *newJid = [[NSMutableString alloc ] initWithString:jidText];
//    [newJid appendString:kServername];
//    [[self appDelegate].xmppRoster rejectPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:newJid]];
//}



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

- (void)configurePhotoForCell:(WalaBuddycell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
	// Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
	// We only need to ask the avatar module for a photo, if the roster doesn't have it.
	
	if (user.photo != nil)
	{
		cell.userPhotoView.image = user.photo;
	}
	else
	{
		NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
		if (photoData != nil)
			cell.userPhotoView.image = [UIImage imageWithData:photoData];
		else
			cell.userPhotoView.image = [UIImage imageNamed:@"defaultPerson"];
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
        return NO;
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
            NSInteger num = [sectionInfo numberOfObjects];
            return num;
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
        self.cell.backgroundColor = [UIColor clearColor];
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
        WalaBuddycell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[WalaBuddycell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
        XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        //historical issue now display nickname
        NSMutableString *userName = [[NSMutableString alloc]initWithString:user.displayName];
        NSRange range = [userName rangeOfString:@"@"];
        if(range.location != NSNotFound){
            [userName setString:[userName substringToIndex:range.location]];
        }
        cell.userNameLabel.text = userName;
        
//        cell.userNameLabel.text = user.nickname;
//        if(user.photo){
//            [cell setPhoto:user.photo];
//            [cell autoresizesSubviews];
//        }
//        
//        else {
//            
//        }
        cell.tag = [indexPath row];
        
//        NSArray *subviews = [cell.contentView subviews];
//        for(UIView *view in subviews)
//        {
//            if([view isKindOfClass:[UIButton class]])
//            {
//                
//                view.tag = [indexPath row];
//                [cell.contentView bringSubviewToFront:view];
//            }    
//        }
        
        [self configureCellDelButton:cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [cell.contentView addGestureRecognizer:swipeleft];
        swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
//        UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleCellTapped:)];
//        [cell.contentView addGestureRecognizer:tap];
        cell.userDescriptionLabel.text = user.subscription;
        [self configurePhotoForCell:cell user:user];
        return cell;
        
    }
    
       
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.buddyTableView){
        WalaBuddycell *cell = (WalaBuddycell *)[tableView cellForRowAtIndexPath:indexPath];
        if(cell.delButton.hidden == NO){
            [UIView animateWithDuration:0.3f animations:^{
                cell.delButton.hidden = YES;
                cell.userDescriptionLabel.hidden = NO;
                cell.userDescriptionView.hidden = NO;
                
            }];
            return;
        }
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
        return 54;
}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if(tableView == self.buddyTableView){
//        NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
//        
//        for(char c = 'A';c<='Z';c++)
//            
//            [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
//        
//        return toBeReturned;
//    }
//    else return nil;
//}

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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    if(tableView == self.buddyTableView){
    }
    else if(tableView == self.requestTableview){
        UIView *requestHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
        [requestHeader setBackgroundColor:[UIColor clearColor]];
        UIImageView *newfrd = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 36, 12)];
        newfrd.image = [UIImage imageNamed:@"4.3newFriend.png"];
        [requestHeader addSubview:newfrd];
        return requestHeader;
        
    }
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UIColor *textColor = [UIColor colorWithRed:0.835  green:0.682 blue:0.408 alpha:1];
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, 300, 22);
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:label];
    return sectionView;

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

- (void)addNewBuddy:(id)sender{
    self.addBuddyViewPop = [[AddBuddyByInputViewController alloc]initWithNibName:@"AddBuddyByInputViewController" bundle:nil];
    self.addBuddyViewPop.rootVC = self;
    [self.addBuddyViewPop.addBuddyBtn addTarget:self action:@selector(addNewBuddyBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.addBuddyViewPop.jidTextField.delegate = self;
    [self presentPopupViewController:self.addBuddyViewPop animationType:MJPopupViewAnimationFade];

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
      
      [KxMenuItem menuItem:@"输入帐号查找"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(addNewFriendFromJID:)],
      
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

- (void)addNewFriendFromJID:(XMPPJID *)friendJID{
    
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    NSLog(@"swipeleft");
    NSArray *visiblecells = [self.buddyTableView visibleCells];
    for(WalaBuddycell *cell in visiblecells)
    {
        if(cell.tag == recognizer.view.tag)
        {
            [UIView animateWithDuration:30.f animations:^{
                cell.delButton.hidden = NO;
                cell.userDescriptionLabel.hidden = YES;
                cell.userDescriptionView.hidden = YES;
               
            }];
            break;
        }
    }
    
}

- (void)configureCellDelButton:(WalaBuddycell *)cell{
    [cell.delButton addTarget:self action:@selector(deleteBuddy:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)handleCellTapped:(UITapGestureRecognizer *)recognizer{
    NSArray *visiblecells = [self.buddyTableView visibleCells];
    for(WalaBuddycell *cell in visiblecells)
    {
        if(cell.tag == recognizer.view.tag)
        {
            if(cell.delButton.hidden == NO){
                cell.delButton.hidden = YES;
                cell.userDescriptionLabel.hidden = NO;
                cell.userDescriptionView.hidden = NO;
                break;
  
            }
            else {
                
            }
        }
    }
}

- (void)deleteBuddy:(WalaBuddycell *)cell{
    NSLog(@"deleteBuddy");
    // Delete the row from the data source
    XMPPJID *jid;
    NSIndexPath *indexPath;
    NSArray *visiblecells = [self.buddyTableView visibleCells];
    for(WalaBuddycell *aCell in visiblecells)
    {
        if(aCell.tag == cell.tag)
        {
            indexPath = [self.buddyTableView indexPathForCell:aCell];
        }
    }
    
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
    [self.buddyTableView reloadData];

}


#pragma mark - Text view delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma  mark addBuddyViewAction 

- (void) addNewBuddyBtn:(id)sender {
//    NSString *bareJid = [[note userInfo]objectForKey:@"userJid"];
//    XMPPJID *userJid = [XMPPJID jidWithString:bareJid];
//    [[[self appDelegate] xmppRoster] addUser:userJid withNickname:nil];
    NSMutableString *userJID = [[NSMutableString alloc] initWithString:self.addBuddyViewPop.jidTextField.text];
    [userJID appendString:@"@127.0.0.1"];
    [[[self appDelegate] xmppRoster]addUser:[XMPPJID jidWithString:userJID] withNickname:nil];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}


@end
