//
//  HMJMonthTileView.m
//  KalMonth
//
//  Created by humingjing on 14-4-4.
//  Copyright (c) 2014年 APPXY_DEV. All rights reserved.
//

#import "HMJMonthTileView.h"
#import "KalDate_bill_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"
#import "BillsViewController.h"
#import "BillMonthMark.h"

extern const CGSize hmjTileSize;

@implementation HMJMonthTileView
@synthesize date,overDue,origin,monthDateFormatter,yearDateFormatter;
@synthesize  selected;
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.opaque = NO;
        self.clipsToBounds = NO;
        origin = frame.origin;
        

        

        
        headBlueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 3)];
        headBlueView.backgroundColor = [UIColor colorWithRed:18.f/255.f green:129.f/255.f blue:253.f/255.f alpha:1];
        [self addSubview:headBlueView];
        
        //选中的颜色是231，231，231，没选中是238，238，238
        rightLine = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-EXPENSE_SCALE, 0, EXPENSE_SCALE, frame.size.width)];
//        rightLine.backgroundColor = [UIColor colorWithRed:231.f/255.f green:231.f/255.f blue:231.f/255.f alpha:1];
        rightLine.backgroundColor = [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1];

        [self addSubview:rightLine];
        
        //没选中的时候有
        bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-EXPENSE_SCALE, frame.size.width, EXPENSE_SCALE)];
//        bottomLine.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1];
        bottomLine.backgroundColor = [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1];

        [self addSubview:bottomLine];
        
        monthDateFormatter = [[NSDateFormatter alloc]init];
        [monthDateFormatter setDateFormat:@"MMM"];
        
        yearDateFormatter = [[NSDateFormatter alloc]init];
        [yearDateFormatter setDateFormat:@"yyyy"];
        
        [self resetState];
    }
    return self;

}



- (void)resetState
{
    // realign to the grid
    CGRect frame = self.frame;
    frame.origin = origin;
    frame.size.height = hmjTileSize.height;
    frame.size.width = SCREEN_WIDTH/5.0;

    self.frame = frame;
	
    date = nil;
    flags.selected = NO;
    overDue = FALSE;
    [self setNeedsDisplay];
}

