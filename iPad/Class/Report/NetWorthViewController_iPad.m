//
//  NetWorthViewController_iPad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/25.
//
//

#import "NetWorthViewController_iPad.h"
#import "PokcetExpenseAppDelegate.h"
#import "NetWorthTableViewCell_iPad.h"


@interface NetWorthViewController_iPad ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDate *startDate;
    NSDate *endDate;
    
    NSMutableArray *netWorthArray;
    NSMutableArray *differenceArray;
    NSMutableArray *timeStrArray;
    
    UITableView *tableview;
    UILabel *timeLabel;
    
    UIView *backView;
    UIView *menuView;
    
    NSInteger formerTag;

}
@end

@implementation NetWorthViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PokcetExpenseAppDelegate *appDelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    startDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
    endDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:startDate];
    
    [self getData];
    [self createTableView];
    [self createMenu];
    [self createChart];
    
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
}
-(void)getData
{
    
    netWorthArray=[NSMutableArray array];
    differenceArray=[NSMutableArray array];
    timeStrArray=[NSMutableArray array];
    
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
    
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *tmpAccountArray = [[NSMutableArray alloc] initWithArray:objects];
    
    
    NSDate *date=endDate;
    
    for (int i=12; i>0; i--)
    {
        
        float allAccountsAmount=0;
        float surplus=0;
        for (Accounts *account in tmpAccountArray)
        {
            if([date compare:account.dateTime]==1)
            {
                allAccountsAmount+=[account.amount floatValue];
                NSMutableArray *tmpArrays = [[NSMutableArray alloc] initWithArray:[account.expenseTransactions allObjects]];
                [tmpArrays addObjectsFromArray:[[NSMutableArray alloc] initWithArray:[account.incomeTransactions allObjects]]];
                for (Transaction *transaction in tmpArrays)
                {
                    if ([date compare:transaction.dateTime]==1)
                    {
                        if ([transaction.state isEqualToString:@"1"])
                        {
                            if (transaction.incomeAccount)
                            {
                                surplus+=[transaction.amount floatValue];
                            }
                            else
                            {
                                surplus-=[transaction.amount floatValue];
                            }
                        }
                    }
                }
            }
        }
        float netWorth=allAccountsAmount+surplus;
        [netWorthArray addObject:[NSNumber numberWithFloat:netWorth]];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:date];
        [components setMonth:[components month]-1];
        date=[gregorian dateFromComponents:components];
        
        [timeStrArray addObject:date];
    }
    
    
    [differenceArray addObject:[NSNumber numberWithFloat:0]];
    for (int i=1; i<12; i++)
    {
        [differenceArray addObject:[NSNumber numberWithFloat:([[netWorthArray objectAtIndex:11-i] floatValue]-[[netWorthArray objectAtIndex:12-i] floatValue])]];
    }
    
}
#pragma  mark - 添加控件
-(void)createMenu
{
   
    
    backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPAD_WIDTH, IPAD_HEIGHT)];
    backView.backgroundColor=[UIColor blackColor];
    backView.alpha=0;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBtnClick:)];
    [backView addGestureRecognizer:tap];
    [self.view addSubview:backView];
    
    menuView=[[UIView alloc]initWithFrame:CGRectMake(IPAD_WIDTH-15, 44, 0, 0)];
    
    menuView.layer.cornerRadius=6;
    menuView.layer.masksToBounds=YES;
    
    NSArray *array=@[NSLocalizedString(@"VC_ThisYear", nil),NSLocalizedString(@"VC_Last12Months", nil)];
    for (int i=0; i<2; i++)
    {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, i*44, 121, 44)];
        if (i==0)
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"button_background"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"button_background_click"] forState:UIControlStateHighlighted];
        }
        else
        {
            btn.backgroundColor=[UIColor whiteColor];
            [btn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]] forState:UIControlStateHighlighted];
        }
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        [btn setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        
        menuView.clipsToBounds=YES;
        [menuView addSubview:btn];
    }
    [self.view addSubview:menuView];
}

