//
//  ipad_RepCashflowFilterViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-20.
//
//

#import "ipad_RepCashflowFilterViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "ipad_PDFPreviewController.h"
#import "SetDateRangeViewController_iPad.h"

@interface ipad_RepCashflowFilterViewController ()

@end

@implementation ipad_RepCashflowFilterViewController
@synthesize     cellType,cellDateRange,cellDateColumn;
@synthesize     lblDateRange,lblDateColumn;
@synthesize     startDate,endDate;
@synthesize     cashDateTypeString;
@synthesize allBtn,outFlowBtn,inFlowBtn;
@synthesize typeLabelText,dateRangeLabelText,columnLabelText;
@synthesize generateBtn;
@synthesize myTableView;

#pragma mark - Customer API
-(void)setViewControlValue
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    allBtn.selected = YES;
    outFlowBtn.selected = NO;
    inFlowBtn.selected = NO;
    [allBtn addTarget:self action:@selector(typeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [outFlowBtn addTarget:self action:@selector(typeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [inFlowBtn addTarget:self action:@selector(typeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if(![cashDateTypeString isEqualToString:@"Custom"])
    {
        self.startDate = [appDelegate.epnc getStartDate:cashDateTypeString];
        self.endDate = [appDelegate.epnc getEndDate:self.startDate withDateString:cashDateTypeString];
    }
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:NSDateFormatterMediumStyle];
	[outputFormatter setTimeStyle:NSDateFormatterNoStyle];
 	self.lblDateRange.text = [NSString stringWithFormat:@"%@ ~ %@",[outputFormatter stringFromDate:self.startDate],[outputFormatter stringFromDate: self.endDate]];
    
}

-(void)typeBtnPressed:(UIButton *)sender
{
    allBtn.selected = NO;
    outFlowBtn.selected=NO;
    inFlowBtn.selected=NO;
    
    if (sender.tag==1) {
        allBtn.selected = YES;
    }
    else if (sender.tag==2)
        outFlowBtn.selected = YES;
    else
        inFlowBtn.selected = YES;
}

-(IBAction)generateReportBtn:(id)sender;
{
    ipad_PDFPreviewController *pdfPreviewController =[[ipad_PDFPreviewController alloc] initWithNibName:@"ipad_PDFPreviewController" bundle:nil];
    if(allBtn.selected)
    {
        pdfPreviewController.pdfType =@"ALLFLOW";
        
    }
    else     if(outFlowBtn.selected)
    {
        pdfPreviewController.pdfType =@"OUTFLOW";
        
    }
    else     if(inFlowBtn.selected)
    {
        pdfPreviewController.pdfType=@"INFLOW";
        
    }
    pdfPreviewController.repCashFlowFilterVC = self;
    [self.navigationController pushViewController:pdfPreviewController  animated:YES];
    

}

-(void)initNavBarStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexible.width = -11;
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn1.frame = CGRectMake(0, 0, 30, 30);
	[backBtn1 setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backBtn1];
	
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	titleLabel.text = NSLocalizedString(@"VC_Flow(PDF)", nil);
	self.navigationItem.titleView = 	titleLabel;
}


-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavBarStyle];
    cashDateTypeString =@"This Month";
    //cashDateTypeString =@"Last 12 Months";
    
    lblDateColumn.text = NSLocalizedString(@"VC_Week", nil);
    typeLabelText.text = NSLocalizedString(@"VC_Type", nil);
    dateRangeLabelText.text = NSLocalizedString(@"VC_DateRange", nil);
    columnLabelText.text = NSLocalizedString(@"VC_Column", nil);
    
    [allBtn setTitle:NSLocalizedString(@"VC_All", nil) forState:UIControlStateNormal];
    [outFlowBtn setTitle:NSLocalizedString(@"VC_Out Flow", nil) forState:UIControlStateNormal];
    [inFlowBtn setTitle:NSLocalizedString(@"VC_In Flow", nil) forState:UIControlStateNormal];
    [generateBtn setTitle:NSLocalizedString(@"VC_Run Report", nil) forState:UIControlStateNormal];
    
    cellType.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    cellDateRange.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    cellDateColumn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    cellDateColumn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b3_add_transactions.png"]];

}

-(void)viewWillAppear:(BOOL)animated
{

    
    
    [super viewWillAppear:animated];
    [self setViewControlValue];

    [myTableView reloadData];
}

#pragma mark TableView Delegate and DataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
//--------在IOS7中 cell的背景颜色会被默认成白色，用这个代理来去掉白色背景
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [cell setBackgroundColor:[UIColor clearColor]];
//}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   	if (indexPath.row == 0)
    {
        return cellType;
    }
    else if(indexPath.row ==1)
    {
        return cellDateRange;
        
    }
    
    return cellDateColumn;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1)
    {
        SetDateRangeViewController_iPad *setDateRangeViewController = [[SetDateRangeViewController_iPad alloc] initWithStyle:UITableViewStylePlain];
        setDateRangeViewController.iRepCashflowFilterViewController = self;
        setDateRangeViewController.moduleString =@"REPORT_CASHFLOW";
        setDateRangeViewController.dateRangeString = cashDateTypeString;
        [self.navigationController pushViewController:setDateRangeViewController animated:YES];
        
    }
    else if(indexPath.row ==2)
    {
        UIActionSheet *actionSheet= [[UIActionSheet alloc]
                                     initWithTitle:nil
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"VC_Week", nil),NSLocalizedString(@"VC_Month", nil),
                                     nil];
        
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        UITableViewCell *selectedCell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        CGPoint point1 = [myTableView convertPoint:selectedCell.frame.origin toView:self.view];
        [actionSheet showFromRect:CGRectMake(point1.x,point1.y, selectedCell.frame.size.width,selectedCell.frame.size.height) inView:self.view animated:YES];
        
        
        appDelegate.appActionSheet = actionSheet;
        
         
        
    }
}
#pragma mark UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
	{
		lblDateColumn.text =NSLocalizedString(@"VC_Week", nil);
	}
 	else  if(buttonIndex == 1)
	{
		lblDateColumn.text =NSLocalizedString(@"VC_Month", nil);
		
	}
    
    [myTableView reloadData];
    
 	return ;
	
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
