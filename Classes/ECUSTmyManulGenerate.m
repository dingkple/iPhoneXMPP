//
//  ECUSTmyManulGenerate.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-7-31.
//
//

#import "ECUSTmyManulGenerate.h"
#import "ECUSTRoundView.h"
//#import "ECUSTpurpleRoundView.h"
#import "KxMenu.h"

@interface ECUSTmyManulGenerate (){
    NSMutableArray *currentViews;
    BOOL hasBubble;
    UIView *myBubbleView;
}

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

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)setupViews{
    
    CGSize imageSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor colorWithRed:255 green:255 blue:255 alpha:0.6] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backGround_ManGenerate.png"]]];
    
    CGRect leftBkgRect = CGRectMake(0, 0, 82, 320);
    CGRect rightBkgRect = CGRectMake(480-82, 0, 82, 320);
    UIImage *leftBkgImg = [UIImage imageNamed:@"leftBackground_MGe"];
    UIImage *rightBkgImg = [UIImage imageNamed:@"rightBackground_MGe"];
    UIImageView *leftBkgImgview = [[UIImageView alloc]initWithImage:leftBkgImg];
    UIImageView *rightBkgImgview = [[UIImageView alloc]initWithImage:rightBkgImg];
    leftBkgImgview.frame = leftBkgRect;
    rightBkgImgview.frame = rightBkgRect;
    [self.view addSubview:leftBkgImgview];
    [self.view addSubview:rightBkgImgview];
    
    
    
    
    
//    CGRect leftButtonsRect = CGRectMake(0, 0, 60, 296);
//    UIView *leftButtons = [[ UIView alloc]initWithFrame: leftButtonsRect];
//    UIImage *leftImage = [UIImage imageNamed:@"leftButtons"];
//    [self.view addSubview:leftButtons];
//    [leftButtons setBackgroundColor:[UIColor colorWithPatternImage:leftImage]];
    for(int i=0 ; i<4; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        if(i<3){
            button.frame = CGRectMake(5, 75*i, 40, 48);
        }
        else
            button.frame = CGRectMake(0, 75*i, 40, 48);
        
        switch (i){
            case (0): [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
                [button setBackgroundImage:[UIImage imageNamed:@"cancenAll_MGe"] forState:UIControlStateNormal];
                break;
            case (1): [button addTarget:self action:@selector(addAlbum) forControlEvents:UIControlEventTouchUpInside];break;
            case (2): [button addTarget:self action:@selector(addBubble) forControlEvents:UIControlEventTouchUpInside];break;
            case (3): [button addTarget:self action:@selector(showAlbumNavi:) forControlEvents:UIControlEventTouchUpInside]; break;
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
            case (0): ;break;
            case (3):[button addTarget:self action:@selector(cancelCurrentView:) forControlEvents:UIControlEventTouchUpInside];
            
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
    _mySlectedGray = [UIColor colorWithRed:0.85 green:.85 blue:.85 alpha:1];
    _scrollView.contentInset = UIEdgeInsetsMake(30, 5, 5, 5);
    _scrollView.bounces = NO;
    for(int i=0; i<3 ;i++){
        UIView *albumView = [[UIView alloc]initWithFrame:CGRectMake(0, 220*i, 340, 200)];
        albumView.tag = 200+i;
        [albumView setBackgroundColor:_myGray];
        [_scrollView addSubview:albumView];
        if( i ==0){
            _selectedAlbumView = albumView;
            _selectedAlbumView.backgroundColor = _mySlectedGray;
        }
    }
    _scrollView.scrollEnabled = NO;
//    _scrollView.userInteractionEnabled = NO;
    _scrollView.canCancelContentTouches = YES;
    [_scrollView setContentOffset:CGPointMake(-5, -30) animated:NO];
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
    return NO;
}


- (void)addAlbum{
    UIView *background = [[UIView alloc]initWithFrame:_selectedAlbumView.frame];
    UIImage *image = [UIImage imageNamed:@"myAlbumbkg.png"];
    UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(handleRotate:)];
    [background addGestureRecognizer:rotateRecognizer];
    background.backgroundColor = [UIColor colorWithPatternImage:image];
    
    [_selectedAlbumView addSubview:background];
    if(hasBubble){
        [_selectedAlbumView bringSubviewToFront:myBubbleView];
    }
    [currentViews addObject:background];
    
}

- (void) handleRotate:(UIRotationGestureRecognizer*) recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}

