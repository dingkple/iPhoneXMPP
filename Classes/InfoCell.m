
#import "InfoCell.h"
#import "iPhoneXMPPAppDelegate.h"

#import <QuartzCore/QuartzCore.h>
#import "MJPopupBackgroundView.h"
#import "MJDetailViewController.h"

#define kPopupModalAnimationDuration 0.35
#define kMJSourceViewTag 23941
#define kMJPopupViewTag 23942
#define kMJBackgroundViewTag 23943
#define kMJOverlayViewTag 23945


#define kSavedSubscription @"savedSubscription"

@interface InfoCell()


@end

@implementation InfoCell
@synthesize allRequestsArray;
@synthesize selectedJID;
- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}


//read from the subscribe.plist saved in appdelegate.m 
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
//    [[NSNotificationCenter defaultCenter] postNotificationName:kSavedSubscription object:nil];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        hortable = [[UITableView alloc]initWithFrame:CGRectMake(100, -90, 140, 250) style:UITableViewStylePlain];
        hortable.delegate = self;
        hortable.dataSource = self;
        hortable.transform = CGAffineTransformMakeRotation(M_PI / 2 * 3);
        hortable.showsHorizontalScrollIndicator = NO;
        hortable.showsVerticalScrollIndicator = YES;
        hortable.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:hortable];
//        _allRequestsArray = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",nil];
//        [self readAllRequests];
      

   }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//        return  [self count];
//    [self readAllRequests];
    return [self.allRequestsArray count];
 }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d",indexPath.row];
    NSLog(@"porsection---->%d",porsection);
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        [[cell textLabel] setText:[self.allRequestsArray objectAtIndex:indexPath.row]];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		
	}
	return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedJID = self.allRequestsArray[[indexPath row]];
    NSString *jid = [[NSString alloc] initWithString:self.selectedJID];
    NSDictionary *userJID = [NSDictionary dictionaryWithObject:jid forKey:@"JID"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectRequest" object:self userInfo:userJID];
    NSLog(@"点击%d",[indexPath row]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


//-(void) receiveNotification:(NSNotification *)note{
//    [self readAllRequests];
//
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark PopOverViews
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//
//- (void)presentPopupView:(UIView*)popupView animationType:(MJPopupViewAnimation)animationType
//{
//    UIView *sourceView = [self topView];
//    sourceView.tag = kMJSourceViewTag;
//    popupView.tag = kMJPopupViewTag;
//    
//    // check if source view controller is not in destination
//    if ([sourceView.subviews containsObject:popupView]) return;
//    
//    // customize popupView
//    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
//    popupView.layer.masksToBounds = NO;
//    popupView.layer.shadowOffset = CGSizeMake(5, 5);
//    popupView.layer.shadowRadius = 5;
//    popupView.layer.shadowOpacity = 0.5;
//    
//    // Add semi overlay
//    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
//    overlayView.tag = kMJOverlayViewTag;
//    overlayView.backgroundColor = [UIColor clearColor];
//    
//    // BackgroundView
//    MJPopupBackgroundView *backgroundView = [[MJPopupBackgroundView alloc] initWithFrame:sourceView.bounds];
//    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    backgroundView.tag = kMJBackgroundViewTag;
//    backgroundView.backgroundColor = [UIColor clearColor];
//    backgroundView.alpha = 0.0f;
//    [overlayView addSubview:backgroundView];
//    
//    // Make the Background Clickable
//    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    dismissButton.backgroundColor = [UIColor clearColor];
//    dismissButton.frame = sourceView.bounds;
//    [overlayView addSubview:dismissButton];
//    
//    popupView.alpha = 0.0f;
//    [overlayView addSubview:popupView];
//    [sourceView addSubview:overlayView];
//    
//    //    if(animationType == MJPopupViewAnimationSlideBottomTop) {
//    //        [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeSlideBottomTop) forControlEvents:UIControlEventTouchUpInside];
//    //        [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
//    //    } else if (animationType == MJPopupViewAnimationSlideRightLeft) {
//    //        [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeSlideRightLeft) forControlEvents:UIControlEventTouchUpInside];
//    //        [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
//    //    } else if (animationType == MJPopupViewAnimationSlideBottomBottom) {
//    //        [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeSlideBottomBottom) forControlEvents:UIControlEventTouchUpInside];
//    //        [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
//    //    } else {
//    //        [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeFade) forControlEvents:UIControlEventTouchUpInside];
//    //        [self fadeViewIn:popupView sourceView:sourceView overlayView:overlayView];
//    //    }
//    [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeFade) forControlEvents:UIControlEventTouchUpInside];
//    [self fadeViewIn:popupView sourceView:sourceView overlayView:overlayView];
//}
//
//-(UIView*)topView {
//    UIViewController *recentView = self;
//    
//    while (recentView.parentViewController != nil) {
//        recentView = recentView.parentViewController;
//    }
//    return recentView.view;
//}
//
//- (void)fadeViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
//{
//    UIView *backgroundView = [overlayView viewWithTag:kMJBackgroundViewTag];
//    // Generating Start and Stop Positions
//    CGSize sourceSize = sourceView.bounds.size;
//    CGSize popupSize = popupView.bounds.size;
//    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//                                     (sourceSize.height - popupSize.height) / 2,
//                                     popupSize.width,
//                                     popupSize.height);
//    
//    // Set starting properties
//    popupView.frame = popupEndRect;
//    popupView.alpha = 0.0f;
//    
//    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
//        backgroundView.alpha = 0.5f;
//        popupView.alpha = 1.0f;
//    } completion:^(BOOL finished) {
//    }];
//}
//
//- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(MJPopupViewAnimation)animationType
//{
//    [self presentPopupView:popupViewController.view animationType:animationType];
//}
//
//



@end
