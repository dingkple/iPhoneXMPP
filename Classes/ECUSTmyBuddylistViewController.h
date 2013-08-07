//
//  ECUSTmyBuddylistViewController.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-30.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MJDetailViewController.h"


//typedef enum {
//    MJPopupViewAnimationSlideBottomTop = 1,
//    MJPopupViewAnimationSlideRightLeft,
//    MJPopupViewAnimationSlideBottomBottom,
//    MJPopupViewAnimationFade
//} MJPopupViewAnimation;

@interface ECUSTmyBuddylistViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    NSFetchedResultsController *fetchedResultsController;
}
- (IBAction)disconnect:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *buddyTableView;
@property (strong, nonatomic) IBOutlet UITableView *requestTableview;
@property (nonatomic, retain) NSMutableArray   *allRequestsArray;
//@property (strong, nonatomic) IBOutlet UITextField *buddyJID;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBuddyBar;

- (IBAction)addBuddy:(id)sender;


@end
