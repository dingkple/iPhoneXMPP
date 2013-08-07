//
//  ECUSTsearchAllUsersVC.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-14.
//
//

#import "ECUSTsearchAllUsersVC.h"
#import "iPhoneXMPPAppDelegate.h"
#import "ECUSTTextInputVC.h"

@interface ECUSTsearchAllUsersVC ()

@end

@implementation ECUSTsearchAllUsersVC

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

- (void) setupViews{
    
    const CGFloat W = self.view.bounds.size.width;
    const CGFloat H = self.view.bounds.size.height;
    UIButton *addNewButton;
    UIButton *backToLogin;
    
    
    backToLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backToLogin.frame = CGRectMake(6, 10, 40, 30);
    backToLogin.tag = 101;
    [backToLogin setTitle:@"back" forState:UIControlStateNormal];
    [backToLogin addTarget:self action:@selector(goBackToBuddyView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToLogin];
    
    addNewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addNewButton.frame = CGRectMake(W-40, 10, 40, 30);
    addNewButton.tag = 102;
    [addNewButton setTitle:@"new" forState:UIControlStateNormal];
    [addNewButton addTarget:self action:@selector(addNewBuddy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addNewButton];
    
    self.allUserTableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 10, 386, 300) style:UITableViewStylePlain];
    self.allUserTableView.backgroundColor = [UIColor whiteColor];
    self.allUserTableView.delegate = self;
    self.allUserTableView.dataSource = self;
    self.allUserTableView.tag = 202;
    [self.allUserTableView setRowHeight:50];
    [self.view addSubview:self.allUserTableView];

    
}

- (IBAction)goBackToBuddyView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
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
        //		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
        //		                                                               managedObjectContext:moc
        //		                                                                 sectionNameKeyPath:@"sectionNum"
        //		                                                                          cacheName:nil];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:@"sectionName"
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
		
		
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
//			DDLogError(@"Error performing fetch: %@", error);
		}
        
	}
	
	return fetchedResultsController;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return  NO;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsController] sections]count];
}

- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)section
{
    NSArray *sections = [[self fetchedResultsController]sections];
    return [[sections objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSArray *sections = [[self fetchedResultsController] sections];
    
    if (sectionIndex < [sections count])
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        return sectionInfo.numberOfObjects;
    }
    
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    return cell;
  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    self.chatJID = user.jid;
    [self performSegueWithIdentifier:@"newInputChatText" sender:self];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



-(void)goBackToBuddyView{
    
}

-(void) addNewBuddy{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
    [self setupViews];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"newInputChatText"]){
        ECUSTTextInputVC *chat = (ECUSTTextInputVC *)[segue destinationViewController];
        chat.chatJID = self.chatJID;
        chat.sourceViewController = self.sourceViewController;
    }
}


@end
