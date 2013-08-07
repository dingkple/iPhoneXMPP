//  ECUSTServerInfo.h
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-5.
//
//

#import <Foundation/Foundation.h>

@interface ECUSTServerInfo : NSObject{
    NSString *serverHost;
    NSString *JIDFollowing;
    NSString *serverAddress;
    NSMutableString *defaultJID;
    NSString *defaultPassword;
//    NSString *
}

@property (strong, nonatomic) NSString *serverHost;
@property (strong, nonatomic) NSString *JIDFlowing;
@property (strong, nonatomic) NSString *serverAddress;
@property (strong, nonatomic) NSMutableString *defaultJID;
@property (strong, nonatomic) NSString *defaultPassword;

@end
