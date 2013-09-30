//
//  myFileViewController.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-8-27.
//
//

#import "myFileViewController.h"
#import "iPhoneXMPPAppDelegate.h"

#define SOCKS_ACCEPT_FILE    0

@interface myFileViewController ()\
@property (strong, nonatomic) NSArray *files;
@property (strong, nonatomic) NSString *documentDir;

@end

@implementation myFileViewController

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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self getAllFiles];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark FileFunction

- (void)getAllFiles{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"documentsDirectory%@",documentsDirectory);
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    if(!_files){
        _files = [[NSArray alloc]init];
    }
    _files = [fileManage contentsOfDirectoryAtPath:_documentDir error:&error];
    
}


#pragma mark Views

- (void)setupViews{
    CGRect rectBack = CGRectMake(0, 0, 70, 22);
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonBack.frame = rectBack;
    [buttonBack setTitle:@"BACK" forState:UIControlStateNormal];
    buttonBack.backgroundColor = [UIColor clearColor];
    buttonBack.tag = 2000;
    [buttonBack addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    
    CGRect rectTable = CGRectMake(100, 0, 340, 320);
    UITableView *fileTable = [[UITableView alloc]initWithFrame:rectTable];
    fileTable.dataSource = self;
    fileTable.delegate = self;
    [self.view addSubview:fileTable];

}


#pragma mark ButtonActions

- (void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITalbesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return  NO;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
   
    return [_files count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_files objectAtIndex:[indexPath row]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *candidates = [NSArray arrayWithObjects:@"127.0.0.1",nil];
    //    if()
    [TURNSocket setProxyCandidates:candidates];
    _turnSocket = [[TURNSocket alloc] initWithStream:[self appDelegate].xmppStream toJID:[XMPPJID jidWithString:_userJID.bare resource:@"KingtekiMacBook-Pro"]];
    //    NSData *fileData = [[NSData alloc]initWithContentsOfFile:@"buddy.png"];
    NSString *name = [_files objectAtIndex:[indexPath row]];
    NSString *finalPath = [_documentDir stringByAppendingPathComponent:name];
    NSData *fileData = [NSData dataWithContentsOfFile: finalPath];
    //    UIImage *aimage = [UIImage imageWithData: imageData];
    //    [_turnSocket sendOfferingInfoWithName:@"zebra" andData:fileData To:[XMPPJID jidWithString:@"hios@127.0.0.1/Psi"]];
    //    [objTURNsocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_turnSocket setFileData:[fileData copy]];
    [_turnSocket setFileName:name];
    [_turnSocket setFileSize:fileData.length];
    [_turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}


- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket {
    

    if(sender.isClient){
        [socket writeData:sender.fileData withTimeout:10000 tag:0];
    }
    else{
        [socket readDataToLength:sender.fileSize withTimeout:-1 tag:SOCKS_ACCEPT_FILE];
    }
    
    
}

- (void)turnSocketDidRecieveFile: (TURNSocket *)sender{
    NSString *filePath = [self dataFilePath];
    [sender.fileData writeToFile:filePath atomically:YES];
//    [self loadImage];
    [self.view setNeedsDisplay];
}



- (void)turnSocketDidFail:(TURNSocket *)sender{
    _turnSocket = nil;
    
}


@end
