//
//  ECUSTmyTabbarVC.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-12.
//
//

#import "ECUSTmyTabbarVC.h"
#import <QuartzCore/QuartzCore.h>
#import "iPhoneXMPPAppDelegate.h"
#import "GCDAsyncSocket.h"


#define SOCKS_ACCEPT_FILE    0


@interface ECUSTmyTabbarVC (){
    NSInteger tag;
}

@property (strong, nonatomic) UIImageView *imageView;

@end



@implementation ECUSTmyTabbarVC



- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"buddy.png"];
}

- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}


//- (void)viewDidLoad{
//    
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setupView{
//    for(int i = 0 ; i < 4 ; i ++){
//        
//        UIView *tab = [[UIView alloc] initWithFrame:CGRectZero];
//        UIImage *
//    }
    
    
    
    
    UIButton *buttonOfTransferFile = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 30, 30)];
    buttonOfTransferFile.layer.cornerRadius = 10;
    buttonOfTransferFile.tag = 202;
    [buttonOfTransferFile setTitle:@"shop" forState:UIControlStateNormal];
    [buttonOfTransferFile addTarget:self action:@selector(fileTransfer:) forControlEvents:UIControlEventTouchUpInside];
    [buttonOfTransferFile setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:buttonOfTransferFile];
    
//    NSString *string = [[self appDelegate]dataFilePath];
//    NSMutableString *path = [[NSMutableString alloc]initWithString:string];
//    [path appendString:@"zebra.jpg"];
    [self loadImage];
    _imageView.frame = CGRectMake(200, 100, 100, 100);
    [self.view addSubview:_imageView];
    
    
    
    
    
    CGRect shopTabRect = CGRectMake(200, 250, 220, 44);
    UIView *shopTab = [[UIView alloc] initWithFrame:shopTabRect];
    shopTab.tag = 304;
    //    UIImage *buddyImg = [UIImage imageNamed:@"buddy.png"];
    shopTab.backgroundColor = [UIColor brownColor];
    shopTab.layer.cornerRadius=10;
    [self.view addSubview:shopTab];
    
    CGRect albumTabRect = CGRectMake(140, 250, 220, 44);
    UIView *albumTab = [[UIView alloc] initWithFrame:albumTabRect];
    albumTab.tag = 303;
    //    UIImage *buddyImg = [UIImage imageNamed:@"buddy.png"];
    albumTab.backgroundColor = [UIColor greenColor];
    albumTab.layer.cornerRadius=10;
//    albumTab.layer.shadowColor=[UIColor redColor].CGColor;
//    albumTab.layer.shadowOffset=CGSizeMake(10, 10);
//    albumTab.layer.shadowOpacity=0.5;
//    albumTab.layer.shadowRadius=5;
    [self.view addSubview:albumTab];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect messageTabRect = CGRectMake(75, 250, 220, 44);
    UIView *messageTab = [[UIView alloc] initWithFrame:messageTabRect];
    //    UIImage *buddyImg = [UIImage imageNamed:@"buddy.png"];
    messageTab.tag = 302;
    messageTab.backgroundColor = [UIColor yellowColor];
    messageTab.layer.cornerRadius=10;
    CGRect messageButtonRect = CGRectMake(170, 5, 35, 35);
    UIButton *messageListButton = [[UIButton alloc]initWithFrame:messageButtonRect];
    messageListButton.layer.cornerRadius = 10;
    messageListButton.tag = 202;
    [messageListButton setTitle:@"shop" forState:UIControlStateNormal];
    [messageListButton addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    [messageListButton setBackgroundColor:[UIColor redColor]];
    [messageTab setAlpha:1];
    [messageTab addSubview: messageListButton];
    [messageTab bringSubviewToFront:messageListButton];
    [self.view addSubview:messageTab];
    
    CGRect buddyTabRect = CGRectMake(20, 250, 220, 44);
    UIView *buddyTab = [[UIView alloc] initWithFrame:buddyTabRect];
    buddyTab.tag = 301;
    UIImage *buddyImg = [UIImage imageNamed:@"buddy.png"];
    buddyTab.backgroundColor = [UIColor colorWithPatternImage:buddyImg];
    buddyTab.layer.cornerRadius=10;
    [self.view addSubview:buddyTab];
   
    
}



- (void)loadImage{
    NSString *filePath = [self dataFilePath];
    NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:data];
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithImage:image];
    }
    else {
        _imageView.image = image; 
    }
}

-(void) startTurnSock:(NSNotification *)note{
    XMPPIQ *iq = [note.userInfo objectForKey:@"iq"];
    NSArray *candidates = [NSArray arrayWithObjects:@"127.0.0.1",nil];
    [TURNSocket setProxyCandidates:candidates];
    TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[[self appDelegate]xmppStream] incomingTURNRequest:iq];
    if(!_turnSockets){
        _turnSockets = [[NSMutableArray alloc]init];
    }
    [_turnSockets addObject:turnSocket];
    [turnSocket proceOfferingFile:iq];
    [turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];

}


