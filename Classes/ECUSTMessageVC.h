//
//  ECUSTMessageVC.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-9.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface ECUSTMessageVC : UIViewController<UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    NSFetchedResultsController *fetchedContactController;
    NSFetchedResultsController *fetchedMessageController;
}

@end
