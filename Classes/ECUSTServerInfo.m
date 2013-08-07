//
//  ECUSTServerInfo.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-5.
//
//

#import "ECUSTServerInfo.h"

@implementation ECUSTServerInfo
@synthesize serverAddress;
@synthesize serverHost;
@synthesize JIDFlowing;
@synthesize defaultJID;
@synthesize defaultPassword;


-(void) initAllServerInfo{
    self.serverHost = @"kingtekimacbook-pro.local";
    self.serverAddress = @"127.0.0.1";
    [self.defaultJID setString:@"ios@"];
    [self.defaultJID appendString:self.serverHost];
    self.defaultPassword = @"123";
}

@end