- (void)cancelCurrentView:(id)sender{
    if([currentViews count]>0){
        UIView *current = [currentViews lastObject];
        [current removeFromSuperview];
        [currentViews removeObject:current];
    }
}

- (void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBubble{
    CGRect rect = CGRectMake(0, 0, 340, 200);
    ECUSTRoundView *bubbleView = [[ECUSTRoundView alloc]initWithFrame:rect];
    [bubbleView myInitWithFrame:rect];
    bubbleView.backgroundColor = [UIColor clearColor];
    bubbleView.tag = 601;
    bubbleView.alpha = 0.7;
    [_selectedAlbumView addSubview:bubbleView];
    [self.view bringSubviewToFront:bubbleView];
    [currentViews addObject:bubbleView];
    myBubbleView = bubbleView;
    hasBubble = YES;
}

- (void)showAlbumNavi:(UIButton *)sender{
    NSArray *menuItems =
    @[
      //
      [KxMenuItem menuItem:@"ACTION MENU"
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:@"1"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(slectAlbum1:)],
      
      [KxMenuItem menuItem:@"2"
                     image:[UIImage imageNamed:@"check_icon"]
                    target:self
                    action:@selector(slectAlbum2:)],
      
      [KxMenuItem menuItem:@"3"
                     image:[UIImage imageNamed:@"reload"]
                    target:self
                    action:@selector(slectAlbum3:)],
      
      //      [KxMenuItem menuItem:@"Search"
      //                     image:[UIImage imageNamed:@"search_icon"]
      //                    target:self
      //                    action:@selector(pushMenuItem:)],
      //
      //      [KxMenuItem menuItem:@"Go home"
      //                     image:[UIImage imageNamed:@"home_icon"]
      //                    target:self
      //                    action:@selector(pushMenuItem:)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void)slectAlbum1:(id)sender{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, 0-30) animated:YES];
    [self updateViews:0];
    
}

- (void)slectAlbum2:(id)sender{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, 220-30) animated:YES];
    [self updateViews:1];
    

}

- (void)slectAlbum3:(id)sender{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, 440-30) animated:YES];
    [self updateViews:2];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    if(!currentViews){
        currentViews = [[NSMutableArray alloc]init];
    };
    hasBubble = NO;
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
    
//    if((((int)scrollView.contentOffset.y)%220) >= 100){
////        NSLog(@"YES: %f", scrollView.contentOffset.y);
////        scrollView.contentOffset.y = (int)scrollView.contentOffset.y - 5)/220+220;
////        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,((int)scrollView.contentOffset.y)/220*220 + 220) animated:YES];
//        [self updateViews];
//    }
//    else {
////        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,((int)scrollView.contentOffset.y)/220*220) animated:YES];
//        [self updateViews];
//    }
    
    
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

- (void)updateViews:(int)selected{
//    if(_scrollView.contentOffset.y >= _previousPoint.y){
//        if((int)_scrollView.contentOffset.y%220 >120)
//            selected = (int)_scrollView.contentOffset.y/220+1;
//        else
//            selected = (int)_scrollView.contentOffset.y/220;
//    }
//    else {
//        if((int)_scrollView.contentOffset.y%220 >80){
//            selected = (int)_scrollView.contentOffset.y/220+1;
//        }
//        else {
//             selected = (int)_scrollView.contentOffset.y/220;
//        }
//    }
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
