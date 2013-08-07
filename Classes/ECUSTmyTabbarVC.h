//
//  ECUSTmyTabbarVC.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-12.
//
//

#import <UIKit/UIKit.h>
#import "TURNSocket.h"
#import "TURNSocket.h"

@interface ECUSTmyTabbarVC : UIViewController <TURNSocketDelegate>

@property (strong, nonatomic)NSMutableArray *turnSockets;
@property (strong, nonatomic)TURNSocket *turnSocket;
@property (nonatomic)NSUInteger *offSet;
@end