#pragma mark Date protocol conformance
- (void)drawRect:(CGRect)rect
{
    double width = SCREEN_WIDTH/5.0;

    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGFloat fontSize = 15.0;
	UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    UIFont *font2 = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    UIFont *unPaidBillFont = [appDelegate_iPhone.epnc getDateFont_inClaendar_WithSize:10];
	UIColor *shadowColor = nil;
	UIColor *textColor =nil;
    
    CGContextTranslateCTM(ctx, 0,0);
	
	NSString *monthText =nil;
    NSString *yearText = nil;
    
    
	monthText = [monthDateFormatter stringFromDate:[self.date NSDate]];
    yearText = [yearDateFormatter stringFromDate:[self.date NSDate]];
    
    if ([self.date isCurrentMonth] && self.selected)
    {
        [[[UIImage imageNamed:@"month_sel.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1] drawInRect:CGRectMake(0, 0,width, hmjTileSize.height)];
//        self.backgroundColor = [UIColor colorWithRed:242.f/255.f green:242.f/255.f blue:242.f/255.f alpha:1];
        headBlueView.hidden = NO;
        bottomLine.hidden = YES;
        textColor =  [appDelegate_iPhone.epnc getDateColor_inCalendar_blueColr];
    }
    else if ([self.date isCurrentMonth] && !self.selected)
    {
        [[[UIImage imageNamed:@"month.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1] drawInRect:CGRectMake(0, 0, width, hmjTileSize.height)];
//        self.backgroundColor = [UIColor whiteColor];
        headBlueView.hidden = YES;
        bottomLine.hidden = NO;
        textColor =  [appDelegate_iPhone.epnc getDateColor_inCalendar_blueColr];
    }
    else if (self.selected)
    {
        [[[UIImage imageNamed:@"month_sel.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1] drawInRect:CGRectMake(0, 0, width, hmjTileSize.height)];
//        self.backgroundColor = [UIColor colorWithRed:242.f/255.f green:242.f/255.f blue:242.f/255.f alpha:1];
        headBlueView.hidden = NO;
        bottomLine.hidden = YES;
        textColor =  [UIColor colorWithRed:89.f/255.f green:94.f/255.f blue:112.f/255.f alpha:1];
    }
    else
    {
        [[[UIImage imageNamed:@"month.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1] drawInRect:CGRectMake(0, 0, width, hmjTileSize.height)];
//        self.backgroundColor = [UIColor whiteColor];
        headBlueView.hidden = YES;
        bottomLine.hidden = NO;
        textColor =  [UIColor colorWithRed:144.f/255.f green:144.f/255.f blue:144.f/255.f alpha:1];
    }
    
    shadowColor = nil;
    
 	//NSInteger countIcon = [paidmarkArray count]>10?  10:[paidmarkArray count];
    
    CGContextTranslateCTM(ctx, 0,hmjTileSize.height);
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    
    
    //居中对齐文字
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    
    CGRect yearRect = CGRectMake(0, 5.5, width, 20);
    CGRect dateRect =  CGRectMake(0, 15, width, 30);
    NSDictionary *attrexpense_Date = @{NSForegroundColorAttributeName: textColor , NSFontAttributeName: font2,NSParagraphStyleAttributeName:ps};
    NSDictionary *attrexpense_Date_Regular = @{NSForegroundColorAttributeName: textColor , NSFontAttributeName: font,NSParagraphStyleAttributeName:ps};
    NSDictionary *attrexpense_year = @{NSForegroundColorAttributeName: [UIColor colorWithRed:111.f/255.f green:139.f/255.f blue:181.f/255.f alpha:1] , NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:10],NSParagraphStyleAttributeName:ps};
    
    //写日期上的数字
    [textColor setFill];
    if (self.selected && [self.date isCurrentMonth])
    {
            [monthText drawInRect:dateRect withAttributes:attrexpense_Date];
            [yearText drawInRect:yearRect withAttributes:attrexpense_year];
            
//            if ([self.date isCurrentMonth] && self.selected) {
//                [monthText drawInRect:dateRect withAttributes:attrexpense_Date_Regular];
//                [yearText drawInRect:yearRect withAttributes:attrexpense_year];
//            }
//            else
//            {
//                [monthText drawInRect:dateRect withAttributes:attrexpense_Date];
//                [yearText drawInRect:yearRect withAttributes:attrexpense_year];
//
//            }

    }
    else if ([self.date isCurrentMonth] && !self.selected)
        [monthText drawInRect:dateRect withAttributes:attrexpense_Date];
    else if (self.selected)
    {
        [monthText drawInRect:dateRect withAttributes:attrexpense_Date];
        [yearText drawInRect:yearRect withAttributes:attrexpense_year];
    }
    else
            [monthText drawInRect:dateRect withAttributes:attrexpense_Date_Regular];

    
    
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    NSMutableArray *VCArray=appDelegate_iphone.menuVC.navigationControllerArray;
    BillsViewController *tmpBillsViewController=(BillsViewController *)[VCArray objectAtIndex:8];
    
    BillMonthMark *oneMonthMark = [tmpBillsViewController.bvc_monthTableViewExpiredDataArray objectAtIndex:self.tag];
    
    
    if (oneMonthMark.unClearedNum>0 && [appDelegate_iphone.epnc monthCompare:[self.date NSDate] withDate:oneMonthMark.date]==0) {
        NSString *numString = [NSString stringWithFormat:@"%d",oneMonthMark.unClearedNum];
        NSDictionary *attrexpense_Date_Regular = @{NSForegroundColorAttributeName: [appDelegate_iPhone.epnc getAmountRedColor] , NSFontAttributeName: unPaidBillFont,NSParagraphStyleAttributeName:ps};
        [numString drawInRect:CGRectMake(2,  34, width-4,20) withAttributes:attrexpense_Date_Regular];
    }
    
}

- (void)setDate:(KalDate_bill_iPhone *)aDate
{
    if (date == aDate)
        return;
    date = aDate ;
    
    [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)tmpSelected
{
    if (flags.selected == tmpSelected)
        return;
    flags.selected = tmpSelected;
    [self setNeedsDisplay];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//-(void)dealloc
//{
//    [monthDateFormatter release];
//    [yearDateFormatter release];
//    [date release];
//
//    [super dealloc];
//}

@end