-(void)createChart
{
    PokcetExpenseAppDelegate *appdelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //清除所有原有子视图
    for (UIView *subview in self.topView.subviews)
    {
        [subview removeFromSuperview];
    }
    
   
    
    float labelWidth=40;
    float labelIntervalLeft=15.5;
    float labelIntervalRight=15.5;
    
    //中线
    UIView *middleLine=[[UIView alloc]initWithFrame:CGRectMake(77, 10+44+63.75*2-EXPENSE_SCALE, IPAD_WIDTH-77-15, EXPENSE_SCALE)];
    middleLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [self.topView addSubview:middleLine];
    
    //纵 线
    UIView *verticalLine=[[UIView alloc]initWithFrame:CGRectMake(77, 10+44,EXPENSE_SCALE,  255)];
    verticalLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [self.topView addSubview:verticalLine];
    
    //刻度
    for (int i=0; i<5; i++)
    {
        if (i==2)
        {
            continue;
        }
        UIView *scaleLine=[[UIView alloc]initWithFrame:CGRectMake(77, 10+44+63.75*i, 4, EXPENSE_SCALE)];
        scaleLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [self.topView addSubview:scaleLine];
    }
    

    
    
    
    float max=0;
    for (NSNumber *value in netWorthArray)
    {
        if (fabs(value.floatValue)>max)
        {
            max=fabs(value.floatValue);
        }
    }
    
    //画坐标
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###,##0.00;"];
    
    
    UILabel *firstLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 10+44,65 , 15)];
    firstLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
    firstLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    firstLabel.text=[formatter stringFromNumber:[NSNumber numberWithFloat:max]];
    firstLabel.textAlignment=NSTextAlignmentRight;
    [self.topView addSubview:firstLabel];
    
    UILabel *secondLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 70+41.5,65 , 15)];
    secondLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
    secondLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    secondLabel.text=[formatter stringFromNumber:[NSNumber numberWithFloat:max/2]];
    secondLabel.textAlignment=NSTextAlignmentRight;
    [self.topView addSubview:secondLabel];
    
    UILabel *thirdLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 70+63.75+41,65 , 15)];
    thirdLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
    thirdLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    thirdLabel.text=[formatter stringFromNumber:[NSNumber numberWithFloat:0]];
    thirdLabel.textAlignment=NSTextAlignmentRight;
    [self.topView addSubview:thirdLabel];
    
    UILabel *forthLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 70+63.75*2+41,65 , 15)];
    forthLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
    forthLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    forthLabel.text=[formatter stringFromNumber:[NSNumber numberWithFloat:-max/2]];
    forthLabel.textAlignment=NSTextAlignmentRight;
    [self.topView addSubview:forthLabel];
    
    UILabel *fifthLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 70+65.75*3+30,65 , 15)];
    fifthLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
    fifthLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    fifthLabel.text=[formatter stringFromNumber:[NSNumber numberWithFloat:-max]];
    fifthLabel.textAlignment=NSTextAlignmentRight;
    [self.topView addSubview:fifthLabel];
    
    
    
    for (int i=0; i<12; i++)
    {
        float netWorth=[[netWorthArray objectAtIndex:11-i]floatValue];
        
        if (max!=0)
        {
            //画柱状图
            if (netWorth>=0)
            {
                UIView *view=[[UIView alloc]initWithFrame:CGRectMake((i+1)*labelIntervalLeft+i*labelIntervalRight+i*labelWidth+77, 44+10+127.5-netWorth/max*127.5, labelWidth, netWorth/max*127.5)];
                view.backgroundColor=[UIColor colorWithRed:92/255.0 green:203/255.0 blue:255/255.0 alpha:1];
                [self.topView addSubview:view];
            }
            else
            {
                UIView *view=[[UIView alloc]initWithFrame:CGRectMake((i+1)*labelIntervalLeft+i*labelIntervalRight+i*labelWidth+77,44+10+127.5, labelWidth, -netWorth/max*127.5)];
                view.backgroundColor=[UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
                [self.topView addSubview:view];
            }
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMM"];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(i*(labelIntervalLeft+labelWidth+labelIntervalRight)+77, self.topView.frame.size.height-35, 76, 35)];
        label.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        NSDate *monthDate=[timeStrArray objectAtIndex:11-i];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
        label.text=[[dateFormatter stringFromDate:monthDate]uppercaseString];
        [self.topView addSubview:label];
        
    }
    
    
    

    
    [self createTimeLabel];
}

-(void)createTableView
{
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 344, IPAD_WIDTH, IPAD_HEIGHT-344) style:UITableViewStylePlain];
    tableview.showsVerticalScrollIndicator=NO;
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}
-(void)createTimeLabel
{
    UIView *grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPAD_WIDTH, 44)];
    grayView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.topView addSubview:grayView];
    
    //时间调节按钮
    UIButton *timeChange=[[UIButton alloc]initWithFrame:CGRectMake(IPAD_WIDTH-40, 7, 30, 30)];
    [timeChange setImage:[UIImage imageNamed:@"chart_time"] forState:UIControlStateNormal];
    [timeChange addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:timeChange];
    //距有边界距离
    float toRight=49;
    
    
    timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(IPAD_WIDTH-toRight-300, 12, 300, 20)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *startString = [dateFormatter stringFromDate:startDate];
    NSString *endSrting = [dateFormatter stringFromDate:endDate];
    
    timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startString,endSrting ];
    timeLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    timeLabel.textColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    timeLabel.textAlignment=NSTextAlignmentRight;
    [self.topView addSubview:timeLabel];
    
    
}
#pragma mark - 响应事件
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
-(void)rightBtnClick:(id)sender
{
    if (menuView.frame.size.height==0)
    {
        [self dateChooseShow];
    }
    else
    {
        [self dateChooseHide];
    }
}
-(void)dateBtnClick:(id)sender
{
    UIButton *btn=sender;
    if (formerTag==btn.tag)
    {
        [self dateChooseHide];
        return;
    }
    
    formerTag=btn.tag;
    
    //修改时间段
    [self changeDatePeriodTag:btn.tag];
    [self dateChooseHide];
    
    //重新获取数据
    [self getData];
    //重新加载视图
    [self createChart];
    //重新加载tableview
    [tableview reloadData];
    
    
    //修改时间段label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *startString = [dateFormatter stringFromDate:startDate];
    NSString *endSrting = [dateFormatter stringFromDate:endDate];
    timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startString,endSrting ];
}

