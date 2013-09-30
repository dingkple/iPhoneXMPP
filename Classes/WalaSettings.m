//
//  WalaSettings.m
//  iPhoneXMPP
//
//  Created by King Kz on 13-9-10.
//
//

#import "WalaSettings.h"


@interface WalaSettings ()
@property (strong, nonatomic) UIView *mycardView;
@property (strong, nonatomic) CollapseClick *settingTable;

@end

@implementation WalaSettings

- (void)awakeFromNib{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"设置" image:nil tag:2];
    [item setFinishedSelectedImage:[UIImage imageNamed:@"BottomActionbarIcon5_1"]
       withFinishedUnselectedImage:[UIImage imageNamed:@"BottomActionbarIcon5_2"]];
    
    self.tabBarItem = item;
}

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
    self.view.frame = CGRectMake(0, 0, 480, 320);
    [self setupViews];
    
    
    _settingTable.CollapseClickDelegate = self;
    [_settingTable reloadCollapseClick];
    
    // If you want a cell open on load, run this method:
    [_settingTable openCollapseClickCellAtIndex:0 animated:NO];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Views

- (void) setupViews{
    
    UIImageView *topcover = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, 480, 59)];
    topcover.image = [UIImage imageNamed:@"topcover_Settingview"];
    [self.view addSubview:topcover];
    
    _settingTable = [[CollapseClick alloc]initWithFrame:CGRectMake(0, 59, 480, 700)];
    [self.view addSubview:_settingTable];
    
    _mycardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 480, 88)];
    _mycardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mycard_Settingview"]];
    
    
    
    
}



#pragma mark - Collapse Click Delegate

// Required Methods
-(int)numberOfCellsForCollapseClick {
    return 1;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"";
            break;
        default:
            return @"";
            break;
    }
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0:
            return _mycardView;
            break;            
        default:
            return nil;
            break;
    }
}

-(UIImage *)viewForTittleViewAtIndex:(int)index;{
    switch (index) {
        case 0:
            return [UIImage imageNamed:@"mycard_Settingview"];
            break;
            
        default:
            break;
    }
}



@end
