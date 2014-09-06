//
//  WalaTextEditVC.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-9-11.
//
//

#import "WalaTextEditVC.h"



#define INPUT_HEIGHT 40.0f

@interface WalaTextEditVC ()

@end

@implementation WalaTextEditVC

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews{
    CGSize size = CGSizeMake(100, 100);
    
    
    CGRect inputFrame = CGRectMake(self.view.frame.size.width/2 - 100.f, 30.f , 200.f, 150.f);
    self.inputView = [[UITextView alloc]initWithFrame:inputFrame];
    self.inputView.delegate = self.rootVC;
    self.inputView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.inputView];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmBtn.backgroundColor = [UIColor whiteColor];
    [confirmBtn setTitle:@"Done" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setTextColor:[UIColor blackColor]];
    confirmBtn.frame = CGRectMake(self.view.frame.size.width/2 - 30, 190, 60, 30);
    [confirmBtn addTarget:self action:@selector(confirmEditing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}



- (void)endEditing{
    [self.inputView resignFirstResponder];
}


- (void)confirmEditing {
    [self.textDelegate setText:self.inputView.text];
}








@end
