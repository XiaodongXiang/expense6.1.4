//
//  ipad_ReportRootViewController.m
//  PocketExpense
//
//  Created by appxy_dev on 14-5-4.
//
//

#import "ipad_ReportRootViewController.h"
#import "ipad_ReportCashFlowViewController.h"
#import "ipad_ReportCategotyViewController.h"
#import "ipad_ReportComparisonViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"

@interface ipad_ReportRootViewController ()


@end

@implementation ipad_ReportRootViewController
@synthesize cashFlowVC,categoryVC;
//@synthesize comparisonVC;
@synthesize topScrollView,rootScrollView;

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

    //添加三个subview
    if (categoryVC == nil) {
        categoryVC=[[ipad_ReportCategotyViewController alloc]initWithNibName:@"ipad_ReportCategotyViewController" bundle:nil];
        
        cashFlowVC=[[ipad_ReportCashFlowViewController alloc]initWithNibName:@"ipad_ReportCashFlowViewController" bundle:nil];
        
        [SVGloble shareInstance].globleWidth = 960*2; //屏幕宽度
//        NSLog(@"[SVGloble shareInstance].globleWidth:%f",[SVGloble shareInstance].globleWidth);
        [SVGloble shareInstance].globleHeight = 704;  //屏幕高度（无顶栏）
        [SVGloble shareInstance].globleAllHeight = 704;  //屏幕高度（有顶栏）
        
        topScrollView = [SVTopScrollView shareInstance];
        rootScrollView = [SVRootScrollView shareInstance];
        rootScrollView.scrollEnabled = NO;
        topScrollView.nameArray = @[@"Report View", @"Cash Flow"];
        
        topScrollView.imageNameArray=@[@"ipad_btn_category.png",@"ipad_btn_cash_flow.png"];
        
        topScrollView.imageSelNameArray=@[@"ipad_btn_category_sel.png",@"ipad_btn_cash_flow_sel.png"];
        
        rootScrollView.viewNameArray = @[@"ipad_btn_category_sel.png", @"ipad_btn_cash_flow_sel.png"];
        
        rootScrollView.viewArray=@[categoryVC,cashFlowVC];
        
        [self.view addSubview:topScrollView];
        [self.view addSubview:rootScrollView];
        
        [topScrollView initWithImageButtons];
        [rootScrollView initWithViews];
    }
    [rootScrollView loadData];


    
//    comparisonVC=[[ipad_ReportComparisonViewController alloc]initWithNibName:@"ipad_ReportComparisonViewController" bundle:nil];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)reFlashTableViewData
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    [appDelegate_iPad.mainViewController.iReportRootViewController.categoryVC hidePopView];
    appDelegate_iPad.mainViewController.iReportRootViewController.cashFlowVC.dateRangeSelView.hidden = YES;
    [rootScrollView loadData];
}

-(void)refleshUI
{
    [self reFlashTableViewData];
}

@end