-(void) fileTransfer:(id)sender{
    NSArray *candidates = [NSArray arrayWithObjects:@"127.0.0.1",nil];
//    if()
    [TURNSocket setProxyCandidates:candidates];
   _turnSocket = [[TURNSocket alloc] initWithStream:[self appDelegate].xmppStream toJID:[XMPPJID jidWithString:@"hios@127.0.0.1/Psi"]];
//    NSData *fileData = [[NSData alloc]initWithContentsOfFile:@"buddy.png"];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *name = [NSString stringWithFormat:@"buddy.png"];
    NSString *finalPath = [path stringByAppendingPathComponent:name];
    NSData *fileData = [NSData dataWithContentsOfFile: finalPath];
//    UIImage *aimage = [UIImage imageWithData: imageData];
//    [_turnSocket sendOfferingInfoWithName:@"zebra" andData:fileData To:[XMPPJID jidWithString:@"hios@127.0.0.1/Psi"]];
//    [objTURNsocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_turnSocket setFileData:[fileData copy]];
    [_turnSocket setFileName:name];
    [_turnSocket setFileSize:fileData.length];
    [_turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}





-(void) changeView:(id)sender{
    UIView *buddy = [self.view viewWithTag:301];
    UIView *msg = [self.view viewWithTag:302];
    NSInteger buddyIndex = [[self.view subviews] indexOfObject:buddy];
    NSInteger msgIndex = [[ self.view subviews] indexOfObject:msg];
    [self.view exchangeSubviewAtIndex:buddyIndex withSubviewAtIndex:msgIndex];

    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .7;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    tag = 204;
    switch (tag) {
        case 101:
            animation.type = kCATransitionFade;
            break;
        case 102:
            animation.type = kCATransitionPush;
            break;
        case 103:
            animation.type = kCATransitionReveal;
            break;
        case 104:
            animation.type = kCATransitionMoveIn;
            break;
        case 201:
            animation.type = @"cube";
            break;
        case 202:
            animation.type = @"suckEffect";
            break;
        case 203:
            animation.type = @"oglFlip";
            break;
        case 204:
            animation.type = @"rippleEffect";
            break;
        case 205:
            animation.type = @"pageCurl";
            break;
        case 206:
            animation.type = @"pageUnCurl";
            break;
        case 207:
            animation.type = @"cameraIrisHollowOpen";
            break;
        case 208:
            animation.type = @"cameraIrisHollowClose";
            break;
        default:
            break;
    }
    int typeID = 1;
    switch (typeID) {
        case 0:
            animation.subtype = kCATransitionFromLeft;
            break;
        case 1:
            animation.subtype = kCATransitionFromBottom;
            break;
        case 2:
            animation.subtype = kCATransitionFromRight;
            break;
        case 3:
            animation.subtype = kCATransitionFromTop;
            break;
        default:
            break;
    }
    typeID += 1;
    if (typeID > 3) {
        typeID = 0;
    }
//    if(tag == 105){
//        tag = 201;
//    }
//    else if(tag >208){
//        tag =100;
//    }
//    tag++;
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    tag = 100;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTurnSock:) name:@"newOfferedFile"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileAccepted:) name:@"offeredFileAccepted" object:nil];
    _offSet = 0;
}


-(void) viewWillAppear:(BOOL)animated{
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fileAccepted:(NSNotification *)note{
//    XMPPIQ *iq = [note.userInfo objectForKey:@"iq"];
//    NSArray *candidates = [NSArray arrayWithObjects:@"127.0.0.1",nil];
//    [TURNSocket setProxyCandidates:candidates];
//    TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[[self appDelegate] xmppStream] incomingTURNRequest:iq];
//    if(!_turnSockets){
//        _turnSockets = [[NSMutableArray alloc]init];
//    }
//    [_turnSockets addObject:turnSocket];
//    [turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket {
    
//    NSData *dataF = [[NSData alloc] initWithContentsOfFile:
//                     [[NSBundle mainBundle] pathForResource:@"a1" ofType:@"png"]];
//    
//    [socket writeData:dataF withTimeout:60.0f tag:0];
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSString *name = [NSString stringWithFormat:@"buddy.png"];
//    NSString *finalPath = [path stringByAppendingPathComponent:name];
//    NSData *fileData = [NSData dataWithContentsOfFile: finalPath];
    if(sender.isClient){
        [socket writeData:sender.fileData withTimeout:10000 tag:0];
    }
    else{
//        NSMutableData *buffer = [[NSMutableData alloc]init];
//        NSMutableString *filePath = [self dataFilePath];
//        [filePath appendString:sender.fileName];
//        [socket readDataWithTimeout:-1 buffer:sender.fileData bufferOffset:_offSet tag:SOCKS_ACCEPT_FILE];
////        [socket re]
//        _offSet = sender.fileData.length+1;
        [socket readDataToLength:sender.fileSize withTimeout:-1 tag:SOCKS_ACCEPT_FILE];
//        [buffer writeToFile:filePath atomically:YES];
    }
    
    
}

- (void)turnSocketDidRecieveFile: (TURNSocket *)sender{
    NSString *filePath = [self dataFilePath];
    [sender.fileData writeToFile:filePath atomically:YES];
    [self loadImage];
    [self.view setNeedsDisplay];
}



- (void)turnSocketDidFail:(TURNSocket *)sender{
    _turnSocket = nil;
    
}



@end
