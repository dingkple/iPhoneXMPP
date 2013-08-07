

#import <UIKit/UIKit.h>

@interface InfoCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *hortable;
    NSInteger porsection;
}

//
//typedef enum {
//    MJPopupViewAnimationSlideBottomTop = 1,
//    MJPopupViewAnimationSlideRightLeft,
//    MJPopupViewAnimationSlideBottomBottom,
//    MJPopupViewAnimationFade
//} MJPopupViewAnimation;


@property (nonatomic, retain) NSMutableArray   *allRequestsArray;

@property NSString *selectedJID;
-(void) readAllRequests;


@end
