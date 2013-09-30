//
//  ECUSTprepareToLogAndREgViewController.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-29.
//
//

#import "ECUSTprepareToLogAndREgViewController.h"

@interface ECUSTprepareToLogAndREgViewController ()

@property (strong, nonatomic) NSMutableArray *loginImages;
@property (strong, nonatomic) NSMutableArray *regImages;
@property (strong, nonatomic) UIImageView *loginButtonView;
@property (strong, nonatomic) UIImageView *regButtonView;

@end

@implementation ECUSTprepareToLogAndREgViewController


-(void)viewWillAppear:(BOOL)animated{
    animated =YES;
    self.myPrepareView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"welcome_bg_ios_320"]];
    
}

- (void)setupViews{
    
    if(!_loginImages){
        _loginImages = [[NSMutableArray alloc]init];
    }
    if(!_regImages){
        _regImages = [[NSMutableArray alloc]init];
    }
    for(int i=1;i<=9;i++){
        NSMutableString *imageString;
        imageString = [NSMutableString stringWithString:@"welcome_login_anim_0"];
        [imageString appendString:[NSString stringWithFormat:@"%d",i]];
        [_loginImages addObject:[UIImage imageNamed:imageString]];
        
        imageString = [NSMutableString stringWithString:@"welcome_register_anim_0"];
        [imageString appendString:[NSString stringWithFormat:@"%d",i]];
        [_regImages addObject:[UIImage imageNamed:imageString]];
        
    }

    
    CGRect rectLogin = CGRectMake(70, 200, 70, 40);
    UIButton *buttonLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLogin setFrame:rectLogin];
//    [buttonLogin setTitle:@"login" forState:UIControlStateNormal];
//    buttonLogin.backgroundColor = [UIColor clearColor];
//    UIImageView *stillImage = [[UIImageView alloc]initWithImage:@"welcome_login_anim_01"];
    UIImage *welcomImage = [UIImage imageNamed:@"welcome_login_anim_01.png"];
    [buttonLogin setImage:welcomImage forState:UIControlStateNormal];
    buttonLogin.tag = 101;
    [buttonLogin addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonLogin];
    
    if(!_loginButtonView){
        _loginButtonView =[[UIImageView alloc]initWithFrame:rectLogin];
    }
    
    _loginButtonView.animationImages = _loginImages;
    [_loginButtonView setAnimationDuration:0.2f];
    [_loginButtonView setAnimationRepeatCount:1];
    [self.view addSubview:_loginButtonView];
    _loginButtonView.hidden = YES;
    
    CGRect rectReg = CGRectMake(310, 200, 70, 40);
    UIButton *buttonReg = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonReg setFrame:rectReg];
//    [buttonReg setTitle:@"BACK" forState:UIControlStateNormal];
//    buttonReg.backgroundColor = [UIColor clearColor];
    UIImage *regImage = [UIImage imageNamed:@"welcome_register_anim_01.png"];
    [buttonReg setImage:regImage forState:UIControlStateNormal];
    buttonReg.tag = 102;
    [buttonReg addTarget:self action:@selector(regButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonReg];
    
    if(!_regButtonView){
        _regButtonView = [[UIImageView alloc]initWithFrame:rectReg];
    }
    _regButtonView.animationImages = _regImages;
    [_regButtonView setAnimationDuration:0.5f];
    [_regButtonView setAnimationRepeatCount:1];
    [self.view addSubview:_regButtonView];
    _loginButtonView.hidden = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"AllreadyLogin" object:nil];
    [self setupViews];
	// Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyPrepareView:nil];
    [super viewDidUnload];
}



-(void)receiveNotification:(NSNotification*)note{
    
    UIAlertView* noteView = [[UIAlertView alloc] initWithTitle:nil message:@"Root receive a notification!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [noteView show];
    //    self pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>
    //    [noteView release];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"allreadyLogin" sender:self];
}

#pragma mark actions

- (void)loginButtonClicked:(id)sender{
    
    _loginButtonView.hidden = NO;
    [_loginButtonView startAnimating];
    //    [self performSegueWithIdentifier:@"Login" sender:self];
//    [self performSelectorOnMainThread:@selector(performLogin) withObject:nil waitUntilDone:NO];
    [self performSelector:@selector(performLogin) withObject:nil afterDelay:.1f];
}

- (void)performLogin{
//    sleep(1.8);
    [self performSegueWithIdentifier:@"Login" sender:self];
}

- (void)regButtonClicked:(id)sender{
    [self performSegueWithIdentifier:@"Register" sender:self];
}

@end
