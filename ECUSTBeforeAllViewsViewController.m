//
//  ECUSTBeforeAllViewsViewController.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-6-30.
//
//

#import "ECUSTBeforeAllViewsViewController.h"

@interface ECUSTBeforeAllViewsViewController ()

@end

@implementation ECUSTBeforeAllViewsViewController


//allreadyLogin
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

-(void)receiveNotification:(NSNotification*)note{
    
    UIAlertView* noteView = [[UIAlertView alloc] initWithTitle:nil message:@"Root receive a notification!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [noteView show];
    //    self pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>
    //    [noteView release];
    [self.navigationController performSegueWithIdentifier:@"allreadyLogin" sender:self];
}

@end
