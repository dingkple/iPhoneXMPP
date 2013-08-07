#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "addBuddyViewController.h"


@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
	NSFetchedResultsController *fetchedResultsController;
    addBuddyViewController *viewToAddBuddyViewController;
}

- (IBAction)settings:(id)sender;
- (IBAction)addBuddy:(id)sender;

@end
