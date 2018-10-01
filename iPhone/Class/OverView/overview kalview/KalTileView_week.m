/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView_week.h"
#import "KalDate_week.h"
#import "KalPrivate_week.h"

#import "PokcetExpenseAppDelegate.h"


@implementation KalTileView_week

@synthesize date;
@synthesize totalExpAmount,totalExpPaid,totalIncAmount,totalIncPaid,showOutDate;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
      
    self.opaque = NO;
    self.clipsToBounds = NO;
      showOutDate = NO;
    origin = frame.origin;
    [self setIsAccessibilityElement:YES];
    [self setAccessibilityTraits:UIAccessibilityTraitButton];
    [self resetState];
    
      if (IS_IPHONE_5)
      {
          tileHigh=375/7;
      }
      else
      {
          tileHigh=SCREEN_WIDTH/7;
      }
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    PokcetExpenseAppDelegate *appDelegate_iphone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//    //---非Pad
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    UIFont *font =  [appDelegate_iphone.epnc getDateFont_inClaendar_WithSize:17];
//    UIFont  *font2 = [appDelegate_iphone.epnc GETdateFont_Regular_withSize:17];
//
//    UIColor *shadowColor = nil;
//    UIColor *textColor;
//    
//    CGContextTranslateCTM(ctx, 0,0);
//    
//    
//    NSString *dayText = nil;
//    
//    //---位置是自下而上的
//    if (showOutDate) {
//        NSUInteger n = [self.date day];
//        dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
//    }
//    
//
    UIColor *dateColor;

    //选中&今天 蓝色
    if ([self isToday] && self.selected)
    {
        [[UIImage imageNamed:@"date_blue.png"] drawInRect:CGRectMake(0, 0,self.frame.size.width, self.height)];

        dateColor=[UIColor colorWithRed:61/255.0 green:190/255.0 blue:255/255.0 alpha:1];


    }
    //今天没选中，淡灰
    else if ([self isToday] && !self.selected)
    {
        [[UIImage imageNamed:@"date.png"] drawInRect:CGRectMake(0, 0, self.frame.size.width, self.height)];
        dateColor=[UIColor colorWithRed:61/255.0 green:190/255.0 blue:255/255.0 alpha:1];

    }
    //选中 & !今天 深灰色
    else if (self.selected)
    {
        
        [[[UIImage imageNamed:@"date_gray.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] drawInRect:CGRectMake(0, 0, self.frame.size.width, self.height)];
        dateColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];

    }
    else if (self.belongsToAdjacentMonth)
    {
        [[UIImage imageNamed:@"date.png"]drawInRect:CGRectMake(0, 0, SCREEN_WIDTH/7.0, self.height)];
        dateColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];

    }
    else
    {
        
        [[UIImage imageNamed:@"date.png"]  drawInRect:CGRectMake(0, 0, self.frame.size.width, self.height)];
        dateColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];

    }
//
//    
//    shadowColor = nil;
//    
//    //右对齐文字
//    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
//    [ps setAlignment:NSTextAlignmentRight];
//    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    
    
