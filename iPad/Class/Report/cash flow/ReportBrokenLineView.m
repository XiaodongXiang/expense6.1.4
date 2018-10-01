//
//  ReportBrokenLineView.m
//  PocketExpense
//
//  Created by humingjing on 14-5-23.
//
//

#import "ReportBrokenLineView.h"
#import "ipad_ReportCashFlowViewController.h"
#import "PokcetExpenseAppDelegate.h"

//纵坐标方向的总值
#define HIGH 220
#define WITH    330

//横坐标上面的小竖线
#define HIGH_WITH_MONTHlINE 3
#define LEFTVALUE_REPORT   75
#define LEFTVALUE_CASH 50

//纵坐标距离左边的距离
#define LEFTX    10
#define HIGHY    10

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation ReportBrokenLineView
@synthesize hightestAmount,lowestAmount,brokenLineDataArray;
@synthesize isIncome;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        brokenLineDataArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setArray
{
    brokenLineDataArray = [[NSMutableArray alloc]init];

}

- (void)drawRect:(CGRect)rect
{
    if ([brokenLineDataArray count]==0) {
        return;
    }
    double  itemWith = self.frame.size.width/[brokenLineDataArray count];
    //先画格子线
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *lineColor = [UIColor colorWithRed:234/255.f green:234/255.f blue:234/255.f alpha:1];
    
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, 1);
    
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, 1);
    
    //最底下的实线
    CGPoint startLinePoint1 = CGPointMake(LEFTX, HIGH + HIGHY);
    CGPoint endLinePath1 = CGPointMake(WITH+LEFTX+5,HIGH + HIGHY);
    CGContextMoveToPoint(context, startLinePoint1.x, startLinePoint1.y);
    CGContextAddLineToPoint(context, endLinePath1.x, endLinePath1.y);
    CGContextStrokePath(context);
    
    
    CGFloat lengths[] = {3,2};
    CGContextSetLineDash(context, 0, lengths,2);
    
    CGPoint startLinePoint = CGPointMake(LEFTX,HIGHY);
    CGPoint endLinePath = CGPointMake(LEFTX,HIGHY+HIGH);
    CGContextMoveToPoint(context, startLinePoint.x, startLinePoint.y);
    CGContextAddLineToPoint(context, endLinePath.x, endLinePath.y);
    CGContextStrokePath(context);
    
    //画横坐标小脚
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:234.f/255.f green:234.f/255.f blue:234.f/255.f alpha:1].CGColor);
    
    CGContextSetLineWidth(context, 1);
    
    for (int i = 0; i <=[brokenLineDataArray count]; i++)
    {
        CGContextMoveToPoint(context, LEFTX + itemWith*i , HIGHY + HIGH);
        CGContextAddLineToPoint(context,
                                LEFTX+itemWith*i,
                                rect.origin.y+HIGHY + HIGH+3);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    
    //画纵坐标小脚
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:234.f/255.f green:234.f/255.f blue:234.f/255.f alpha:1].CGColor);
    
    double yItem = HIGH/5;
    CGContextSetLineWidth(context, 1);
    
    for (int i = 0; i <6; i++)
    {
        CGContextMoveToPoint(context, LEFTX-3 , HIGHY + yItem*i);
        CGContextAddLineToPoint(context,
                                LEFTX,
                                HIGHY + yItem*i);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }



    //////////画折线图
    //dots
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    UIColor *brokenLineColor;
    if (isIncome) {
        brokenLineColor = [appDelegate.epnc  getAmountGreenColor];
    }
    else
        brokenLineColor = [appDelegate.epnc  getAmountRedColor];

    
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColor(context, CGColorGetComponents(brokenLineColor.CGColor));
    
    for (long int i=0; i<[brokenLineDataArray count]; i++) {
        
        BarChartData *oneBarCharData = [brokenLineDataArray objectAtIndex:i];
        double onePercent;
        if (hightestAmount==0) {
            onePercent = 0;
        }
        else
            onePercent = oneBarCharData.totalAmount *1.0/hightestAmount;
        //高度
        double oneLocation =(1-onePercent)*HIGH+HIGHY;
        CGContextAddArc(context, LEFTX + itemWith*i, oneLocation, 2, 0, 360, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
    //draw broken lines------expense
    CGContextSetStrokeColorWithColor(context, brokenLineColor.CGColor);
    CGContextSetLineWidth(context, 1);
    CGFloat lengths1[] = {3,0};
    CGContextSetLineDash(context, 0, lengths1,2);
    BarChartData *firstBarCharData ;
    
    double firstPercent;
    if ([brokenLineDataArray count]>0) {
        firstBarCharData = [brokenLineDataArray objectAtIndex:0];
        firstPercent = firstBarCharData.totalAmount/hightestAmount;
    }
    else
    {
        firstPercent = 0;
        
    }
    if (hightestAmount==0) {
        firstPercent=0;
    }
    
    double firstLocation =  (1-firstPercent)*HIGH + HIGHY;
    CGContextMoveToPoint(context, LEFTX, firstLocation);
    for (long int i=0; i<[brokenLineDataArray count]; i++) {
        BarChartData *oneBarCharData =[brokenLineDataArray objectAtIndex:i];
        double onePercent;
        if (hightestAmount==0) {
            onePercent = 0;
        }
        else
            onePercent = oneBarCharData.totalAmount/hightestAmount;
        
        double oneLocation =(1-onePercent)*HIGH+HIGHY;
        
        CGContextAddLineToPoint(context, LEFTX+itemWith*i, oneLocation);
    }
    CGContextStrokePath(context);

    //画大片涂层
    if (isIncome) {
        CGContextSetRGBFillColor(context, 102.f/255.f,175.f/255.f, 54.f/255.f, 0.15);
    }
    else
        CGContextSetRGBFillColor(context, 243.f/255.f, 61.f/255.f, 36.f/255.f, 0.15);
    //第一个如果不是0的话，就要多画一个点来设置正确的起始点
    if (firstPercent != 0) {
        CGContextMoveToPoint(context, LEFTX, HIGH+LEFTX);
    }
    else
        CGContextMoveToPoint(context, LEFTX, firstLocation);
    
    for (long int i=0; i<[brokenLineDataArray count]; i++) {
        BarChartData *oneBarCharData =[brokenLineDataArray objectAtIndex:i];
        double onePercent;
        if (hightestAmount==0) {
            onePercent = 0;
        }
        else
            onePercent = oneBarCharData.totalAmount/hightestAmount;
        
        double oneLocation =(1-onePercent)*HIGH+LEFTX-1;
        
        CGContextAddLineToPoint(context, LEFTX+itemWith*i, oneLocation);
        //当最后一个点不是0的时候，就要多加一个结束点
        if (i == [brokenLineDataArray count]-1) {
            if (onePercent!=0) {
                CGContextAddLineToPoint(context, LEFTX+itemWith*i, HIGH+HIGHY);
            }
        }
    }
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);

    
    //date text
    UIColor *textColor = [UIColor grayColor];
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColor(context, CGColorGetComponents(textColor.CGColor));
    
    for (long int i=0; i<[brokenLineDataArray count]; i++) {
        
        BarChartData *oneBarCharData = [brokenLineDataArray objectAtIndex:i];
        
    
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        [ps setAlignment:NSTextAlignmentLeft];
        [ps setLineBreakMode:NSLineBreakByCharWrapping];
        
        CGRect yearRect = CGRectMake(LEFTX+itemWith*i, HIGHY+HIGH+1, itemWith, 80);
        
        NSDictionary *attrexpense_year = @{NSForegroundColorAttributeName: textColor , NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:9],NSParagraphStyleAttributeName:ps};
        
        [oneBarCharData.titleString drawInRect:yearRect withAttributes:attrexpense_year];
    }

    
    
    
}

