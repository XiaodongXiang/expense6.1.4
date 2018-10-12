//
//  ipad_BudgetViewController.m
//  PocketExpense
//
//  Created by Tommy on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ipad_BudgetViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "BudgetCountClass.h"
#import "ipad_TranscactionQuickEditViewController.h"
#import "AppDelegate_iPad.h"

#import "BudgetTransfer.h"
#import "BudgetDetailClassType.h"
#import "TransactionRule.h"
#import "ClearCusBtn.h"
#import "ipad_BudgetCell_New.h"
#import "ipad_BudgetTransactionCell.h"

#import "ipad_TransacationSplitViewController.h"
#import "ipad_BudgetIntroduceViewController.h"
#import "ipad_BudgetSettingViewController.h"
#import "ipad_TranscactionQuickEditViewController.h"
#import "ipad_TransferViewController_NS.h"
#import "budgetBar_iPad.h"



#define BUDGETBAR_WITH  550
#define SPENTIMAGE_LEFTX    48
#define SPENT_LEFT_ARC_LEFTX    40
#define BUDGETBAR_ORIGNY    80
#define BUDGETBAR_HIGH  16
#define SPENTIMAGE_WITH 534

@interface ipad_BudgetViewController ()<ADEngineControllerBannerDelegate>
{
    budgetBar_iPad *topBudgetBar;
    ipad_BudgetCell_New *formerCell;
}
@property (weak, nonatomic) IBOutlet UIView *adBannerView;
@property(nonatomic, strong)ADEngineController* adBanner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;

@end

@implementation BudgetHistoryCount
@synthesize dateString;
@synthesize totalAmount;
@synthesize rolloverAmount;
@synthesize availableAmount;
@synthesize usedAmount;
@synthesize incomeAmount;
@synthesize dateType;
@synthesize bi;

@end

@implementation ipad_BudgetViewController
@synthesize leftTableView,timeBtn,dateBtntateImageView,titleStringLabel,availLabel,leftorSpentLabel,spentImage,spentImageLeftArc,spentImageRightArc,rightTableView,noRecordViewLeft,noRecordViewRight;
@synthesize dateArray,dateRangeSelView,dataSelBtn,dataSelBtn1,dataSelBtn2,dataSelBtn3,dataSelBtn4,dataSelBtn5,selectedBtnInterger;
@synthesize budgetArray,transactionArray,indexOfBudgetArray,deleteIndex,monthandYearDateFormatter,dateFormatter,startDate,endDate;
@synthesize hasBudget;
@synthesize todayView;
@synthesize noBudgetRecordLabelText,noTransactionRecordLabelText;


#pragma mark Life Style
- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self initPoint];
    [self reFlashTableViewData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self getAllBudgetData];
    if (!hasBudget)
    {
        
        _budgetSettingViewController = [[ipad_BudgetSettingViewController alloc]initWithNibName:@"ipad_BudgetSettingViewController" bundle:nil];
        _budgetSettingViewController.budgetViewController = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_budgetSettingViewController];
        AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        appDelegate1.mainViewController.popViewController = navigationController ;
        [appDelegate1.mainViewController presentViewController:navigationController animated:YES completion:nil];
        navigationController.view.superview.autoresizingMask =
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //    calendarContainView.height = 674;
    
    if (!appDelegate.isPurchased) {
        if(!_adBanner) {
            
            _adBanner = [[ADEngineController alloc] initLoadADWithAdPint:@"PE2105 - iPad - Banner - Budget" delegate:self];
            [self.adBanner showBannerAdWithTarget:self.adBannerView rootViewcontroller:self];
        }
    }else{
        self.adBannerView.hidden = YES;
        self.bottomConstant.constant = 0;
    }
    
    
    
}

#pragma mark - ADEngineControllerBannerDelegate
- (void)aDEngineControllerBannerDelegateDisplayOrNot:(BOOL)result ad:(ADEngineController *)ad {
    if (result) {
        self.adBannerView.hidden = NO;
        self.bottomConstant.constant = 50;
    }else{
        self.adBannerView.hidden = YES;
        self.bottomConstant.constant = 0;

    }
}

-(void)refleshUI
{
    [self reFlashTableViewData];
}