//    {
//        NSDictionary *attrexpense = @{NSForegroundColorAttributeName: [UIColor colorWithRed:255.0/255 green:93.0/255 blue:106.0/255 alpha:1] , NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0],NSParagraphStyleAttributeName:ps};
//        NSDictionary *attrincome = @{NSForegroundColorAttributeName: [UIColor colorWithRed:28/255.0 green:201.0/255.0 blue:70.0/255.0 alpha:1.f], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0],NSParagraphStyleAttributeName:ps};
//        
//        
////        CGRect expenseRect =  CGRectMake(2, 25.5, SCREEN_WIDTH/7.0-9, 30);
////        CGRect incomeRect = CGRectMake(2, 36.5, SCREEN_WIDTH/7.0-9, 30);
//        double incomeTextBottom = 0;
//        double expenseTextBottom = 0;
//        if (IS_IPHONE_6PLUS)
//        {
//            incomeTextBottom = 7;
//            expenseTextBottom = 21;
//        }
//        else if (IS_IPHONE_6)
//        {
//            incomeTextBottom = 6;
//            expenseTextBottom = 16;
//        }
//        else
//        {
//            incomeTextBottom = 5;
//            expenseTextBottom = 16;
//        }
//
//        
        //设置金额的显示text
        NSString *expenseAmountString;
        if (totalExpAmount<100000)//100k-1
        {
            expenseAmountString = [appDelegate_iphone.epnc formatterStringWithOutCurrency:totalExpAmount];
        }
        else if (totalExpAmount<100000000)//100k --- 100m-1
            expenseAmountString =[NSString stringWithFormat:@"%.0f k", totalExpAmount/1000];
        else if(totalExpAmount < 100000000000)//100m -- 100b-1
            expenseAmountString =[NSString stringWithFormat:@"%.0f m", totalExpAmount/1000000.0];
        else
            expenseAmountString =[NSString stringWithFormat:@"%.0f b", totalExpAmount/1000000000.0];
        
        NSString *incomeAmountString;
        if (totalIncAmount<100000)//100k-1
        {
            incomeAmountString = [appDelegate_iphone.epnc formatterStringWithOutCurrency:totalIncAmount];
        }
        else if (totalIncAmount<100000000)//100k --- 100m-1
            incomeAmountString =[NSString stringWithFormat:@"%.0f k", totalIncAmount/1000.0];
        else if(totalIncAmount < 100000000000)//100m -- 100b-1
            incomeAmountString =[NSString stringWithFormat:@"%.0f m", totalIncAmount/1000000];
        else
            incomeAmountString =[NSString stringWithFormat:@"%.0f m", totalIncAmount/1000000000];

    
    UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/7-8-30, 2, 30, 20)];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
    [dateLabel setTextAlignment:NSTextAlignmentRight];
    NSUInteger n = [self.date day];
    dateLabel.text=[NSString stringWithFormat:@"%lu", (unsigned long)n];
    dateLabel.textColor=dateColor;
    [self addSubview:dateLabel];

    UILabel *expenseLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/7-8-50, self.height-26, 50, 13)];
    [expenseLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
    [expenseLabel setTextAlignment:NSTextAlignmentRight];
    
    if (![expenseAmountString isEqualToString:@"0"])
    {
        expenseLabel.text=expenseAmountString;
    }
    expenseLabel.textColor=[UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];
    [self addSubview:expenseLabel];
    
    UILabel *incomeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/7-8-50, self.height-13, 50, 13)];
    [incomeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
    [incomeLabel setTextAlignment:NSTextAlignmentRight];
    if (![incomeAmountString isEqualToString:@"0"])
    {
        incomeLabel.text=incomeAmountString;
    }
    incomeLabel.textColor=[UIColor colorWithRed:28/255.0 green:201/255.0 blue:70/255.0 alpha:1];
    [self addSubview:incomeLabel];
    
    _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-EXPENSE_SCALE, self.frame.size.width, EXPENSE_SCALE)];
    _bottomLine.backgroundColor = [UIColor colorWithRed:233/255.f green:233/255.f blue:233/255.f alpha:1];
    [self addSubview:_bottomLine];
    
    if (self.highlighted)
    {

    }


}




- (void)resetState
{  
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
}

- (void)setDate:(KalDate_week *)aDate
{
  if (date == aDate)
    return;

  date = aDate ;

  [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
  if (flags.selected == selected)
    return;

  // workaround since I cannot draw outside of the frame in drawRect:
  if (![self isToday]) {
//    CGRect rect = self.frame;
//    if (selected) {
//      rect.origin.x--;
//      rect.size.width++;
//      rect.size.height++;
//    } else {
//      rect.origin.x++;
//      rect.size.width--;
//      rect.size.height--;
//    }
//    self.frame = rect;
  }
  
  flags.selected = selected;
  [self setNeedsDisplay];
}

- (BOOL)isHighlighted { return flags.highlighted; }

- (void)setHighlighted:(BOOL)highlighted
{
  if (flags.highlighted == highlighted)
    return;
  
  flags.highlighted = highlighted;
  [self setNeedsDisplay];
}

- (BOOL)isMarked { return flags.marked; }

- (void)setMarked:(BOOL)marked
{
  if (flags.marked == marked)
    return;
  
  flags.marked = marked;
  [self setNeedsDisplay];
}

- (KalTileType_week)type { return flags.type; }

- (void)setType:(KalTileType_week)tileType
{
  if (flags.type == tileType)
    return;
  
  flags.type = tileType;
  [self setNeedsDisplay];
}

//自己做的
- (double)isTotalExpAmount { return totalExpAmount; }

- (void)setTotalExpAmount:(double)tmpTotalExpAmount
{
    if (totalExpAmount == tmpTotalExpAmount)
        return;
    
    totalExpAmount = tmpTotalExpAmount;
    [self setNeedsDisplay];
}

- (double)isTotalExpPaid { return totalExpPaid; }

- (void)setTotalExpPaid:(double)tmpTotalExpPaid
{
    if (totalExpPaid == tmpTotalExpPaid)
        return;
    
    totalExpPaid = tmpTotalExpPaid;
    [self setNeedsDisplay];
}

- (double)isTotalIncAmount { return totalIncAmount; }

- (void)setTotalIncAmount:(double)tmpTotalIncAmount
{
    if (totalIncAmount== tmpTotalIncAmount)
        return;
    
    totalIncAmount = tmpTotalIncAmount;
    [self setNeedsDisplay];
}

- (double)isTotalIncPaid { return totalIncPaid; }

- (void)setTotalIncPaid:(double)tmpTotalIncPaid
{
    if (totalIncPaid == tmpTotalIncPaid)
        return;
    
    totalIncPaid = tmpTotalIncPaid;
    [self setNeedsDisplay];
}

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }



@end