//-(void)setYValueLabelTextandFram{
//    //设置左边的金额
//    //设置位置
//    
//    double expenseHighestPercent = 0;
//    double expenseLowestPercent = 0;
//    double incomeHightestPercent = 0;
//    double incomeLowestPercent = 0;
//    
//    if (highestBetweenIncomeandExoense > 0) {
//        expenseHighestPercent = expenseHightestAmount*1.0/highestBetweenIncomeandExoense;
//        expenseLowestPercent = expenseLowestAmount*1.0/highestBetweenIncomeandExoense;
//        incomeHightestPercent = incomeHightestAmount*1.0/highestBetweenIncomeandExoense;
//        incomeLowestPercent = incomeLowestAmount *1.0 /highestBetweenIncomeandExoense;
//    }
//    
//    double leftValue = 0;
//    if (self.expenseViewController !=nil) {
//        if (IS_IPHONE_5) {
//            leftValue = 75;
//        }
//        else
//            leftValue = 46;
//    }
//    else
//        leftValue = 45;
//    float expenseHighestLabelHeigh = (leftValue + (1-expenseHighestPercent)*6*LINE_HIGHT);
//    float expenseLowestLabelHeight = (leftValue + (1-expenseLowestPercent)*6*LINE_HIGHT);
//    float incomehighestLabelHeigh = leftValue + (1-incomeHightestPercent)*6*LINE_HIGHT;
//    float incomeLowestLabelheigh = leftValue + (1-incomeLowestPercent)*6*LINE_HIGHT;
//    
//    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//    if (self.expenseViewController!=nil) {
//        self.expenseViewController.expenseHighestLabel.text = [appDelegate_iPhone.epnc formatterStringWithOutCurrency:expenseHightestAmount];
//        self.expenseViewController.expenseMiniLabel.text = [appDelegate_iPhone.epnc formatterStringWithOutCurrency:expenseLowestAmount];
//        self.expenseViewController.incomeHighestLabel.text = [appDelegate_iPhone.epnc formatterStringWithOutCurrency:incomeHightestAmount];
//        self.expenseViewController.incomeMiniLabel.text = [appDelegate_iPhone.epnc formatterStringWithOutCurrency:incomeLowestAmount];
//        
//        self.expenseViewController.expenseHighestLabel.frame = CGRectMake(0, expenseHighestLabelHeigh, 30, 30);
//        self.expenseViewController.expenseMiniLabel.frame = CGRectMake(0, expenseLowestLabelHeight, 30, 30);
//        self.expenseViewController.incomeHighestLabel.frame = CGRectMake(0, incomehighestLabelHeigh, 30, 30);
//        self.expenseViewController.incomeMiniLabel.frame = CGRectMake(0, incomeLowestLabelheigh, 30, 30);
//        
//        
//        
//    }
//    else if (self.cashDetailViewController !=nil){
//        self.cashDetailViewController.expenseHighestLabel.text = [appDelegate_iPhone.epnc formatterStringWithOutCurrency:expenseHightestAmount];
//        self.cashDetailViewController.expenseMiniLabel.text = [appDelegate_iPhone.epnc formatterStringWithOutCurrency:expenseLowestAmount];
//        self.cashDetailViewController.incomeHighestLabel.text = [appDelegate_iPhone.epnc formatterStringWithOutCurrency:incomeHightestAmount];
//        self.cashDetailViewController.incomeMiniLabel.text = [appDelegate_iPhone.epnc formatterStringWithOutCurrency:incomeLowestAmount];
//        
//        self.cashDetailViewController.expenseHighestLabel.frame = CGRectMake(0, expenseHighestLabelHeigh, 30, 30);
//        
//        self.cashDetailViewController.expenseMiniLabel.frame = CGRectMake(0, expenseLowestLabelHeight, 30, 30);
//        self.cashDetailViewController.incomeHighestLabel.frame = CGRectMake(0, incomehighestLabelHeigh, 30, 30);
//        self.cashDetailViewController.incomeMiniLabel.frame = CGRectMake(0, incomeLowestLabelheigh, 30, 30);
//    }
//    
//    NSMutableArray *arr4 = [[NSMutableArray alloc]init];
//    if (self.expenseViewController!=nil) {
//        [arr4 addObject:self.expenseViewController.expenseHighestLabel];
//        [arr4 addObject:self.expenseViewController.expenseMiniLabel];
//        [arr4 addObject:self.expenseViewController.incomeHighestLabel];
//        [arr4 addObject:self.expenseViewController.incomeMiniLabel];
//        
//    }
//    else if (self.cashDetailViewController != nil){
//        [arr4 addObject:self.cashDetailViewController.expenseHighestLabel];
//        [arr4 addObject:self.cashDetailViewController.expenseMiniLabel];
//        [arr4 addObject:self.cashDetailViewController.incomeHighestLabel];
//        [arr4 addObject:self.cashDetailViewController.incomeMiniLabel];
//    }
//    
//    //    //从小到大排
//    //    for (int i=0; i<[arr4 count]; i++)
//    //    {
//    //        UILabel *tmpLabeli = [arr4 objectAtIndex:i];
//    //        for ( int k=i+1; k<[arr4 count]-i; k++) {
//    //            UILabel *tmpLabelk = [arr4 objectAtIndex:k];
//    //            if (tmpLabeli.frame.origin.y>tmpLabelk.frame.origin.y) {
//    //
//    //                UILabel *tmpLabel3 = tmpLabeli;
//    //                arr4[i]=arr4[k];
//    //                arr4[k] = tmpLabel3;
//    //            }
//    //        }
//    //    }
//    //
//    //    for (int i=0; i<[arr4 count]; i++) {
//    //        if (i==[arr4 count]-1) {
//    //            ;
//    //        }
//    //        else{
//    //
//    //            UILabel *tmplaebl = [arr4 objectAtIndex:i];
//    //            UILabel *tmplaenl_next = [arr4 objectAtIndex:i+1];
//    //            double interval = tmplaebl.frame.origin.y - tmplaenl_next.frame.origin.y;
//    //
//    //            if (interval<6) {
//    //                //如果第后一个label与前一个label位置太近，就修改后一个label的位置
//    //                if (![tmplaebl.text isEqualToString:tmplaenl_next.text]) {
//    //                    tmplaenl_next.frame =CGRectMake(tmplaenl_next.frame.origin.x, tmplaebl.frame.origin.y-6+interval, 30, 30);
//    //                }
//    ////                if (i==0 && [tmplaebl.text intValue]!=0) {
//    ////
//    ////                    tmplaebl.frame = CGRectMake(tmplaebl.frame.origin.x, tmplaebl.frame.origin.y-10+interval, 30, 30);
//    ////                }
//    ////                else if (i==2 && [tmplaebl.text intValue]!=0)
//    ////                    tmplaebl.frame = CGRectMake(tmplaebl.frame.origin.x, tmplaebl.frame.origin.y+10-interval, 30, 30);
//    //
//    //
//    //            }
//    //        }
//    //
//    //    }
//    
//    [self setYAxisValue];
//    
//}

