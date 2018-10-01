//
//  RepCashflowFilterViewController.m
//  PocketExpense
//
//  Created by MV on 11-12-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RepCashflowFilterViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "SetDateRangeViewController_iPhone.h"
#import "PDFPreviewController.h"

#import "AppDelegate_iPhone.h"


@implementation RepCashflowFilterViewController
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
     
    PDFPreviewController *pdfPreviewController =[[PDFPreviewController alloc] initWithNibName:@"PDFPreviewController" bundle:nil];
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
    [self.navigationController.navigationBar doSetNavigationBar];
	self.navigationItem.title = NSLocalizedString(@"VC_Flow(PDF)", nil);
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
    generateBtn.layer.cornerRadius=5;
    generateBtn.layer.masksToBounds=YES;
    
    [self initPoint];

 }

-(void)initPoint
{
    
    self.typeLineHigh.constant = EXPENSE_SCALE;
    self.dateLineHigh.constant = EXPENSE_SCALE;
    self.columnLineHigh.constant = EXPENSE_SCALE;
//    [cellType setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
//    [cellDateRange setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
//    [cellDateColumn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j2_320_44.png"]]];
    

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
    if (indexPath.row == 1)
    {	
        SetDateRangeViewController_iPhone *setDateRangeViewController = [[SetDateRangeViewController_iPhone alloc] initWithStyle:UITableViewStylePlain];
        setDateRangeViewController.repCashflowFilterViewController = self;
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

       [actionSheet showInView:self.view];
       PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
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
		lblDateColumn.text =NSLocalizedString(@"VC_Month", nil);;
		
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
