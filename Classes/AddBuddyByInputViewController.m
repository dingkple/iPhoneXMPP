//
//  AddBuddyByInputViewController.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-8-27.
//
//

#import "AddBuddyByInputViewController.h"

@interface AddBuddyByInputViewController ()

@end

@implementation AddBuddyByInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        [self setupViews];
        // Custom initialization
        [self setupViews];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.jidTextField.delegate = self.rootVC;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews{
    self.addBuddyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.addBuddyBtn.backgroundColor = [UIColor redColor];
    self.addBuddyBtn.titleLabel.text = @"just you";
    [self.view addSubview:self.addBuddyBtn];
    self.addBuddyBtn.frame = CGRectMake(95, 80, 100, 30);
    [self.view bringSubviewToFront:self.addBuddyBtn];
    
    
}




#pragma mark TextfieldDelegate


@end
