/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView_bill_iPhone.h"
#import "KalDate_bill_iPhone.h"
#import "KalPrivate_bill_iPhone.h"
#import "PokcetExpenseAppDelegate.h"
extern const CGSize kTileSize_iPad;

@implementation KalTileView_bill_iPhone

@synthesize date,isIpadShow,showOutDate,drawLeft;
@synthesize totalExpAmount;
@synthesize totalExpPaid;
@synthesize totalIncAmount;
@synthesize totalIncPaid;
@synthesize isTran;

@synthesize overDue;
@synthesize paid;
@synthesize unpaid;
@synthesize paidHalf;

- (id)initWithFrame:(CGRect)frame withShowStatus:(BOOL)s drawMonth:(BOOL)dvs;
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
     self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    origin = frame.origin;
	  isIpadShow = s;
	  showOutDate = FALSE;
	  drawLeft = FALSE;
    
//      _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-EXPENSE_SCALE, self.frame.size.width, EXPENSE_SCALE)];
//      _bottomLine.backgroundColor = [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1];
//      [self addSubview:_bottomLine];
//      
//      _rightLine = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width-EXPENSE_SCALE, 0, EXPENSE_SCALE, self.frame.size.height)];
//      _rightLine.backgroundColor = [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1];
//      [self addSubview:_rightLine];
      [self resetState];
      
      if (IS_IPHONE_6PLUS)
      {
          tileHigh = SCREEN_WIDTH/7;
      }
      else if (IS_IPHONE_6)
          tileHigh = SCREEN_WIDTH/7;
      else if(IS_IPHONE_5)
          tileHigh = 375/7;
      else
          tileHigh = 38;
  }
  return self;
}


#pragma mark Date protocol conformance
- (void)drawRect:(CGRect)rect
{
    
    PokcetExpenseAppDelegate *appDelegate_iphone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    double with = SCREEN_WIDTH/7.0;

	CGContextRef ctx = UIGraphicsGetCurrentContext();
	UIFont *font =  [appDelegate_iphone.epnc getDateFont_inClaendar_WithSize:17];
    UIFont  *font2 = [UIFont fontWithName:@"HelveticaNeue" size:17];
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
        
        [[UIImage imageNamed:@"day_calendar2_1_sel.png"]  drawInRect:CGRectMake(0, 0,  with, tileHigh)];
        textColor = [UIColor colorWithRed:122/255.0 green:210/255.0 blue:254/255.0 alpha:1];

    }
    else if ([self isToday] && !self.selected) 
    {
        [[UIImage imageNamed:@"day_calendar_1.png"]  drawInRect:CGRectMake(0, 0,  with, tileHigh)];
        textColor = [UIColor colorWithRed:122/255.0 green:210/255.0 blue:254/255.0 alpha:1];
    }
    else if (self.selected)
    {
        [[UIImage imageNamed:@"day_calendar_1_sel.png"]  drawInRect:CGRectMake(0, 0,  with, tileHigh)];
        textColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];

   }
    else if (self.belongsToAdjacentMonth) 
    {
    
        [[UIImage imageNamed:@"day_calendar_1.png"]  drawInRect:CGRectMake(0, 0,  with, tileHigh)];
        textColor =  [UIColor clearColor] ;
    }
    else  
    {
        [[UIImage imageNamed:@"day_calendar_1.png"]  drawInRect:CGRectMake(0, 0,  with, tileHigh)];
        textColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    }
				
    shadowColor = nil;

 	//NSInteger countIcon = [paidmarkArray count]>10?  10:[paidmarkArray count];
    
    CGContextTranslateCTM(ctx, 0,tileHigh);
    CGContextScaleCTM(ctx, 1, -1);
    if(!isTran)
    {
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

    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1, -1);

    //写交易的金额以及背景
    if(isTran)
    {

        
        
        double startY ;
        double roundOriginX = 3;
        startY =rect.size.height- 25.0;
        if(totalExpAmount>0 &&totalIncAmount>0)
        {     
            if((totalExpAmount-totalExpPaid >0.0)&&(totalIncAmount-totalIncPaid >0.0))
            {
                {
                     [[UIColor colorWithRed:232.0/255 green:92.0/255 blue:92.0/255 alpha:1] setFill];
                   

                    CGContextAddRect(ctx, CGRectMake(roundOriginX, rect.size.height-36, rect.size.width-2, 18));
                     
                    CGContextFillPath(ctx); 

                    [[UIColor colorWithRed:66.0/255.0 green:194.0/255.0 blue:135.0/255.0 alpha:1.f] setFill];
                        
                     CGContextAddRect(ctx, CGRectMake(roundOriginX, rect.size.height-18, rect.size.width-2, 18));
                     
                    CGContextFillPath(ctx); 
                     [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.f ] setFill];
                    
                    
                }
             }
            else  if((totalExpAmount-totalExpPaid >0.0)&&(totalIncAmount-totalIncPaid <=0.0))
            {
    
                {
                    [[UIColor colorWithRed:232.0/255 green:92.0/255 blue:92.0/255 alpha:1] setFill];
                    

                    
                    CGContextAddRect(ctx, CGRectMake(roundOriginX, rect.size.height-18, rect.size.width-2, 18));
                    //CGContextClosePath(ctx); 
                    CGContextFillPath(ctx); 
                    [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.f ] setFill];
                     
                    
                 }

             }
            else  if((totalExpAmount-totalExpPaid <=0.0)&&(totalIncAmount-totalIncPaid >0.0))
            {
//                NSString *incomeString =[appDelegate.epnc formatterString:totalIncAmount-totalIncPaid];
                
                {
                    [[UIColor colorWithRed:66.0/255.0 green:194.0/255.0 blue:135.0/255.0 alpha:1.f] setFill];
                    
                    CGContextAddRect(ctx, CGRectMake(roundOriginX, rect.size.height-18, rect.size.width-2, 18));
                    CGContextFillPath(ctx);
                    [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.f ] setFill];
//                    [incomeString drawAtPoint:CGPointMake(2, rect.size.height-16) withFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0]];

                }
                
         }
            
        }
        else if(totalExpAmount>0 )
        {
            if(totalExpAmount-totalExpPaid>0)
            {
                
                //如果有交易的话，就写文字，以及画背景长条块
               // if(isTran)
                {
                    [[UIColor colorWithRed:232.0/255 green:92.0/255 blue:92.0/255 alpha:1] setFill];

                    
                    CGContextAddRect(ctx, CGRectMake(roundOriginX, rect.size.height-18, rect.size.width-0.5, 18));
                    CGContextFillPath(ctx);
                    [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.f ] setFill];

                }

            }
        }
        else if(totalIncAmount>0 ){
            if(totalIncAmount-totalIncPaid>0)
            {
                

                {
                    [[UIColor colorWithRed:66.0/255.0 green:194.0/255.0 blue:135.0/255.0 alpha:1.f] setFill];
                    
                    CGContextAddRect(ctx, CGRectMake(roundOriginX, rect.size.height-18, rect.size.width-2, 18));
                    CGContextFillPath(ctx);
                    [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.f ] setFill];
                }

            }
        }
        CGContextStrokePath(ctx);

    }
    
    //右对齐文字
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    
    CGRect dateRect =  CGRectMake(0, 1, SCREEN_WIDTH/7, 20);
    NSDictionary *attrexpense_Date = @{NSForegroundColorAttributeName: textColor , NSFontAttributeName: font,NSParagraphStyleAttributeName:ps};
    NSDictionary *attrexpense_Date_Regular = @{NSForegroundColorAttributeName: textColor , NSFontAttributeName: font2,NSParagraphStyleAttributeName:ps};
    
    //写日期上的数字
    CGSize textSize = [dayText sizeWithAttributes:attrexpense_Date];

	CGFloat textX, textY;
	textX =  roundf(0.5f * (rect.size.width - textSize.width));
    textY =  rect.size.height-  roundf(0.5f * (rect.size.height - textSize.height))*2-10.f;

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


}

