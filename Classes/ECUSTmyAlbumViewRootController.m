//
//  ECUSTmyAlbumViewRootController.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-30.
//
//

#import "ECUSTmyAlbumViewRootController.h"

@interface ECUSTmyAlbumViewRootController ()

@end

@implementation ECUSTmyAlbumViewRootController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupViews{
    self.view.frame = CGRectMake(0, 0, 480, 320);
    CGRect buttonAutoRect = CGRectMake(90, 150, 130, 30);
    CGRect buttonManulRect = CGRectMake(260, 150, 130, 30);
    
    
    CGSize imageSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor colorWithRed:255 green:255 blue:255 alpha:0.6] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UIImage *backGroundImage = [UIImage imageNamed:@"myAlbumbkg.png"];
    UIImageView *backGround = [[UIImageView alloc]initWithImage:backGroundImage];
    [backGround setAlpha:0.7];
    backGround.frame = self.view.frame;
    [self.view addSubview:backGround];
    
    
    UIButton *buttonForAutoGene = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonForAutoGene.frame = buttonAutoRect;
    [buttonForAutoGene setBackgroundColor:[UIColor greenColor]];
    [buttonForAutoGene setTitle:@"AUTO" forState:UIControlStateNormal];
    [buttonForAutoGene setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
    [self.view addSubview:buttonForAutoGene];
    
    
    UIButton *buttonForManulGene = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonForManulGene.frame = buttonManulRect;
    [buttonForManulGene setBackgroundColor:[UIColor greenColor]];
    [buttonForManulGene setTitle:@"Manul" forState:UIControlStateNormal];
    [buttonForManulGene setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
    [buttonForManulGene addTarget:self action:@selector(prepareToManulGene) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonForManulGene];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareToManulGene{
    [self performSegueWithIdentifier:@"manulGenerate" sender:self];
}

@end