-(void)dateChooseShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:0.3];
    menuView.frame=CGRectMake(IPAD_WIDTH-121-15, 44, 121, 44*2);
    [UIView commitAnimations];
    backView.alpha=0.1;
}
-(void)dateChooseHide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:0.3];
    menuView.frame=CGRectMake(IPAD_WIDTH-15, 44, 0, 0);
    [UIView commitAnimations];
    backView.alpha=0;
}
-(void)changeDatePeriodTag:(NSInteger)tag
{
    PokcetExpenseAppDelegate *appDelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *component = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    if (tag==0)
    {
        startDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
        endDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:startDate];
    }
    else
    {
        component.year = component.year;
        component.month = component.month -11;
        component.day = 1;
        component.hour=0;
        component.minute=0;
        component.second=0;
        
        startDate = [cal dateFromComponents:component];
        NSDateComponents *comp2 = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:startDate];
        [comp2 setYear:1];
        [comp2 setMonth:0];
        [comp2 setDay:0];
        [comp2 setHour:0];
        [comp2 setMinute:0];
        [comp2 setSecond: -1 ];
        endDate =  [cal dateByAddingComponents:comp2 toDate:startDate options:0];
    }
    
}

#pragma mark - TableView 方法
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 95+424+424, 44)];
    header.backgroundColor=[UIColor whiteColor];
    
    float networthToLeft;
    networthToLeft=260;

    UILabel *month=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 95, 44)];
    month.text=@"MONTH";
    month.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    month.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    month.textAlignment=NSTextAlignmentCenter;
    [header addSubview:month];
    
    UILabel *netWorth=[[UILabel alloc]initWithFrame:CGRectMake(95, 0, 424, 44)];
    netWorth.text=@"NET WORTH";
    netWorth.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    netWorth.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    [netWorth setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:netWorth];
    
    UILabel *dif=[[UILabel alloc]initWithFrame:CGRectMake(95+424, 0, IPAD_WIDTH-424-95, 44)];
    dif.text=@"DIFFERENCE";
    dif.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    dif.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    [dif setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:dif];
    
    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    NetWorthTableViewCell_iPad *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"NetWorthTableViewCell_iPad" owner:self options:nil]lastObject];
    }
    [self configureCell:cell AtIndexpath:indexPath];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    return cell;
}
-(void)configureCell:(NetWorthTableViewCell_iPad *)cell AtIndexpath:(NSIndexPath *)indexpath
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM"];
    
    NSDate *date=[timeStrArray objectAtIndex:11-indexpath.row];
    
    NSString *dateStr=[dateFormatter stringFromDate:date];
    
    cell.monthLabel.text =  [dateStr uppercaseString];
    
    float value=[[netWorthArray objectAtIndex:11-indexpath.row] floatValue];
    if (value>=0)
    {
        cell.amountLabel.text=[appDelegate.epnc formatterString: value];
    }
    else
    {
        cell.amountLabel.text=[appDelegate.epnc formatterString: value];
        cell.amountLabel.textColor=[UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];
    }
    
    
    
    float dif=[[differenceArray objectAtIndex:indexpath.row] floatValue];
    NSString *diffText=[appDelegate.epnc formatterString: dif];
    if (dif>0)
    {
        cell.differenceLabel.text=[NSString stringWithFormat:@"+%@",diffText];
    }
    else
    {
        cell.differenceLabel.text=diffText;
    }
    
    if (indexpath.row % 2==0)
    {
        cell.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    }
    else
    {
        cell.backgroundColor=[UIColor whiteColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