- (void)resetState
{
  // realign to the grid
CGRect frame = self.frame;
		frame.origin = origin;
		frame.size.height = tileHigh;
		self.frame = frame;
	
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
    overDue = FALSE;
    paid =FALSE;
    unpaid=FALSE;
    paidHalf =FALSE;

	//if(paidmarkArray == nil) paidmarkArray = [[NSMutableArray alloc] init];
	//[paidmarkArray removeAllObjects];
   flags.paidmarked = NO;
	  totalExpAmount=0.0;
	  totalExpPaid=0.0;
	  totalIncAmount=0.0;
	  totalIncPaid=0.0;
	
	 [self setNeedsDisplay];

}

- (void)setDate:(KalDate_bill_iPhone *)aDate
{
  if (date == aDate)
    return;
  date = aDate;

  [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
  if (flags.selected == selected)
    return;

  // workaround since I cannot draw outside of the frame in drawRect:
  if (![self isToday]) {
 //   CGRect rect = self.frame;
//    if (selected) {
//      rect.origin.x--;
//      rect.size.width++;
//      rect.size.height++;
//    } else {
//      rect.origin.x++;
//      rect.size.width--;
//      rect.size.height--;
//    }
//	  if (selected) 
//	  {
//		  rect.origin.x;
//		  rect.size.width;
//		  rect.size.height;
//	  } else {
//		  rect.origin.x;
//		  rect.size.width;
//		  rect.size.height;
//	  }
  //  self.frame = rect;
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

- (BOOL)isPaidMarked { return flags.paidmarked; }
- (BOOL)isUnpaidMarked { return flags.unpaidmarked; }
//
- (void)setPaidmarked:(BOOL)marked
{
	[self setNeedsDisplay];

//  if (flags.paidmarked == marked)
//    return;
//  flags.paidmarked = marked;
//  [self setNeedsDisplay];
}

- (void)setUnpaidmarked:(BOOL)marked
{
	[self setNeedsDisplay];
//	flags.unpaidmarked = marked;

//	if (flags.unpaidmarked == marked)
//		return;
//	flags.unpaidmarked = marked;
//	[self setNeedsDisplay];
}


- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
    return;
  // workaround since I cannot draw outside of the frame in drawRect:
//  CGRect rect = self.frame;
//  if (tileType == KalTileTypeToday) 
//  {
//    rect.origin.x;
//    rect.size.width;
//    rect.size.height;
//  } 
//  else 
//  {
//    rect.origin.x;
//    rect.size.width;
//    rect.size.height;
//  }
//  self.frame = rect;
  flags.type = tileType;
  [self setNeedsDisplay];
}
- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }



@end