-(void)changeBudgetRepeatStyle
{
    [self setStartDateandEndDate];
    [self reSetDateRangeViewBtnStyle];
    dataSelBtn5.selected = YES;
    [self reFlashTableViewData];
}
-(void)initPoint
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 566, 30)];
    //设置rightTableview中的header
    _headView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    //budget name label
    currentBudgetNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 300, 17)];
    [currentBudgetNameLabel setTextColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1]];
    [currentBudgetNameLabel setTextAlignment:NSTextAlignmentLeft];
    [currentBudgetNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [_headView addSubview:currentBudgetNameLabel];

    //spent label
    spentLabel = [[UILabel alloc]initWithFrame:CGRectMake(566-15-200, 5, 200, 20)];
    [spentLabel setTextColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1]];
    spentLabel.textAlignment=NSTextAlignmentRight;
    [_headView addSubview:spentLabel];


    self.todayLabel.text = [NSLocalizedString(@"VC_Today", nil)uppercaseString];
    noBudgetRecordLabelText.text = NSLocalizedString(@"VC_You have no budgets setup. You can create them by tapping the \"Adjust\" button.", nil);
    noTransactionRecordLabelText.text = NSLocalizedString(@"VC_ipadBudgetDetailNotes", nil);
    
    monthandYearDateFormatter = [[NSDateFormatter alloc]init];
    [monthandYearDateFormatter setDateFormat:@"MMM yyyy"];
    
    dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    dateFormatterWithOutYear = [[NSDateFormatter alloc]init];
    [dateFormatterWithOutYear setDateFormat:@"MMM dd"];
    
    [availLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
    [_topViewLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
    
    //date seleted btn
    dateRangeSelView.hidden = YES;
    selectedBtnInterger = 0;
    
    [timeBtn addTarget:self action:@selector(timeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [dataSelBtn addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dataSelBtn1 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dataSelBtn2 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dataSelBtn3 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dataSelBtn4 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dataSelBtn5 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_preMonthBtn addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_latterMonthBtn addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _preMonthBtn.tag=0;
    _latterMonthBtn.tag=1;

    
    budgetArray = [[NSMutableArray alloc]init];
    transactionArray = [[NSMutableArray alloc]init];
    dateArray = [[NSMutableArray alloc]init];

    //budget循环的模式
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *tmpBudgetString = [userDefault stringForKey:@"BudgetRepeatType"];
    if ([tmpBudgetString isEqualToString:@"Weekly"])
    {
        budgetRepeatType = @"Weekly";
    }
    else
    {
        budgetRepeatType = @"Monthly";
    }
    
    [self setStartDateandEndDate];
    dataSelBtn5.selected = YES;


    
    [dataSelBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [dataSelBtn1 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [dataSelBtn2 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [dataSelBtn3 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [dataSelBtn4 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [dataSelBtn5 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    
    [dataSelBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [dataSelBtn1 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [dataSelBtn2 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [dataSelBtn3 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [dataSelBtn4 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [dataSelBtn5 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    
    [dataSelBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [dataSelBtn1 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [dataSelBtn2 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [dataSelBtn3 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [dataSelBtn4 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [dataSelBtn5 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    
    //未选中时候的颜色
    [dataSelBtn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [dataSelBtn1 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [dataSelBtn2 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [dataSelBtn3 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [dataSelBtn4 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [dataSelBtn5 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    
    [dataSelBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [dataSelBtn1 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [dataSelBtn2 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [dataSelBtn3 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [dataSelBtn4 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [dataSelBtn5 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    
    //dataSelBtn textLabel Fram
    [dataSelBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [dataSelBtn1 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [dataSelBtn2 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [dataSelBtn3 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [dataSelBtn4 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [dataSelBtn5 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    
    _dateLabel.text=NSLocalizedString(@"VC_Date", nil);
    _payeeLabel.text=NSLocalizedString(@"VC_Payee", nil);
    _amountLabel.text=NSLocalizedString(@"VC_Amount", nil);
    
    indexOfBudgetArray =0;
    _topLineHeight.constant=EXPENSE_SCALE;

    
    hasBudget = NO;
    _todayLabel.adjustsFontSizeToFitWidth = YES;
    [_todayLabel setMinimumScaleFactor:0];
    
    [_adjustBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1]] forState:UIControlStateNormal];
    [_adjustBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:84/255.0 green:173/255.0 blue:217/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [_adjustBtn setTitle:NSLocalizedString(@"VC_Adjust", nil) forState:UIControlStateNormal];
    [_adjustBtn addTarget:self action:@selector(setupBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    _adjustBtn.layer.cornerRadius=6;
    _adjustBtn.layer.masksToBounds=YES;
    
    [_transferBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1]] forState:UIControlStateNormal];
    [_transferBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:84/255.0 green:173/255.0 blue:217/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [_transferBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1]]  forState:UIControlStateDisabled];
    [_transferBtn setTitle:NSLocalizedString(@"VC_Transfer", nil) forState:UIControlStateNormal];
    [_transferBtn addTarget:self action:@selector(transferBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    _transferBtn.layer.cornerRadius=6;
    _transferBtn.layer.masksToBounds=YES;
    
    _middleLineWidth.constant=EXPENSE_SCALE;
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)setRightPartBudgetNameandOtherInformation
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //budget name
    double totalExpense = 0;
    double budgetTotalAmount = 0;
    if([budgetArray count]>0)
    {
        BudgetCountClass *bcc = (BudgetCountClass *)[budgetArray objectAtIndex:indexOfBudgetArray];
        currentBudgetNameLabel.text = bcc.bt.category.categoryName;
        totalExpense = bcc.btTotalExpense;
        budgetTotalAmount = [((BudgetItem *)[[bcc.bt.budgetItems allObjects]lastObject]).amount doubleValue];
    }
    
    //amount
    NSString *spentString=nil;
    if (totalExpense<100000)//100k-1
    {
        spentString =[NSString stringWithFormat:@"%@ ",[appDelegate.epnc formatterStringWithOutPositive:totalExpense]];
        //        spentString = [appDelegate.epnc formatterStringWithOutCurrency:totalExpense];
        
    }
    else if (totalExpense<100000000)//100k --- 100m-1
    {
        spentString =[NSString stringWithFormat:@"%.0f k", totalExpense/1000];
        spentString = [NSString stringWithFormat:@"%@%@ ",appDelegate.epnc.currenyStr,spentString];
    }
    else if(totalExpense < 100000000000)//100m -- 100b-1
    {
        spentString =[NSString stringWithFormat:@"%.0f m", totalExpense/1000000.0];
        spentString = [NSString stringWithFormat:@"%@%@ ",appDelegate.epnc.currenyStr,spentString];
        
    }
    else{
        spentString =[NSString stringWithFormat:@"%.0f b", totalExpense/1000000000.0];
        spentString = [NSString stringWithFormat:@"%@%@ ",appDelegate.epnc.currenyStr,spentString];
        
    }
    
    
    NSString *totalString;
    if (budgetTotalAmount<100000)//100k-1
    {
        totalString =[NSString stringWithFormat:@"/ %@",[appDelegate.epnc formatterStringWithOutPositive:budgetTotalAmount]];
        //        totalString = [appDelegate.epnc formatterStringWithOutCurrency:budgetTotalAmount];
        
    }
    else if (budgetTotalAmount<100000000)//100k --- 100m-1
    {
        totalString =[NSString stringWithFormat:@"%.0f k", budgetTotalAmount/1000.0];
        totalString = [NSString stringWithFormat:@"/ %@%@",appDelegate.epnc.currenyStr,totalString];
        
    }
    else if(budgetTotalAmount < 100000000000)//100m -- 100b-1
    {
        totalString =[NSString stringWithFormat:@"%.0f m", budgetTotalAmount/1000000];
        totalString = [NSString stringWithFormat:@"/ %@%@",appDelegate.epnc.currenyStr,totalString];
        
    }
    else
    {
        totalString =[NSString stringWithFormat:@"%.0f m", budgetTotalAmount/1000000000];
        totalString = [NSString stringWithFormat:@"/ %@%@",appDelegate.epnc.currenyStr,totalString];
        
    }
    
    //设置字体的颜色
    NSUInteger spStrLength=[spentString length];
    NSUInteger tbStrLength=[totalString length];
    
    NSRange spStrRange=NSMakeRange(0, spStrLength);
    NSRange tbRange=NSMakeRange(spStrLength, tbStrLength);
    
    NSString *allCompentsStr=[NSString stringWithFormat:@"%@%@",spentString,totalString];
    //spent
    NSMutableAttributedString *acAttributeStr=[[NSMutableAttributedString alloc]initWithString:allCompentsStr];
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (totalExpense == 0) {
        [acAttributeStr addAttribute:NSForegroundColorAttributeName value:[appDelegate_iPhone.epnc getAmountGrayColor] range:spStrRange];
    }
    else if (totalExpense < budgetTotalAmount) {
        [acAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:54.f/255.f green:193.f/255.f blue:250.f/255.f alpha:1] range:spStrRange];
    }
    else
        [acAttributeStr addAttribute:NSForegroundColorAttributeName value:[appDelegate.epnc getAmountRedColor] range:spStrRange];
    [acAttributeStr addAttribute:NSFontAttributeName value:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13] range:spStrRange];
    
    //设置后半截文字的颜色
    [acAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:166/255.f green:166/255.f blue:166/255.f alpha:1] range:tbRange ];
    [acAttributeStr addAttribute:NSFontAttributeName value:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13] range:tbRange];
    spentLabel.attributedText =acAttributeStr;
    [spentLabel layoutIfNeeded];
    
    if ([budgetArray count]<=1) {
        _transferBtn.enabled = NO;
    }
    else
    {
        _transferBtn.enabled = YES;

    }
    [_transferBtn layoutIfNeeded];

}

-(void)setStartDateandEndDate
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *tmpBudgetString = [userDefault stringForKey:@"BudgetRepeatType"];
    if ([tmpBudgetString isEqualToString:@"Weekly"])
    {
        budgetRepeatType = @"Weekly";
    }
    else
    {
        budgetRepeatType = @"Monthly";
    }
    
    if ([budgetRepeatType isEqualToString:@"Weekly"])
    {
        self.startDate = [appDelegate.epnc getStartDateWithDateType:1 fromDate:[NSDate date]];
        self.endDate = [appDelegate.epnc getEndDateDateType:1 withStartDate:self.startDate];
        
        
        titleStringLabel.frame = CGRectMake(titleStringLabel.frame.origin.x, titleStringLabel.frame.origin.y, 200, 20);
        titleStringLabel.text = [NSString stringWithFormat:@"%@ - %@",[dateFormatterWithOutYear stringFromDate:startDate],[dateFormatter stringFromDate:endDate]];
        dateBtntateImageView.frame = CGRectMake(258, dateBtntateImageView.frame.origin.y, dateBtntateImageView.frame.size.height, dateBtntateImageView.frame.size.width);
        timeBtn.frame = CGRectMake(timeBtn.frame.origin.x, timeBtn.frame.origin.y, 310, timeBtn.frame.size.height);
        dateRangeSelView.frame = CGRectMake(183, dateRangeSelView.frame.origin.y, dateRangeSelView.frame.size.width, dateRangeSelView.frame.size.height);
        
        //最后一个按钮
        NSString *title0 = [NSString stringWithFormat:@"%@ - %@",[dateFormatterWithOutYear stringFromDate:startDate],[dateFormatter stringFromDate:endDate]];
        [dataSelBtn5 setTitle:title0 forState:UIControlStateNormal];
        [dataSelBtn5 setTitle:title0 forState:UIControlStateHighlighted];
 
        NSDate  *last1WeekStart = [appDelegate.epnc getPerDate:self.startDate byCycleType:@"Weekly"];
        NSDate *last1WeekEnd = [appDelegate.epnc getEndDateDateType:1 withStartDate:last1WeekStart];
        NSString *title1 = [NSString stringWithFormat:@"%@ - %@",[dateFormatterWithOutYear stringFromDate:last1WeekStart],[dateFormatter stringFromDate:last1WeekEnd]];
        [dataSelBtn4 setTitle:title1 forState:UIControlStateNormal];
        [dataSelBtn4 setTitle:title1 forState:UIControlStateHighlighted];
        
        NSDate *last2WeekStart = [appDelegate.epnc getPerDate:last1WeekStart byCycleType:@"Weekly"];
        NSDate *last2WeekEnd = [appDelegate.epnc getEndDateDateType:1 withStartDate:last2WeekStart];
        NSString *title2 = [NSString stringWithFormat:@"%@ - %@",[dateFormatterWithOutYear stringFromDate:last2WeekStart],[dateFormatter stringFromDate:last2WeekEnd]];
        [dataSelBtn3 setTitle:title2 forState:UIControlStateNormal];
        [dataSelBtn3 setTitle:title2 forState:UIControlStateHighlighted];
        
        NSDate *last3WeekStart = [appDelegate.epnc getPerDate:last2WeekStart byCycleType:@"Weekly"];
        NSDate *last3WeekEnd = [appDelegate.epnc getEndDateDateType:1 withStartDate:last3WeekStart];
        NSString *title3 = [NSString stringWithFormat:@"%@ - %@",[dateFormatterWithOutYear stringFromDate:last3WeekStart],[dateFormatter stringFromDate:last3WeekEnd]];
        [dataSelBtn2 setTitle:title3 forState:UIControlStateNormal];
        [dataSelBtn2 setTitle:title3 forState:UIControlStateHighlighted];
        
        NSDate *last4WeekStart = [appDelegate.epnc getPerDate:last3WeekStart byCycleType:@"Weekly"];
        NSDate *last4WeekEnd = [appDelegate.epnc getEndDateDateType:1 withStartDate:last4WeekStart];
        NSString *title4 = [NSString stringWithFormat:@"%@ - %@",[dateFormatterWithOutYear stringFromDate:last4WeekStart],[dateFormatter stringFromDate:last4WeekEnd]];
        [dataSelBtn1 setTitle:title4 forState:UIControlStateNormal];
        [dataSelBtn1 setTitle:title4 forState:UIControlStateHighlighted];

        
        NSDate *last5WeekStart = [appDelegate.epnc getPerDate:last4WeekStart byCycleType:@"Weekly"];
        NSDate *last5WeekEnd = [appDelegate.epnc getEndDateDateType:1 withStartDate:last5WeekStart];
        NSString *title5 = [NSString stringWithFormat:@"%@ - %@",[dateFormatterWithOutYear stringFromDate:last5WeekStart],[dateFormatter stringFromDate:last5WeekEnd]];
        [dataSelBtn setTitle:title5 forState:UIControlStateNormal];
        [dataSelBtn setTitle:title5 forState:UIControlStateHighlighted];
        
        [dateArray removeAllObjects];
        [dateArray addObject:last5WeekStart];
        [dateArray addObject:last4WeekStart];
        [dateArray addObject:last3WeekStart];
        [dateArray addObject:last2WeekStart];
        [dateArray addObject:last1WeekStart];
        [dateArray addObject:self.startDate];


    }
    else
    {
        self.startDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[NSDate date]];
        self.endDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.startDate];
        
        titleStringLabel.frame = CGRectMake(titleStringLabel.frame.origin.x, titleStringLabel.frame.origin.y, 100, 30);
        titleStringLabel.text = [monthandYearDateFormatter stringFromDate:self.startDate];
        dateBtntateImageView.frame = CGRectMake(135, dateBtntateImageView.frame.origin.y, dateBtntateImageView.frame.size.height, dateBtntateImageView.frame.size.width);
        timeBtn.frame = CGRectMake(timeBtn.frame.origin.x, timeBtn.frame.origin.y, 166, timeBtn.frame.size.height);
        dateRangeSelView.frame = CGRectMake(60, dateRangeSelView.frame.origin.y, dateRangeSelView.frame.size.width, dateRangeSelView.frame.size.height);

        
        [dataSelBtn5 setTitle:[monthandYearDateFormatter stringFromDate:self.startDate] forState:UIControlStateNormal];
        [dataSelBtn5 setTitle:[monthandYearDateFormatter stringFromDate:self.startDate] forState:UIControlStateHighlighted];
        
        
        NSDate  *last1Month = [appDelegate.epnc getPerDate:self.startDate byCycleType:@"Monthly"];
        [dateArray addObject:last1Month];
        [dataSelBtn4 setTitle:[monthandYearDateFormatter stringFromDate:last1Month] forState:UIControlStateNormal];
        [dataSelBtn4 setTitle:[monthandYearDateFormatter stringFromDate:last1Month] forState:UIControlStateHighlighted];
        
        NSDate *last2Month = [appDelegate.epnc getPerDate:last1Month byCycleType:@"Monthly"];
        [dateArray addObject:last2Month];
        [dataSelBtn3 setTitle:[monthandYearDateFormatter stringFromDate:last2Month] forState:UIControlStateNormal];
        [dataSelBtn3 setTitle:[monthandYearDateFormatter stringFromDate:last2Month] forState:UIControlStateHighlighted];
        
        NSDate *last3Month = [appDelegate.epnc getPerDate:last2Month byCycleType:@"Monthly"];
        [dateArray addObject:last3Month];
        [dataSelBtn2 setTitle:[monthandYearDateFormatter stringFromDate:last3Month] forState:UIControlStateNormal];
        [dataSelBtn2 setTitle:[monthandYearDateFormatter stringFromDate:last3Month] forState:UIControlStateHighlighted];
        
        NSDate *last4Month = [appDelegate.epnc getPerDate:last3Month byCycleType:@"Monthly"];
        [dateArray addObject:last4Month];
        [dataSelBtn1 setTitle:[monthandYearDateFormatter stringFromDate:last4Month] forState:UIControlStateNormal];
        [dataSelBtn1 setTitle:[monthandYearDateFormatter stringFromDate:last4Month] forState:UIControlStateHighlighted];
        
        NSDate *last5Month = [appDelegate.epnc getPerDate:last4Month byCycleType:@"Monthly"];
        [dateArray addObject:last5Month];
        [dataSelBtn setTitle:[monthandYearDateFormatter stringFromDate:last5Month] forState:UIControlStateNormal];
        [dataSelBtn setTitle:[monthandYearDateFormatter stringFromDate:last5Month] forState:UIControlStateHighlighted];
        
        [dateArray removeAllObjects];
        [dateArray addObject:last5Month];
        [dateArray addObject:last4Month];
        [dateArray addObject:last3Month];
        [dateArray addObject:last2Month];
        [dateArray addObject:last1Month];
        [dateArray addObject:self.startDate];
    }
}

-(void)reFlashTableViewData
{
    dateRangeSelView.hidden = YES;
    [self getBudgetArray];
    [self getTranscationDateSouce];
    
    [self setTodayLineandTodayLabel];
    
    [leftTableView reloadData];
    [rightTableView reloadData];
    
    if ([budgetArray count]>indexOfBudgetArray) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:indexOfBudgetArray inSection:0];
        [leftTableView selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionTop];
    }
    [self setRightPartBudgetNameandOtherInformation];

    
}

-(void)setDateBtnTitle
{
    
}

-(void)getAllBudgetData
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSError *error =nil;
	
 	// Edit the entity name as appropriate.
    NSFetchRequest *fetchRequest = [[appDelegate.managedObjectModel fetchRequestTemplateForName:@"fetchNewStyleBudget" ] copy];
    
    // Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
 	NSMutableArray *allBudgetArray  = [[NSMutableArray alloc] initWithArray:objects];


    if ([allBudgetArray count]>0) {
        hasBudget = YES;
    }
    else
        hasBudget = NO;
    
}

//搜索budgetTemplate表格，获取state==1的budgetTemplate，然后获取该budgetTemplate底下的budgetItem的信息与交易
-(void)getBudgetArray
{
    
 	[self.budgetArray removeAllObjects];
	NSError *error =nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
 	// Edit the entity name as appropriate.
    NSFetchRequest *fetchRequest = [[appDelegate.managedObjectModel fetchRequestTemplateForName:@"fetchNewStyleBudget" ] copy];
    
    // Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
 	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
 	NSMutableArray *allBudgetArray  = [[NSMutableArray alloc] initWithArray:objects];

	
	double totalBudgetAmount = 0;
	double totalExpense = 0;
    
 	double totalIncome = 0;
	BudgetCountClass *bcc;
    
	NSDictionary *subs;
	for (int i = 0; i<[allBudgetArray count];i++)
    {
		BudgetTemplate *budgetTemplate = [allBudgetArray objectAtIndex:i];
        totalBudgetAmount +=[budgetTemplate.amount doubleValue];
        bcc = [[BudgetCountClass alloc] init];
        bcc.bt = budgetTemplate;
        bcc.btTotalExpense =0;
        bcc.btTotalIncome =0;
		BudgetItem *budgetTemplateCurrentItem	=[[budgetTemplate.budgetItems allObjects] lastObject];
        if( budgetTemplate.category!=nil)
        {
            subs = [NSDictionary dictionaryWithObjectsAndKeys:budgetTemplate.category,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
            
            
            
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs] ;
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
          
            NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
            
            for (int j = 0;j<[tmpArray count];j++)
            {
                Transaction *t = [tmpArray objectAtIndex:j];
                if([t.category.categoryType isEqualToString:@"EXPENSE"] && [t.state isEqualToString:@"1"])
                {
                    bcc.btTotalExpense +=[t.amount doubleValue];
                    totalExpense +=[t.amount doubleValue];
                }
                else if([t.category.categoryType isEqualToString:@"INCOME"] && [t.state isEqualToString:@"1"]){
                    bcc.btTotalIncome +=[t.amount doubleValue];
                    totalIncome +=[t.amount doubleValue];
                }
                
            }
            
            NSMutableArray *tmpArray1 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.fromTransfer allObjects]];
            
            for (int j = 0;j<[tmpArray1 count];j++)
            {
                BudgetTransfer *bttmp = [tmpArray1 objectAtIndex:j];
                if([appDelegate.epnc dateCompare:bttmp.dateTime withDate:self.startDate]>=0 &&
                   [appDelegate.epnc dateCompare:bttmp.dateTime withDate:self.endDate]<=0 && [bttmp.state isEqualToString:@"1"] && [bttmp.state isEqualToString:@"1"])
					bcc.btTotalExpense +=[bttmp.amount doubleValue];
                
            }
            
            NSMutableArray *tmpArray2 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.toTransfer allObjects]];
            
            for (int j = 0; j<[tmpArray2 count];j++)
            {
                BudgetTransfer *bttmp = [tmpArray2 objectAtIndex:j];
                if([appDelegate.epnc dateCompare:bttmp.dateTime withDate:self.startDate]>=0 &&
                   [appDelegate.epnc dateCompare:bttmp.dateTime withDate:self.endDate]<=0 &&[bttmp.state isEqualToString:@"1"] && [bttmp.state isEqualToString:@"1"])
					bcc.btTotalIncome +=[bttmp.amount doubleValue];
                //totalIncome +=[bttmp.amount doubleValue];
                
            }
            
            ////////////////////get All child category
            NSString *searchForMe = @":";
            NSRange range = [budgetTemplate.category.categoryName rangeOfString : searchForMe];
            
            if (range.location == NSNotFound)
            {
                NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",budgetTemplate.category.categoryName];
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",budgetTemplate.category.categoryType,@"CATEGORYTYPE",nil];
                NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
                NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                [fetchChildCategory setSortDescriptors:sortDescriptors];
                NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
                NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
                
                for(int j=0 ;j<[tmpChildCategoryArray count];j++)
                {
                    Category *tmpCate = [tmpChildCategoryArray objectAtIndex:j];
                    if(tmpCate !=budgetTemplate.category)
                    {
                        subs = [NSDictionary dictionaryWithObjectsAndKeys:tmpCate,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
                        NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
                        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                        NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                        [fetchRequest setSortDescriptors:sortDescriptors];
                        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                       
                        
                        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
                        
                        for (int k = 0;k<[tmpArray count];k++)
                        {
                            Transaction *t = [tmpArray objectAtIndex:k];
                            if([t.category.categoryType isEqualToString:@"EXPENSE"])
                            {
                                bcc.btTotalExpense +=[t.amount doubleValue];
                                totalExpense +=[t.amount doubleValue];
                            }
                            else if([t.category.categoryType isEqualToString:@"INCOME"])
                            {
                                bcc.btTotalIncome +=[t.amount doubleValue];
                                totalIncome +=[t.amount doubleValue];
                            }
                            
                        }
                    }
                }
                
            }
            
        }
        
        [budgetArray addObject:bcc];
	}



	
    double totalblance =  totalBudgetAmount+ totalIncome ;
    double spent = totalExpense;
    
    NSString *usedStr = [appDelegate.epnc formatterString:totalExpense];
    NSString *allStr = [appDelegate.epnc formatterString:totalblance];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ / %@",usedStr,allStr]];
    
    NSUInteger len = [usedStr length];
    
    UIColor *headColor;
    if (totalblance >= totalExpense)
    {
        headColor = [UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    }
    else
    {
        headColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
    }
    
    [str addAttribute:NSForegroundColorAttributeName value:headColor range:NSMakeRange(0, len)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17] range:NSMakeRange(0, len)];
    
    availLabel.attributedText = str;
    
    _topViewLabel.text = [NSString stringWithFormat:@"%@",[appDelegate.epnc formatterString:totalblance - totalExpense]];
    
   
    
    //设置topBudgetBar
    if (topBudgetBar!=nil)
    {
        [topBudgetBar removeFromSuperview];
    }
    
    UIColor *gray=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    UIColor *red=[UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
    if (totalblance==0)
    {
        topBudgetBar=[[budgetBar_iPad alloc]initWithFrame:CGRectMake(30, 67, IPAD_WIDTH-60, 15) type:@"all" ratio:0 color:gray];
    }
    else if (spent<=totalblance)
    {
        topBudgetBar=[[budgetBar_iPad alloc]initWithFrame:CGRectMake(30, 67, IPAD_WIDTH-60, 15) type:@"all" ratio:spent/totalblance color:gray];
    }
    else
    {
        topBudgetBar=[[budgetBar_iPad alloc]initWithFrame:CGRectMake(30, 67, IPAD_WIDTH-60, 15) type:@"all" ratio:totalblance/spent color:red];
    }
    [_topView addSubview:topBudgetBar];
    
    
    
    if([budgetArray count]==0)
    {
        noRecordViewLeft.hidden =NO;
        
    }
    else {
        noRecordViewLeft.hidden = YES;
        
    }
    
	if([budgetArray count]> 1)
	{
//  		self.transferButton_NS.enabled = TRUE;
	}
	else {
//		self.transferButton_NS.enabled = FALSE;
	}
    
}

- (void)getTranscationDateSouce
{
	BudgetCountClass *bcc=nil;
	if(indexOfBudgetArray<[budgetArray count])
	{
		bcc = (BudgetCountClass *)[budgetArray objectAtIndex:indexOfBudgetArray];
 		
	}
	else
    {
		if([budgetArray count]>0)
		{
			bcc = (BudgetCountClass *)[budgetArray objectAtIndex:0];
		}
	}
    
    
    [transactionArray removeAllObjects];
    if (bcc==nil)
        return;
    BudgetItem *budgetItem = [[ bcc.bt.budgetItems allObjects] lastObject];
    if(bcc.bt.category!=nil)
    {
        BudgetDetailClassType *bdct;
        NSDictionary *subs;
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        subs = [NSDictionary dictionaryWithObjectsAndKeys:bcc.bt.category,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
        NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
        NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSError *error =nil;
        
        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
     
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
        for (int i = 0; i<[tmpArray count];i++)
        {
            Transaction *t = [tmpArray objectAtIndex:i];
            
            bdct = [[BudgetDetailClassType alloc] init];
            bdct.date = t.dateTime ;
            bdct.dct = DetailClassTypeTranction;
            bdct.transaction = t;
            [transactionArray addObject:bdct];
        }
        
        [tmpArray setArray:[budgetItem.fromTransfer allObjects]];
        for (int i = 0; i<[tmpArray count];i++)
        {
            BudgetTransfer *bt = [tmpArray objectAtIndex:i];
            if([appDelegate.epnc dateCompare:bt.dateTime withDate:self.startDate]>=0 &&
               [appDelegate.epnc dateCompare:bt.dateTime withDate:self.endDate]<=0 && [bt.state isEqualToString:@"1"])
            {
                bdct = [[BudgetDetailClassType alloc] init];
                bdct.date = bt.dateTime ;
                bdct.dct = DetailClassTypeFromTransfer;
                bdct.budgetTransfer = bt;
                [transactionArray addObject:bdct];
            }
        }
        
        [tmpArray setArray:[budgetItem.toTransfer allObjects]];
        for (int i = 0; i<[tmpArray count];i++)
        {
            BudgetTransfer *bt = [tmpArray objectAtIndex:i];
            if([appDelegate.epnc dateCompare:bt.dateTime withDate:self.startDate]>=0 &&
               [appDelegate.epnc dateCompare:bt.dateTime withDate:self.endDate]<=0  && [bt.state isEqualToString:@"1"])
            {
                bdct = [[BudgetDetailClassType alloc] init];
                bdct.date = bt.dateTime;
                bdct.dct = DetailClassTypeToTransfer;
                bdct.budgetTransfer = bt;
                [transactionArray addObject:bdct];
            }
        }
        ////////////////////get All child category
        NSString *searchForMe = @":";
        NSRange range = [bcc.bt.category.categoryName rangeOfString : searchForMe];
        
        if (range.location == NSNotFound) {
            NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",bcc.bt.category.categoryName];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",bcc.bt.category.categoryType,@"CATEGORYTYPE",nil];
            NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchChildCategory setSortDescriptors:sortDescriptors];
            NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
            NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
            
           
            for(int j=0 ;j<[tmpChildCategoryArray count];j++)
            {
                Category *tmpCate = [tmpChildCategoryArray objectAtIndex:j];
                if(tmpCate !=bcc.bt.category)
                {
                    subs = [NSDictionary dictionaryWithObjectsAndKeys:tmpCate,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
                    NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                    [fetchRequest setSortDescriptors:sortDescriptors];
                    NSError *error =nil;
                    
                    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                  
                    NSMutableArray *tmpArray1 = [[NSMutableArray alloc] initWithArray:objects];
                    for (int i = 0; i<[tmpArray1 count];i++) {
                        Transaction *t = [tmpArray1 objectAtIndex:i];
                        bdct = [[BudgetDetailClassType alloc] init];
                        bdct.date = t.dateTime ;
                        bdct.dct = DetailClassTypeTranction;
                        bdct.transaction = t;
                        [transactionArray addObject:bdct];
                    }
                }
            }
            
        }
        
        NSSortDescriptor *sort= [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];;
        
        NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
        
        [transactionArray sortUsingDescriptors:sorts];
        
  
    }
	
  	
	
	
    if([transactionArray count]==0)
    {
        noRecordViewRight.hidden = NO;
    }
    else
    {
        noRecordViewRight.hidden = YES;
    }

}



-(void)setTodayLineandTodayLabel
{
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
//    NSDate *monthStartDate=[appDelegate.epnc  getStartDateWithDateType:2 fromDate:[NSDate date]];
//    
//    NSDate *monthEndDate=[appDelegate.epnc getEndDateDateType:2 withStartDate:monthStartDate];
    
    unsigned int flag=NSDayCalendarUnit;
    NSDateComponents *componet=[[NSCalendar currentCalendar] components:flag fromDate:startDate toDate:endDate options:nil];
    NSDateComponents *component2=[[NSCalendar currentCalendar] components:flag fromDate:startDate toDate:[NSDate date] options:nil];
    CGFloat monthDays=[componet day]+1;
    CGFloat todayCount=[component2 day]+1;
    CGFloat count=todayCount/monthDays;
    
    if(todayCount<=monthDays)
    {
        todayView.hidden = NO;
        todayView.frame = CGRectMake(20+count*550 , todayView.frame.origin.y, todayView.frame.size.width, todayView.frame.size.height);
    }
    else
        todayView.hidden = YES;
    
}

#pragma mark Btn Action
//-----------增加 budget的事件
-(void)setupBtnPressed:(id)sender
{
    dateRangeSelView.hidden = YES;
    
    _budgetSettingViewController = [[ipad_BudgetSettingViewController alloc]initWithNibName:@"ipad_BudgetSettingViewController" bundle:nil];
    _budgetSettingViewController.budgetViewController = self;
    
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_budgetSettingViewController];
    AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
 	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    appDelegate1.mainViewController.popViewController = navigationController ;
    [appDelegate1.mainViewController presentViewController:navigationController animated:YES completion:nil];
	navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;

 
	
}

-(void)transferBtnPressed:(UIButton *)sender
{
    dateRangeSelView.hidden = YES;
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    BudgetCountClass *bcc=nil;
    if([budgetArray count]>0)
    {
        bcc = (BudgetCountClass *)[budgetArray objectAtIndex:indexOfBudgetArray];
    }
    
    ipad_TransferViewController_NS *transferViewController = [[ipad_TransferViewController_NS alloc]initWithNibName:@"ipad_TransferViewController_NS" bundle:nil];
    transferViewController.fromBudget = bcc.bt;
    transferViewController.typeOftodo = @"IPAD_ADD";
    transferViewController.startDate = self.startDate;
    transferViewController.endDate = self.endDate;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:transferViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    appDelegate_iPad.mainViewController.popViewController = navigationController ;
    [appDelegate_iPad.mainViewController presentViewController:navigationController animated:YES completion:nil];
    navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
//    navigationController.view.superview.frame = CGRectMake(
//                                                           272,
//                                                           100,
//                                                           480,
//                                                           490
//                                                           );


}

-(void)timeBtnPressed:(id)sender
{
    
    dateRangeSelView.hidden = !dateRangeSelView.hidden;

}

-(void)dataRangeBtnAction:(UIButton *)sender
{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];


    if (sender.tag==0)
    {
        if ([budgetRepeatType isEqualToString:@"Weekly"])
        {
            self.startDate = [appDelegate_iPhone.epnc getStartDate:@"Weekly" beforCycleCount:1 withDate:self.startDate];
            self.endDate = [appDelegate_iPhone.epnc getEndDateDateType:1 withStartDate:self.startDate];
        }
        else
        {
            self.startDate = [appDelegate_iPhone.epnc getStartDate:@"MONTHLY" beforCycleCount:1 withDate:self.startDate];
            self.endDate = [appDelegate_iPhone.epnc getEndDateDateType:2 withStartDate:self.startDate];
        }

    }
    else
    {
        
        if ([budgetRepeatType isEqualToString:@"Weekly"])
        {
            self.startDate = [appDelegate_iPhone.epnc getNextDate:self.startDate byCycleType:@"Weekly"];
            self.endDate = [appDelegate_iPhone.epnc getEndDateDateType:1 withStartDate:self.startDate];
        }
        else
        {
            self.startDate = [appDelegate_iPhone.epnc getNextDate:self.startDate byCycleType:@"MONTHLY"];
            self.endDate = [appDelegate_iPhone.epnc getEndDateDateType:2 withStartDate:self.startDate];
        }

    }
    
    NSDateFormatter *dateFormatterWithYear = [[NSDateFormatter alloc]init];
    [dateFormatterWithYear setDateFormat:@"MMM dd"];
    
    if ([budgetRepeatType isEqualToString:@"Weekly"])
    {
        self.titleStringLabel.text = [NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:self.startDate],[dateFormatterWithYear stringFromDate:self.endDate]];
//        if ([appDelegate_iPhone.epnc weekCompare:self.endDate withDate:[NSDate date]]<0) {
//            _bvc_rightBtn.enabled = YES;
//        }
//        else
//            _bvc_rightBtn.enabled = NO;
    }
    
    else
    {
        self.titleStringLabel.text = [monthandYearDateFormatter stringFromDate:self.endDate];
//        if ([appDelegate_iPhone.epnc monthCompare:self.endDate withDate:[NSDate date]]<0) {
//            _bvc_rightBtn.enabled = YES;
//        }
//        else
//            _bvc_rightBtn.enabled = NO;
    }

    
    [self reFlashTableViewData];
}

-(void)reSetDateRangeViewBtnStyle
{
    dataSelBtn.selected = NO;
    dataSelBtn1.selected = NO;
    dataSelBtn2.selected = NO;
    dataSelBtn3.selected = NO;
    dataSelBtn4.selected = NO;
    dataSelBtn5.selected = NO;
    
    [dataSelBtn.titleLabel setHighlighted:FALSE];
    [dataSelBtn1.titleLabel setHighlighted:FALSE];
    [dataSelBtn2.titleLabel setHighlighted:FALSE];
    [dataSelBtn3.titleLabel setHighlighted:FALSE];
    [dataSelBtn4.titleLabel setHighlighted:FALSE];
    [dataSelBtn5.titleLabel setHighlighted:FALSE];
}

#pragma mark TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //budget 比较宅的页面
	if(tableView == leftTableView)
        return 64;
    else
        return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==rightTableView)
    {
        if (transactionArray.count!=0)
        {
            return 30;
        }
        return 0;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

        return 0;
   
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(tableView == leftTableView)
		return [budgetArray count];
	else
        return [transactionArray count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==rightTableView)
    {
        return _headView;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(tableView == leftTableView)
	{
		static NSString *CellIdentifierNew = @"Cell";
        ipad_BudgetCell_New *cell = (ipad_BudgetCell_New *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierNew];
        if(cell == nil)
        {
            cell = [[ipad_BudgetCell_New alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierNew ] ;
        }
 		[self configureNewStyleBudgetCell:cell atIndexPath:indexPath];
		return cell;
	}
	else 	if(tableView == rightTableView)
    {
        static NSString *CellIdentifier = @"transcationCell";
        
        ipad_BudgetTransactionCell *cell = (ipad_BudgetTransactionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[ipad_BudgetTransactionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        [self configureNewStyleTranscationCell:cell atIndexPath:indexPath];
        return cell;
        
    }
    return nil;
}

- (void)configureNewStyleBudgetCell:(ipad_BudgetCell_New *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BudgetCountClass *bcc = (BudgetCountClass *)[budgetArray objectAtIndex:indexPath.row];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    cell.cateImageView.image=[UIImage imageNamed:bcc.bt.category.iconName];
    
    cell.nameLabel.text = bcc.bt.category.categoryName;
    
    double totalblance = [bcc.bt.amount doubleValue]+bcc.btTotalIncome ;
    double spent =  bcc.btTotalExpense;

    
    
    NSString *usedStr = [appDelegate.epnc formatterString:spent];
    NSString *allStr = [appDelegate.epnc formatterString:totalblance];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ / %@",usedStr,allStr]];
    
    NSUInteger len = [usedStr length];
    
    UIColor *headColor;
    if (totalblance >= spent)
    {
        headColor = [UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    }
    else
    {
        headColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
    }
    
    [str addAttribute:NSForegroundColorAttributeName value:headColor range:NSMakeRange(0, len)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:10] range:NSMakeRange(0, len)];
    
    cell.budgetLabel.attributedText = str;
    
    cell.spentLabel.text = [NSString stringWithFormat:@"%@",[appDelegate.epnc formatterString:totalblance - spent]];
    
    //设置图片颜色，收入与支出
    //判断总共的金额，如果金额为0
    if (cell.budgetBar!=nil)
    {
        [cell.budgetBar removeFromSuperview];
    }
    
    if (indexPath.row == indexOfBudgetArray)
    {
        [cell setSelected:YES animated:NO];
        
        UIColor *gray=[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
        UIColor *red=[UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
        if(totalblance == 0 || spent<=0 )
        {
            cell.budgetBar=[[budgetBar_iPad alloc]initWithFrame:CGRectMake(53, 40, 310, 5) type:@"list_select" ratio:0 color:gray];
        }
        else if(spent<=totalblance)
        {
            cell.budgetBar=[[budgetBar_iPad alloc]initWithFrame:CGRectMake(53, 40, 310, 5) type:@"list_select" ratio:spent/totalblance color:gray];
        }
        else
        {
            cell.budgetBar=[[budgetBar_iPad alloc]initWithFrame:CGRectMake(53, 40, 310, 5) type:@"list_select" ratio:totalblance/spent color:red];
        }
    }
    else
    {
        [cell setSelected:NO animated:NO];
        UIColor *gray=[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
        UIColor *red=[UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
        if(totalblance == 0 || spent<=0 )
        {
            cell.budgetBar=[[budgetBar_iPad alloc]initWithFrame:CGRectMake(53, 40, 310, 5) type:@"list" ratio:0 color:gray];
        }
        else if(spent<=totalblance)
        {
            cell.budgetBar=[[budgetBar_iPad alloc]initWithFrame:CGRectMake(53, 40, 310, 5) type:@"list" ratio:spent/totalblance color:gray];
        }
        else
        {
            cell.budgetBar=[[budgetBar_iPad alloc]initWithFrame:CGRectMake(53, 40, 310, 5) type:@"list" ratio:totalblance/spent color:red];
        }
    }
    [cell.contentView addSubview:cell.budgetBar];
    
    
    
}

- (void)configureNewStyleTranscationCell:(ipad_BudgetTransactionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
  	BudgetDetailClassType *bdct = (BudgetDetailClassType *)[transactionArray objectAtIndex:indexPath.row];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    Transaction *transcation =bdct.transaction;
    
    //category spent
    if(bdct.dct == DetailClassTypeTranction)
	{
        //payee
        if(transcation.payee !=nil&&[transcation.payee.name length]>0)
        {
            cell.nameLabel.text = transcation.payee.name;
            
        }
        else if([transcation.notes length]>0)
            cell.nameLabel.text = transcation.notes;
        else {
            cell.nameLabel.text = @"-";
            
        }
        
        //category spent
 		if([transcation.category.categoryType isEqualToString:@"INCOME"])
            
        {
            if(transcation.category != nil)
            {
                cell.categoryLabel.text = transcation.category.categoryName;
            }
            else
            {
                cell.categoryLabel.text = @"Not Sure";
            }
            cell.spentLabel.text =[appDelegate.epnc formatterStringWithOutPositive:[transcation.amount  doubleValue]];
            
            [cell.spentLabel setTextColor:[UIColor colorWithRed:66.0/255.0 green:194.0/255.0 blue:135.0/255.0 alpha:1.f]];
        }
        else
        {
            if(transcation.category != nil)
            {
                cell.categoryLabel.text = transcation.category.categoryName;
            }
            else
            {
                cell.categoryLabel.text = @"Not Sure";
            }
            
            [cell.spentLabel setTextColor:[appDelegate.epnc getAmountRedColor]];
            cell.spentLabel.text =[appDelegate.epnc formatterStringWithOutPositive:0-[transcation.amount  doubleValue]];
        }
        
        
        //time
        NSString* time = [dateFormatter stringFromDate:transcation.dateTime];
        cell.timeLabel.text = time;
    }
	else
	{
        cell.nameLabel.text = @"-";
        cell.timeLabel.text = [dateFormatter stringFromDate:bdct.date];
        
		if(bdct.dct == DetailClassTypeFromTransfer)
		{
            
			cell.categoryLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"VC_XFER To", nil),bdct.budgetTransfer.toBudget.budgetTemplate.category.categoryName];
            
		}
		else if(bdct.dct == DetailClassTypeToTransfer)
		{
            
			
			cell.categoryLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"VC_XFER From", nil),bdct.budgetTransfer.fromBudget.budgetTemplate.category.categoryName];
 		}
        
 		cell.spentLabel.text = [appDelegate.epnc formatterStringWithOutPositive:[bdct.budgetTransfer.amount doubleValue]];
        
        [cell.spentLabel setTextColor:[UIColor colorWithRed:92.0/255 green:92.0/255 blue:92.0/255 alpha:1.0]];
        
    }
    if (indexPath.row%2)
    {
        if (indexPath.row==transactionArray.count-1)
        {
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"budget_form_bottom_gray"]];
        }
        else
        {
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"budget_form_gray"]];
        }
    }
    else
    {
        if (indexPath.row==transactionArray.count-1)
        {
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"budget_form_bottom_white"]];
        }
        else
        {
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"budget_form_white"]];
        }
    }
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (tableView==leftTableView) {
//        UIView  *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,629, 70)];
//        footView.backgroundColor = [UIColor whiteColor];
//        
//        UIButton *adjustBtn = [[UIButton alloc]initWithFrame:CGRectMake(214, 30, 200, 40)];
//        [adjustBtn setBackgroundImage:[UIImage imageNamed:@"ipad_btn_adjust.png"] forState:UIControlStateNormal];
//        [adjustBtn setTitle:NSLocalizedString(@"VC_Adjust", nil) forState:UIControlStateNormal];
//        [adjustBtn setTitleColor:[UIColor colorWithRed:76.f/255.5 green:143.f/255.5 blue:202.f/255.5 alpha:1] forState:UIControlStateNormal];
//        [adjustBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
//        adjustBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        adjustBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        adjustBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0 , 0, 0);
//        [adjustBtn addTarget:self action:@selector(setupBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [footView addSubview:adjustBtn];
//        return footView;
//
//    }
//    else
//        return 0;
//}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ipad_BudgetCell_New *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.budgetBar.top.image=[UIImage imageNamed:@"iPad_budgetBar_list"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dateRangeSelView.hidden = YES;
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];

    if(tableView == leftTableView)
	{
        indexOfBudgetArray = indexPath.row;
        [self getTranscationDateSouce];
        [self setRightPartBudgetNameandOtherInformation];
        ipad_BudgetCell_New *cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.budgetBar.top.image=[UIImage imageNamed:@"iPad_budgetBar_list_select"];
        [rightTableView reloadData];
	}
	else if(tableView == rightTableView)
	{
        [rightTableView deselectRowAtIndexPath:indexPath animated:NO];
 		BudgetDetailClassType *bdct = (BudgetDetailClassType *)[transactionArray objectAtIndex:indexPath.row];
		if(bdct.dct == DetailClassTypeTranction)
		{
			if (bdct.transaction.parTransaction != nil)
            {
                AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
                UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_This is a part of a transaction split, and it can not be edited alone.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
                appDelegate_iPhone.appAlertView = alertView;
                [alertView show];
                return;
                
            }
            ipad_TranscactionQuickEditViewController *editController =[[ipad_TranscactionQuickEditViewController alloc] initWithNibName:@"ipad_TranscactionQuickEditViewController" bundle:nil];
            editController.transaction = bdct.transaction;
            editController.typeoftodo = @"IPAD_EDIT";
            
            if([bdct.transaction.category.categoryType isEqualToString:@"EXPENSE"])
            {
                editController.accounts = bdct.transaction.expenseAccount;
                
            }
            else if([bdct.transaction.category.categoryType isEqualToString:@"INCOME"])
            {
                editController.accounts = bdct.transaction.incomeAccount;
                
            }

            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editController];
            navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
            
            appDelegate_iPad.mainViewController.popViewController = navigationController ;
            [appDelegate_iPad.mainViewController presentViewController:navigationController animated:YES completion:nil];
            navigationController.view.superview.autoresizingMask =
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin;

			
		}
		else 	if(bdct.budgetTransfer!=nil)
		{
			
            ipad_TransferViewController_NS*transferView = [[ipad_TransferViewController_NS alloc] initWithNibName:@"ipad_TransferViewController_NS" bundle:nil];
            transferView.budgetTransfer = bdct.budgetTransfer;
            transferView.typeOftodo = @"IPAD_EDIT";
            transferView.startDate = self.startDate;
            transferView.endDate = self.endDate;
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:transferView];
            navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
            
            appDelegate_iPad.mainViewController.popViewController = navigationController;
            [appDelegate_iPad.mainViewController presentViewController:navigationController animated:YES completion:nil];
            navigationController.view.superview.autoresizingMask =
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin;

         
		}
		return;
	}
    
    
    
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        if (tableView==leftTableView)
        {
            BudgetCountClass *oneBudgetCount = [budgetArray objectAtIndex: indexPath.row];
            
            [appDelegete.epdc deleteBudgetRel:oneBudgetCount.bt] ;
            indexOfBudgetArray = 0;
            [self reFlashTableViewData];
        }
        else
        {
            BudgetDetailClassType *bdct = (BudgetDetailClassType *)[transactionArray objectAtIndex:indexPath.row];
            
            
            if(bdct.dct == DetailClassTypeTranction)
            {
                
                [appDelegete.epdc deleteTransactionRel:bdct.transaction];
            }
            else
            {
                [appDelegete.epdc deleteTransferRel:bdct.budgetTransfer];
                
                
            }
            
            [transactionArray removeObjectAtIndex:indexPath.row];
            
            
            [self reFlashTableViewData];
            
            if([transactionArray count] == 0)
            {
                noRecordViewRight.hidden = NO;
            }
            else {
                noRecordViewRight.hidden = YES;
            }
        }
        
		
		
	}
    
    
}


@end
