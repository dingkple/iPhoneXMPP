//
//  WalaNewMsgVC.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-9-10.
//
//

#import "WalaNewMsgVC.h"

#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+JSMessagesView.h"

#import "UIViewController+MJPopupViewController.h"

#import "iPhoneXMPPAppDelegate.h"

#define SOCKS_ACCEPT_FILE    0

@interface WalaNewMsgVC ()

@property (strong, nonatomic) UIView *msgView;
@property (strong, nonatomic) NSDate *startRecTime;
@property (strong, nonatomic) NSDate *stopRecTime;
@property (strong, nonatomic) NSString *soundFileName;
@property (strong, nonatomic) NSURL *soundFileUrl;

@end

@implementation WalaNewMsgVC

- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, 480, 320);
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    [self audio];
    
    self.imageNameStr = @"015-0001";
    [self setupViews];
    
    
    //setup enrion for recording sound files
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark Views

- (void)setupViews{
    
    [self.view setFrame:CGRectMake(0, 0, 480, 320)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bkg_Newmsg"]]];
    
    UIImageView *topcover = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 461, 82)];
    topcover.image = [UIImage imageNamed:@"topcover_Newmsg"];
    [self.view addSubview:topcover];
    
    
    _msgView = [[UIView alloc]initWithFrame:CGRectMake(40, 30, 400, 220)];
    _msgView.backgroundColor = [UIColor whiteColor];
    [self configureMsgview:self.imageNameStr];
    [self.view addSubview:_msgView];
    
    
    UIButton *recSoundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recSoundBtn.frame = CGRectMake(0, 140, 68, 56);
    recSoundBtn.tag = 1001;
    [recSoundBtn setBackgroundImage:[UIImage imageNamed:@"soundRec_Newmsg"] forState:UIControlStateNormal];
    [recSoundBtn addTarget:self action:@selector(startRecNewSoundMsg:) forControlEvents:UIControlEventTouchDown];
    [recSoundBtn addTarget:self action:@selector(stopRecNewSoundMsg:) forControlEvents:UIControlEventTouchUpInside];
    [recSoundBtn addTarget:self action:@selector(cancenRecNewSoundMsg:) forControlEvents:UIControlEventTouchDragExit];
    [self.view addSubview:recSoundBtn];
    
    
    UIButton *changeTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeTextBtn.frame = CGRectMake(420, 140, 68, 54);
    changeTextBtn.tag = 1002;
    [changeTextBtn setBackgroundImage:[UIImage imageNamed:@"changeText_Newmsg"] forState:UIControlStateNormal];
    [changeTextBtn addTarget:self action:@selector(editText:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeTextBtn];
    
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 10, 44, 38);
    backBtn.tag = 1003;
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn_Newmsg"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(140, 255, 201, 43);
    sendBtn.tag = 1004;
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"send_Newmsg"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    
    if(!_imageView){
        _imageView = [[UIImageView alloc]init];
    }
    _imageView.frame = CGRectMake(self.view.frame.size.width/2-75/2, self.view.frame.size.height/2 - 111/2, 75, 111);
    [self.view addSubview:_imageView];
    
}




#pragma mark Actions

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editText:(id)sender{
    _aWalaTextEditVC = [[WalaTextEditVC alloc]initWithNibName:@"WalaTextEditVC" bundle:nil];
//    aWalaTextEditVC = [WalaTextEditVC init];
    _aWalaTextEditVC.rootVC = self;
    UIButton *bkgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _aWalaTextEditVC.textDelegate = self;
    bkgBtn.backgroundColor = [UIColor clearColor];
    bkgBtn.frame = _aWalaTextEditVC.view.bounds;
    [bkgBtn addTarget:self action:@selector(endEditing:) forControlEvents:UIControlEventTouchUpInside];
    [_aWalaTextEditVC.view insertSubview:bkgBtn atIndex:1];
    [self presentPopupViewController:_aWalaTextEditVC animationType:MJPopupViewAnimationFade];
    
    
}

- (void)startRecNewSoundMsg:(id)sender{
    //创建录音文件，准备录音
    _imageView.hidden = NO;
    if ([recorder prepareToRecord]) {
        //开始
        [recorder record];
    }
    
    //设置定时检测
    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
  
}

- (void)stopRecNewSoundMsg:(id)sender{
    double cTime = recorder.currentTime;
    if (cTime > 2) {//如果录制时间<2 不发送
       
    }else {
        //删除记录的文件
        [recorder deleteRecording];
        //删除存储的
    }
    [recorder stop];
    [timer invalidate];
    _imageView.hidden = YES;
}


- (void) cancenRecNewSoundMsg:(id)sender{
    
}

- (NSURL *)setSoundFileUrl{
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //  get a name for the sound file
    NSDate *filenameByDate = [NSDate date];
    _soundFileName = [self stringFromDate:filenameByDate];
    _soundFileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@lll.aac", strUrl,_soundFileName]];
    return _soundFileUrl;
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyyMMdd HHmmss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

- (void)audio
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    [self setSoundFileUrl];
    urlPlay = _soundFileUrl;
    
    NSError *error;
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:_soundFileUrl settings:recordSetting error:&error];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}

