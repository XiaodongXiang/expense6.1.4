/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "PokcetExpenseAppDelegate.h"
#import "Transaction.h"
#import "AppDelegate_iPad.h"

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
extern const CGSize kTileSize_iPad;
extern const CGSize kTileSize_Bill_iPad;
@implementation KalTileView

@synthesize date;
@synthesize origin;
@synthesize isBillShow,showOutDate,drawLeft;
@synthesize totalExpAmount;
@synthesize totalExpPaid;
@synthesize totalIncAmount;
@synthesize totalIncPaid;
@synthesize isTran;

@synthesize overDue;
@synthesize paid;
@synthesize unpaid;
@synthesize paidHalf;
@synthesize labelExp,labelInc;
- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self setIsAccessibilityElement:YES];
    [self setAccessibilityTraits:UIAccessibilityTraitButton];
      
//      _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-EXPENSE_SCALE, self.frame.size.width, EXPENSE_SCALE)];
//      _bottomLine.backgroundColor = [UIColor colorWithRed:232.f/255.f green:232.f/255.f blue:232.f/255.f alpha:1];
//      [self addSubview:_bottomLine];
//      
//      _rightLine = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width-EXPENSE_SCALE, 0, EXPENSE_SCALE,self.frame.size.height)];
//      _rightLine.backgroundColor = [UIColor colorWithRed:232.f/255.f green:232.f/255.f blue:232.f/255.f alpha:1];
//      [self addSubview:_rightLine];
    [self resetState];

  }
  return self;
}
- (id)initWithFrame:(CGRect)frame withShowStatus:(BOOL)s drawMonth:(BOOL)dvs;
{
    if ((self = [super initWithFrame:frame])) {
        self.opaque = NO;
        self.clipsToBounds = NO;
        origin = frame.origin;
        isBillShow= s;
        showOutDate = FALSE;
        drawLeft = FALSE;
        CGFloat borderWith;
        if (isRetina) {
            borderWith=0.25;
        }else
            borderWith=0.25;
        [[self layer]setBorderWidth:borderWith];

      [[self layer]setBorderColor:[UIColor lightGrayColor].CGColor];

        

        [self resetState];
        

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (appDelegate_iPhone.mainViewController.currentViewSelect ==0)
    {
        [self overViewShowDrawRect];
    }
    else
    {
        [self billViewShowDrawRect:rect];
    }
}

-(void)overViewShowDrawRect
{
    _rightLine.hidden = YES;
    _bottomLine.hidden = YES;
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIFont *font =  [appDelegate.epnc getDateFont_inClaendar_WithSize:17];
    UIFont  *font2 = [appDelegate.epnc GETdateFont_Regular_withSize:17];
    
    UIColor *textColor = nil;
    
    NSUInteger n = [self.date day];
    NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
    
    CGContextTranslateCTM(ctx, 0,0);

    float   imageWith = 54;
    
    if ([self isToday] && self.selected)
    {
          [[[UIImage imageNamed:@"overview_calander_bg"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] drawInRect:CGRectMake(0, 0, imageWith, imageWith)];
        textColor = [UIColor colorWithRed:79/255.0 green:193/255.0 blue:255/255.0 alpha:1];

         }
    else if ([self isToday] && !self.selected)
    {
        textColor = [UIColor colorWithRed:79/255.0 green:193/255.0 blue:255/255.0 alpha:1];
    }
    else if (self.selected)
    {
        [[[UIImage imageNamed:@"overview_calander_bg_gray"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] drawInRect:CGRectMake(0, 0, imageWith, imageWith)];
        textColor = [UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0];
        
    }
    else if (self.belongsToAdjacentMonth)
    {
        textColor=[UIColor colorWithRed:168.0/255.0 green:168.0/255.0 blue:168.0/255.0 alpha:1.0];
        
    }
    else
    {
        
        textColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1.0];
     
    }
    
    //写日期
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    CGRect dateRect =  CGRectMake(0, 12, kTileSize_iPad.width, 20);
    NSDictionary *attrexpense_Date = @{NSForegroundColorAttributeName: textColor , NSFontAttributeName: font,NSParagraphStyleAttributeName:ps};
    NSDictionary *attrexpense_Date_Regular = @{NSForegroundColorAttributeName: textColor , NSFontAttributeName: font2,NSParagraphStyleAttributeName:ps};
    [textColor setFill];
    
    if (dayText != nil) {
        
        if (self.selected || self.isToday) {
            [dayText drawInRect:dateRect withAttributes:attrexpense_Date];
            
            if (self.isToday) {
                [dayText drawInRect:dateRect withAttributes:attrexpense_Date_Regular];
            }
            
        }
        else
            [dayText drawInRect:dateRect withAttributes:attrexpense_Date];
        
    }
    
    if (self.highlighted) {
        [[UIColor colorWithWhite:0.25f alpha:0.3f] setFill];
        CGContextFillRect(ctx, CGRectMake(0.f, 0.f, kTileSize_iPad.width, kTileSize_iPad.height));
    }
    
//    for(UILabel *label in self.subviews)
//    {
//        [label removeFromSuperview];
//    }
    
   // UILabel *labelInc=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, 107, 20)];
    
    CGFloat income=[self getIncomeDataWithDate:self.date];
    NSString *incomeStr=[appDelegate.epnc formatterString:income];
    if (income>0) {
        [labelInc setText:incomeStr];
        [self addSubview:labelInc];
        
    }
    
   // UILabel *labelExp=[[UILabel alloc]initWithFrame:CGRectMake(0, 85, 107, 20)];
    CGFloat expense=[self getExpenseDataWithDate:self.date];
    NSString *expenseStr=[appDelegate.epnc formatterString:expense];
    if (expense>0) {
        [labelExp setText:expenseStr];
        [self addSubview:labelExp];
       
    }
    
   
}
-(void)billViewShowDrawRect:(CGRect) rect
{
    _rightLine.hidden = NO;
    _bottomLine.hidden = NO;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	UIFont *font =  [appDelegate.epnc getDateFont_inClaendar_WithSize:17];
    UIFont  *font2 = [appDelegate.epnc GETdateFont_Regular_withSize:17];

	UIColor *shadowColor = nil;
	UIColor *textColor =[UIColor blackColor];
    
    CGContextTranslateCTM(ctx, 0,0);
	
	NSString *dayText =nil;
	NSUInteger n=0;
	if(showOutDate)
	{
        n= [self.date day];
		if(n!=0)
            dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
	}
	
    if ([self isToday] && self.selected)
    {
        [[[UIImage imageNamed:@"overview_calander_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] drawInRect:CGRectMake(0, 0, kTileSize_Bill_iPad.width, kTileSize_Bill_iPad.height)];
           textColor = [UIColor colorWithRed:79/255.0 green:193/255.0 blue:255/255.0 alpha:1];
    }
    else if ([self isToday] && !self.selected)
    {
        [[UIImage imageNamed:@"ipad_calendar_90_94.png"] drawInRect:CGRectMake(0, 0, kTileSize_Bill_iPad.width, kTileSize_Bill_iPad.height)];
        textColor = [UIColor colorWithRed:79/255.0 green:193/255.0 blue:255/255.0 alpha:1];
    }
    else if (self.selected)
    {
        [[[UIImage imageNamed:@"overview_calander_bg_gray"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] drawInRect:CGRectMake(0, 0, kTileSize_Bill_iPad.width, kTileSize_Bill_iPad.height)];
         textColor = [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    }
    else if (self.belongsToAdjacentMonth)
    {
        
        [[UIImage imageNamed:@"ipad_calendar_90_94.png"]drawInRect:CGRectMake(0, 0, kTileSize_Bill_iPad.width, kTileSize_Bill_iPad.height)];
    }
    else
    {
        [[UIImage imageNamed:@"ipad_calendar_90_94.png"]  drawInRect:CGRectMake(0, 0, kTileSize_Bill_iPad.width, kTileSize_Bill_iPad.height)];
          textColor=[appDelegate.epnc getGrayColor_94_99_77];
    }
    shadowColor = nil;

    //设置paid unpaid图片
    if(!isTran)
    {
        NSMutableArray * paidmarkArray =[[NSMutableArray alloc] init];
        if(unpaid)
            [paidmarkArray addObject:[NSNumber numberWithInt:3]];
        if(overDue)
            [paidmarkArray addObject:[NSNumber numberWithInt:4]];
        
        if(paid)
            [paidmarkArray addObject:[NSNumber numberWithInt:1]];;
        if(paidHalf)
            [paidmarkArray addObject:[NSNumber numberWithInt:2]];;
        
        double rectLength = 0.0;
        double rectOffSet = 0.0;
        
        NSInteger delx =24;
        NSInteger dely =0;
        
        rectLength =12.f;
        rectOffSet = 10.f;
        dely = 11;
        
        for (int i=0; i<[paidmarkArray count]; i++)
        {
            UIImage *markerImage  = nil;
            if([[paidmarkArray objectAtIndex:i] intValue] == 1)
            {
                markerImage = [UIImage imageNamed:@"mark_green.png"];
            }
            else if([[paidmarkArray objectAtIndex:i] intValue] == 2)
            {
                markerImage = [UIImage imageNamed:@"mark_green2.png"];
            }
            else if([[paidmarkArray objectAtIndex:i] intValue] == 3)
            {
                markerImage = [UIImage imageNamed:@"mark_gray.png"];
            }
            else if([[paidmarkArray objectAtIndex:i] intValue] == 4)
            {
                markerImage = [UIImage imageNamed:@"mark_red.png"];
            }
            [markerImage drawInRect:CGRectMake(delx,i*rectOffSet+24, 6,6)];
        }
        
    }
    
    //写日期上的数字
    //右对齐文字
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    
    CGRect dateRect =  CGRectMake(0, 2, 54, 20);
    NSDictionary *attrexpense_Date = @{NSForegroundColorAttributeName: textColor , NSFontAttributeName: font,NSParagraphStyleAttributeName:ps};
    NSDictionary *attrexpense_Date_Regular = @{NSForegroundColorAttributeName: textColor , NSFontAttributeName: font2,NSParagraphStyleAttributeName:ps};
    

    
    [textColor setFill];
    if(dayText !=nil)
    {
        if (self.selected || self.isToday)
        {
            [dayText drawInRect:dateRect withAttributes:attrexpense_Date];
            if (self.isToday)
            {
                [dayText drawInRect:dateRect withAttributes:attrexpense_Date_Regular];
            }
            
        }
        else
            [dayText drawInRect:dateRect withAttributes:attrexpense_Date];
    }
    
    if (self.highlighted)
    {
        [[UIColor colorWithWhite:0.25f alpha:0.3f] setFill];
        CGContextFillRect(ctx, CGRectMake(0.f, 0.f, rect.size.width, rect.size.height));
    }
    

    
    
    NSMutableArray * paidmarkArray =[[NSMutableArray alloc] init];
    if(unpaid) [paidmarkArray addObject:[NSNumber numberWithInt:3]];
    if(overDue)[paidmarkArray addObject:[NSNumber numberWithInt:4]];
    
    if(paid)[paidmarkArray addObject:[NSNumber numberWithInt:1]];;
    if(paidHalf)[paidmarkArray addObject:[NSNumber numberWithInt:2]];;
    
    double rectLength = 0.0;
    double rectOffSet = 0.0;
    
    NSInteger dely =0;
    
    rectLength =12.f;
    rectOffSet = 10.f;
    dely = 11;
    
    for (int i=0; i<[paidmarkArray count]; i++)
    {
        UIImage *markerImage  = nil;
        if([[paidmarkArray objectAtIndex:i] intValue] == 1)
        {
            markerImage = [UIImage imageNamed:@"mark_green.png"];
        }
        else if([[paidmarkArray objectAtIndex:i] intValue] == 2)
        {
            markerImage = [UIImage imageNamed:@"mark_green2.png"];
        }
        else if([[paidmarkArray objectAtIndex:i] intValue] == 3)
        {
            markerImage = [UIImage imageNamed:@"mark_gray.png"];
        }
        else if([[paidmarkArray objectAtIndex:i] intValue] == 4)
        {
            markerImage = [UIImage imageNamed:@"mark_red.png"];
        }
        [markerImage drawInRect:CGRectMake(SCREEN_WIDTH/7/2-3,11+i*9,6,6)];
        
    }
    

	
}


-(CGFloat)getIncomeDataWithDate:(KalDate *)kalDate
{    NSDate *tmpStartDate=[kalDate NSDate];
    NSDate *tmpEndDate= [tmpStartDate dateByAddingTimeInterval:86399.f];

    if (tmpEndDate!=nil &&tmpStartDate!=nil) {
      PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
   
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
    NSFetchRequest *requst=[[NSFetchRequest alloc]init];
    [requst setEntity:entity];
      NSPredicate *pridicate=[NSPredicate predicateWithFormat:@"(dateTime >=%@)AND(dateTime <=%@) AND (transactionType ==%@)AND (childTransactions.@count == %i)" , tmpStartDate,tmpEndDate,@"income",0];
    [requst setPredicate:pridicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [requst setSortDescriptors:sortDescriptors];
    NSError *error=nil;
    NSArray *array=[appDelegate.managedObjectContext executeFetchRequest:requst error:&error];
        CGFloat income=0;
        for(Transaction *transaction in array)
        {
            income+=[transaction.amount floatValue];
            
        }
        return income;

    }
    return 0;
    
 
}
-(CGFloat)getExpenseDataWithDate:(KalDate *)kalDate
{
    NSDate *tmpStartDate=[kalDate NSDate];

    NSDate *tmpEndDate= [tmpStartDate dateByAddingTimeInterval:86399.f];
    
    if (tmpEndDate!=nil &&tmpStartDate!=nil) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
        NSFetchRequest *requst=[[NSFetchRequest alloc]init];
        [requst setEntity:entity];
        NSPredicate *pridicate=[NSPredicate predicateWithFormat:@"(dateTime >=%@)AND(dateTime <=%@) AND (transactionType ==%@)AND (childTransactions.@count == %i)" , tmpStartDate,tmpEndDate,@"expense",0];
        [requst setPredicate:pridicate];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
        NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
        [requst setSortDescriptors:sortDescriptors];
  
        NSError *error=nil;
        NSArray *array=[appDelegate.managedObjectContext executeFetchRequest:requst error:&error];
        CGFloat expense=0;
        for(Transaction *transaction in array)
        {
            expense+=[transaction.amount floatValue];
            
        }
        return expense;
        
    }
    return 0;

}

- (void)resetState
{

  
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
}

- (void)setDate:(KalDate *)aDate
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
//  if (![self isToday]) {
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
//  }
  
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

- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
    return;
  
  // workaround since I cannot draw outside of the frame in drawRect:
//  CGRect rect = self.frame;
//  if (tileType == KalTileTypeToday) {
//    rect.origin.x--;
//    rect.size.width++;
//    rect.size.height++;
//  } else if (flags.type == KalTileTypeToday) {
//    rect.origin.x++;
//    rect.size.width--;
//    rect.size.height--;
//  }
//  self.frame = rect;
  
  flags.type = tileType;
  [self setNeedsDisplay];
}

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }



@end