//-(void)setYAxisValue{
//    if (self.expenseViewController != nil) {
//        if (highestBetweenIncomeandExoense<1000) {
//            self.expenseViewController.expenseHighestLabel.text =[NSString stringWithFormat:@"%.0f", expenseHightestAmount];
//            self.expenseViewController.expenseMiniLabel.text =[NSString stringWithFormat:@"%.0f", expenseLowestAmount];
//            self.expenseViewController.incomeHighestLabel.text =[NSString stringWithFormat:@"%.0f", incomeHightestAmount];
//            self.expenseViewController.incomeMiniLabel.text =[NSString stringWithFormat:@"%.0f", incomeLowestAmount];
//        }
//        else if (highestBetweenIncomeandExoense<1000000){
//            
//            self.expenseViewController.expenseHighestLabel.text =[NSString stringWithFormat:@"%.0f k", expenseHightestAmount/1000.0];
//            self.expenseViewController.expenseMiniLabel.text =[NSString stringWithFormat:@"%.0f k", expenseLowestAmount/1000.0];
//            self.expenseViewController.incomeHighestLabel.text =[NSString stringWithFormat:@"%.0f k", incomeHightestAmount/1000.0];
//            self.expenseViewController.incomeMiniLabel.text =[NSString stringWithFormat:@"%.0f k", incomeLowestAmount/1000.0];
//        }
//        else if (highestBetweenIncomeandExoense<1000000000){
//            
//            self.expenseViewController.expenseHighestLabel.text =[NSString stringWithFormat:@"%.0f m", expenseHightestAmount/1000000];
//            self.expenseViewController.expenseMiniLabel.text =[NSString stringWithFormat:@"%.0f m", expenseLowestAmount/1000000];
//            self.expenseViewController.incomeHighestLabel.text =[NSString stringWithFormat:@"%.0f m", incomeHightestAmount/1000000];
//            self.expenseViewController.incomeMiniLabel.text =[NSString stringWithFormat:@"%.0f m", incomeLowestAmount/1000000];
//        }
//        else if(highestBetweenIncomeandExoense < 1000000000000) {
//            self.expenseViewController.expenseHighestLabel.text =[NSString stringWithFormat:@"%.0f b", expenseHightestAmount/1000000000];
//            self.expenseViewController.expenseMiniLabel.text =[NSString stringWithFormat:@"%.0f b", expenseLowestAmount/1000000000];
//            self.expenseViewController.incomeHighestLabel.text =[NSString stringWithFormat:@"%.0f b", incomeHightestAmount/1000000000];
//            self.expenseViewController.incomeMiniLabel.text =[NSString stringWithFormat:@"%.0f b", incomeLowestAmount/1000000000];
//        }
//        else{
//            self.expenseViewController.expenseHighestLabel.text =[NSString stringWithFormat:@"%.0f t", expenseHightestAmount/1000000000000];
//            self.expenseViewController.expenseMiniLabel.text =[NSString stringWithFormat:@"%.0f t", expenseLowestAmount/1000000000000];
//            self.expenseViewController.incomeHighestLabel.text =[NSString stringWithFormat:@"%.0f t", incomeHightestAmount/1000000000000];
//            self.expenseViewController.incomeMiniLabel.text =[NSString stringWithFormat:@"%.0f t", incomeLowestAmount/1000000000000];
//        }
//        
//    }
//    else if (self.cashDetailViewController != nil){
//        if (self.cashDetailViewController.cdvc_expenseOrIncomeBtn.selected)
//        {
//            self.cashDetailViewController.expenseHighestLabel.hidden = YES;
//            self.cashDetailViewController.expenseMiniLabel.hidden = YES;
//            self.cashDetailViewController.incomeHighestLabel.hidden = NO;
//            self.cashDetailViewController.incomeMiniLabel.hidden = NO;
//        }
//        else
//        {
//            self.cashDetailViewController.expenseHighestLabel.hidden = NO;
//            self.cashDetailViewController.expenseMiniLabel.hidden = NO;
//            self.cashDetailViewController.incomeHighestLabel.hidden = YES;
//            self.cashDetailViewController.incomeMiniLabel.hidden = YES;
//        }
//        
//        if (highestBetweenIncomeandExoense<1000) {
//            self.cashDetailViewController.expenseHighestLabel.text =[NSString stringWithFormat:@"%.0f", expenseHightestAmount];
//            self.cashDetailViewController.expenseMiniLabel.text =[NSString stringWithFormat:@"%.0f", expenseLowestAmount];
//            self.cashDetailViewController.incomeHighestLabel.text =[NSString stringWithFormat:@"%.0f", incomeHightestAmount];
//            self.cashDetailViewController.incomeMiniLabel.text =[NSString stringWithFormat:@"%.0f", incomeLowestAmount];
//        }
//        else if (highestBetweenIncomeandExoense<1000000){
//            
//            self.cashDetailViewController.expenseHighestLabel.text =[NSString stringWithFormat:@"%.0f k", expenseHightestAmount/1000.0];
//            self.cashDetailViewController.expenseMiniLabel.text =[NSString stringWithFormat:@"%.0f k", expenseLowestAmount/1000.0];
//            self.cashDetailViewController.incomeHighestLabel.text =[NSString stringWithFormat:@"%.0f k", incomeHightestAmount/1000.0];
//            self.cashDetailViewController.incomeMiniLabel.text =[NSString stringWithFormat:@"%.0f k", incomeLowestAmount/1000.0];
//        }
//        else if (highestBetweenIncomeandExoense<1000000000){
//            
//            self.cashDetailViewController.expenseHighestLabel.text =[NSString stringWithFormat:@"%.0f m", expenseHightestAmount/1000000];
//            self.cashDetailViewController.expenseMiniLabel.text =[NSString stringWithFormat:@"%.0f m", expenseLowestAmount/1000000];
//            self.cashDetailViewController.incomeHighestLabel.text =[NSString stringWithFormat:@"%.0f m", incomeHightestAmount/1000000];
//            self.cashDetailViewController.incomeMiniLabel.text =[NSString stringWithFormat:@"%.0f m", incomeLowestAmount/1000000];
//        }
//        else if(highestBetweenIncomeandExoense < 1000000000000) {
//            self.cashDetailViewController.expenseHighestLabel.text =[NSString stringWithFormat:@"%.0f b", expenseHightestAmount/1000000000];
//            self.cashDetailViewController.expenseMiniLabel.text =[NSString stringWithFormat:@"%.0f b", expenseLowestAmount/1000000000];
//            self.cashDetailViewController.incomeHighestLabel.text =[NSString stringWithFormat:@"%.0f b", incomeHightestAmount/1000000000];
//            self.cashDetailViewController.incomeMiniLabel.text =[NSString stringWithFormat:@"%.0f b", incomeLowestAmount/1000000000];
//        }
//        else{
//            self.cashDetailViewController.expenseHighestLabel.text =[NSString stringWithFormat:@"%.0f t", expenseHightestAmount/1000000000000];
//            self.cashDetailViewController.expenseMiniLabel.text =[NSString stringWithFormat:@"%.0f t", expenseLowestAmount/1000000000000];
//            self.cashDetailViewController.incomeHighestLabel.text =[NSString stringWithFormat:@"%.0f t", incomeHightestAmount/1000000000000];
//            self.cashDetailViewController.incomeMiniLabel.text =[NSString stringWithFormat:@"%.0f t", incomeLowestAmount/1000000000000];
//        }
//        
//    }
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
