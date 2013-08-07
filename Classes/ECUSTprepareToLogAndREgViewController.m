//
//  ECUSTprepareToLogAndREgViewController.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-29.
//
//

#import "ECUSTprepareToLogAndREgViewController.h"

@interface ECUSTprepareToLogAndREgViewController ()

@end

@implementation ECUSTprepareToLogAndREgViewController


-(void)viewWillAppear:(BOOL)animated{
    animated =YES;
    self.myPrepareView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1.loginAndReg.png"]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"AllreadyLogin" object:nil];
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

@end
