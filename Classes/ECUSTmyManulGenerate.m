//
//  ECUSTmyManulGenerate.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-31.
//
//

#import "ECUSTmyManulGenerate.h"
#import "ECUSTRoundView.h"
#import "ECUSTpurpleRoundView.h"

@interface ECUSTmyManulGenerate ()

@property UIScrollView *scrollView;
@property UIView *selectedAlbumView;
@property UIColor *myGray;
@property UIColor *mySlectedGray;
@property CGPoint previousPoint;


@end

@implementation ECUSTmyManulGenerate

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)setupViews{
    
    CGSize imageSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor colorWithRed:255 green:255 blue:255 alpha:0.6] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    CGRect leftButtonsRect = CGRectMake(0, 0, 60, 296);
    UIView *leftButtons = [[ UIView alloc]initWithFrame: leftButtonsRect];
    UIImage *leftImage = [UIImage imageNamed:@"leftButtons"];
    [self.view addSubview:leftButtons];
    [leftButtons setBackgroundColor:[UIColor colorWithPatternImage:leftImage]];
    for(int i=0 ; i<4; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        if(i<3){
            button.frame = CGRectMake(0, 75*i, 60, 75);
        }
        else
            button.frame = CGRectMake(0, 75*i, 60, 81);
        
        switch (i){
            case (0): [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];break;
            case (1): break;
            case (2): break;
            case (3): [button addTarget:self action:@selector(addBubble) forControlEvents:UIControlEventTouchUpInside];break;
        }
    [button setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
    [self.view addSubview:button];

    }
    
    CGRect rightButtonsRect = CGRectMake(420, 0, 60, 298);
    UIView *rightButtonsRectView = [[UIView alloc]initWithFrame:rightButtonsRect];
    UIImage *rightImage = [UIImage imageNamed:@"rightButtons"];
    [rightButtonsRectView setBackgroundColor:[UIColor colorWithPatternImage:rightImage]];
     [self.view addSubview:rightButtonsRectView];
    for(int i=0; i<5 ; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 110+i;
        if(i<4){
           button.frame = CGRectMake(420, 55*i, 60, 55);
        }
        else {
            button.frame = CGRectMake(420, 55*i, 60, 78);
        }
        
        switch (i){
            case (0): ;
            
        }
        
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
        [self.view addSubview:button];
    }
    
    CGRect titleViewRect = CGRectMake(60, 0, 360, 30);
    CGRect titleLabelRect = CGRectMake(130, 0, 100, 30);
    UIView *titleView = [[UIView alloc] initWithFrame:titleViewRect];
    [titleView setBackgroundColor:[UIColor blackColor]];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:titleLabelRect];
    titleLabel.text = @"album Label";
    titleLabel.textColor = [UIColor blueColor];
    [titleLabel setBackgroundColor:[UIColor blackColor]];
    [titleView addSubview:titleLabel];
    [self.view addSubview:titleView];
    
    CGRect backgroundGrayRect = CGRectMake(60, 30, 360, 300);
    UIView *backgroundGray = [[UIView alloc] initWithFrame:backgroundGrayRect];
    [backgroundGray setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:backgroundGray];
    
    CGRect backgroundWhiteRect = CGRectMake(65, 35, 350, 300);
    _scrollView = [[UIScrollView alloc] initWithFrame:backgroundWhiteRect];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(340, 750);
    [_scrollView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_scrollView];
    
    
    _myGray = [UIColor colorWithRed:0.91 green:.91 blue:.91 alpha:1];
    _mySlectedGray = [UIColor colorWithRed:0.3 green:.3 blue:.3 alpha:1];
    _scrollView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _scrollView.bounces = NO;
    for(int i=0; i<3 ;i++){
        UIView *albumView = [[UIView alloc]initWithFrame:CGRectMake(0, 220*i, 340, 200)];
        albumView.tag = 200+i;
        [albumView setBackgroundColor:_myGray];
        [_scrollView addSubview:albumView];
    }
}


- (void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBubble{
    
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

#pragma mark ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint temp = scrollView.contentOffset;
    int temp2 = ((int)scrollView.contentOffset.y )/220;
    
    if((((int)scrollView.contentOffset.y)%220) >= 100){
//        NSLog(@"YES: %f", scrollView.contentOffset.y);
//        scrollView.contentOffset.y = (int)scrollView.contentOffset.y - 5)/220+220;
//        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,((int)scrollView.contentOffset.y)/220*220 + 220) animated:YES];
        [self updateViews];
    }
    else {
//        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,((int)scrollView.contentOffset.y)/220*220) animated:YES];
        [self updateViews];
    }
    
    
//    int selected = temp2;
//    _selectedAlbumView = [self.view viewWithTag:200+selected];
//    _selectedAlbumView.backgroundColor = _mySlectedGray;
//    UIView *view;
//    for(int i=0; i<3; i++){
//        view = [self.view viewWithTag:200+selected];
//        if(i!=selected){
//            view.backgroundColor = _myGray;
//        }
//        else {
//            view.backgroundColor = _mySlectedGray;
//            _selectedAlbumView = view;
//        }
//    }
//    scrollView.delegate
}

- (void)updateViews{
    int selected ;
    if(_scrollView.contentOffset.y >= _previousPoint.y){
        if((int)_scrollView.contentOffset.y%220 >120)
            selected = (int)_scrollView.contentOffset.y/220+1;
        else
            selected = (int)_scrollView.contentOffset.y/220;
    }
    else {
        if((int)_scrollView.contentOffset.y%220 >80){
            selected = (int)_scrollView.contentOffset.y/220+1;
        }
        else {
             selected = (int)_scrollView.contentOffset.y/220;
        }
    }
    UIView *view;
    for(int i=0; i<3; i++){
        view = [self.view viewWithTag:200+i];
        if(i!=selected){
            view.backgroundColor = _myGray;
        }
        else {
            view.backgroundColor = _mySlectedGray;
            _selectedAlbumView = view;
        }
    }
    _previousPoint = _scrollView.contentOffset;
    
}

@end