- (void)detectionVoice
{
    [recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    NSLog(@"%lf",lowPassResults);
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.06) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }else if (0.06<lowPassResults<=0.13) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_02.png"]];
    }else if (0.13<lowPassResults<=0.20) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_03.png"]];
    }else if (0.20<lowPassResults<=0.27) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_04.png"]];
    }else if (0.27<lowPassResults<=0.34) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_05.png"]];
    }else if (0.34<lowPassResults<=0.41) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_06.png"]];
    }else if (0.41<lowPassResults<=0.48) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_07.png"]];
    }else if (0.48<lowPassResults<=0.55) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_08.png"]];
    }else if (0.55<lowPassResults<=0.62) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_09.png"]];
    }else if (0.62<lowPassResults<=0.69) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_10.png"]];
    }else if (0.69<lowPassResults<=0.76) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_11.png"]];
    }else if (0.76<lowPassResults<=0.83) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_12.png"]];
    }else if (0.83<lowPassResults<=0.9) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_13.png"]];
    }else {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_14.png"]];
    }
}

- (void) updateImage
{
    [self.imageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
}


#pragma mark Msgviews

- (void)configureMsgview:(NSString *)imageNameStr{
    NSMutableArray *images;
    if(!images){
        images = [[NSMutableArray alloc]init];
    }
    NSMutableString *imageNameTemp = [[NSMutableString alloc]initWithString:imageNameStr];
    NSMutableString *temp = [[NSMutableString alloc]initWithString:[imageNameTemp substringToIndex:imageNameTemp.length-2]];
    for(int i=1;i<=100;i++){
        NSMutableString *imageString;
        if(i<10){
            imageString = [NSMutableString stringWithString:temp.copy];
            [imageString appendString:@"0"];
        }
        else {
            imageString = [NSMutableString stringWithString:temp.copy];
        }
        [imageString appendString:[NSString stringWithFormat:@"%d",i]];
        UIImage *newIMG = [UIImage imageNamed:imageString];
        if(newIMG){
           [images addObject:newIMG];
        }
        else break;
    }
    _animationView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 40, 180, 150)];
        
    _animationView.animationImages = images;
    [_animationView setAnimationDuration:2.f];
    [_animationView setAnimationRepeatCount:0];
    [_animationView startAnimating];
    [_animationView setBackgroundColor:[UIColor clearColor]];
    [_msgView addSubview:_animationView];
    
    _textview = [[WalaNewmsgTextboxView alloc]initWithFrame:CGRectMake(250, 35, 101, 175)];
    _textview.text = self.textview.text;
    [_msgView addSubview: _textview];

}


#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (void)endEditing:(UITextView *)textView{
    [_aWalaTextEditVC.inputView resignFirstResponder];
}


- (void)setText:(NSString *)text{
    self.textview.text = text;
    [self.textview setNeedsDisplay];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}


-(void) sendButtonPressed:(id) sedner{
    self.sourceViewController.chatUserJid = self.chatJID;
    //    [self.sourceViewController.arrayChats removeAllObjects];
    //    [[self.sourceViewController fetchedMessageController]performFetch:nil];
    NSString *inputText = [self.textview.text trimWhitespace];
    if(inputText == nil){
        inputText = @"";
    }
    NSMutableString *newInputText = [[NSMutableString alloc]initWithString:inputText];
    [self addImagename:self.imageNameStr toNSString:newInputText];
//    NSMutableDictionary *note = [NSMutableDictionary dictionaryWithObject:newInputText forKey:@"InputText"];
    
    NSMutableDictionary *note;
    if(self.soundFileName != nil){
        note = [NSMutableDictionary dictionaryWithObject:self.soundFileName forKey:@"MessageBody"];
        NSArray *candidates = [NSArray arrayWithObjects:@"127.0.0.1",nil];
        //    if()
        [TURNSocket setProxyCandidates:candidates];
        _turnSocket = [[TURNSocket alloc] initWithStream:[self appDelegate].xmppStream toJID:[XMPPJID jidWithString:_chatJID.bare resource:@"Psi"]];
        //    NSData *fileData = [[NSData alloc]initWithContentsOfFile:@"buddy.png"];
        NSString *name = self.soundFileName;
        NSData *fileData = [NSData dataWithContentsOfURL: _soundFileUrl];
        //    UIImage *aimage = [UIImage imageWithData: imageData];
        //    [_turnSocket sendOfferingInfoWithName:@"zebra" andData:fileData To:[XMPPJID jidWithString:@"hios@127.0.0.1/Psi"]];
        //    [objTURNsocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_turnSocket setFileData:[fileData copy]];
        [_turnSocket setFileName:name];
        [_turnSocket setFileSize:fileData.length];
        [_turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    else{
        note = [NSMutableDictionary dictionaryWithObject:newInputText forKey:@"MessageBody"];
    }

    
    [note setObject:@"imaURL" forKey:@"imgURL"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newInputText" object:nil userInfo:note];
    [self.navigationController popToViewController:self.sourceViewController animated:YES];
    
   
}

- (NSMutableString *)addImagename:(NSString *)imagename toNSString:(NSMutableString *)mutableString{
    [mutableString insertString:@"[" atIndex:0];
    if(mutableString.length == 1){
        [mutableString appendString:imagename];
        [mutableString appendString:@"]"];
    }
    else {
        [mutableString insertString:imagename atIndex:1];
        [mutableString insertString:@"]" atIndex:1+imagename.length];
    }
     return mutableString;
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
    NSString *filePath = [_soundFileUrl description];
    [sender.fileData writeToFile:filePath atomically:YES];
    //    [self loadImage];
    [self.view setNeedsDisplay];
}



- (void)turnSocketDidFail:(TURNSocket *)sender{
    _turnSocket = nil;
    
}




@end
