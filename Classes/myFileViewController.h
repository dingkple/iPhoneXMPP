//
//  myFileViewController.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-8-27.
//
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "TURNSocket.h"


@interface myFileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, TURNSocketDelegate>
@property (strong, nonatomic) XMPPJID *userJID;
@property (strong, nonatomic) TURNSocket *turnSocket;
@end
