//
//  ECUSTmyRootViewController.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-29.
//
//

#import "ECUSTmyRootViewController.h"

@interface ECUSTmyRootViewController (){
    BOOL isAllradyLogin;
}

@end

@implementation ECUSTmyRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"AllreadyLogin" object:nil];
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    animated = YES;
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"1.loginAndReg.png"]]];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1.loginAndReg.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveNotification:(NSNotification*)note{
    
    UIAlertView* noteView = [[UIAlertView alloc] initWithTitle:nil message:@"Root receive a notification!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [noteView show];
//    self pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>
    //    [noteView release];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController performSegueWithIdentifier:@"allreadyLogin" sender:self];
}

@end
