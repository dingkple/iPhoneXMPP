//
//  ECUSTsearchAllUsersVC.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-14.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ChatViewController.h"


@interface ECUSTsearchAllUsersVC : UIViewController<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    NSFetchedResultsController *fetchedResultsController;
}

@property (strong, nonatomic) UITableView *allUserTableView;
@property (strong, nonatomic) ChatViewController *sourceViewController;
@property (strong, nonatomic) XMPPJID *chatJID;

@end
