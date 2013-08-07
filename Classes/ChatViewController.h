//
//  ChatViewController.h
//  iPhoneXMPP
//
//  Created by 高 欣 on 13-5-27.
//
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "XMPPFramework.h"
@interface ChatViewController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource,NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *fetchedMessageController;
}
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;
@property (strong, nonatomic) NSFetchedResultsController *fetchedMessageController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedContactController;

@property (strong, nonatomic) XMPPJID *chatUserJid;

@property (strong,nonatomic) NSMutableArray *arrayChats;
@end
