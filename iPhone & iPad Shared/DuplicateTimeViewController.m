//
//  DuplicateTimeViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-16.
//
//

#import "DuplicateTimeViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ipad_AccountViewController.h"

@interface DuplicateTimeViewController ()

@end

@implementation DuplicateTimeViewController

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
//    if( [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] isEqualToString:@"7"])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initPoint];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
    
//    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
}

-(void)initPoint
{
    _titleLabelText.text = NSLocalizedString(@"VC_Duplicate To Date", nil);
    [_dateSelectedViewCancleBtn setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [_dateSelectedViewCancleBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [_dateSelectedViewCancleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_dateSelectedViewCancleBtn setTitleColor:[UIColor colorWithRed:0.f/255.f green:122.f/255.f blue:255.f/255.f alpha:1] forState:UIControlStateNormal];
    
    [_dateSelectedViewDoneBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [_dateSelectedViewDoneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    _dateSelectedViewDoneBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_dateSelectedViewDoneBtn.titleLabel setMinimumScaleFactor:0];
    [_dateSelectedViewDoneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_dateSelectedViewDoneBtn setTitleColor:[UIColor colorWithRed:0.f/255.f green:122.f/255.f blue:255.f/255.f alpha:1] forState:UIControlStateNormal];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"bar_267_40.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    titleLabel.text = @"Edit Account";
	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
 	self.navigationItem.titleView = titleLabel;
  
    
    [_dateSelectedViewCancleBtn addTarget:self action:@selector(cancleBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_dateSelectedViewDoneBtn addTarget:self action:@selector(doneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_datePickerView addTarget:self action:@selector(datePickerSelected:) forControlEvents:UIControlEventValueChanged];
    
    //不能使用自己进行设置位置，因为这是addview进来的，不知道为什么
//    dateSelectedView.frame = CGRectMake((self.view.frame.size.width-267)/2, 100 , 267, 291);
    
}


-(void)datePickerSelected:(id)sender{
    [self.delegate setDuplicateDateDelegate:self.datePickerView.date];
}

-(void)cancleBtnPressed:(id)sender{
    [self.delegate setDuplicateGoOnorNotDelegate:NO];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
}

static void extracted(DuplicateTimeViewController *object) {
    [object.delegate setDuplicateGoOnorNotDelegate:YES];
}

-(void)doneBtnPressed:(id)sender{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"02_TRANS_DUPL"];
    
    extracted(self);
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
