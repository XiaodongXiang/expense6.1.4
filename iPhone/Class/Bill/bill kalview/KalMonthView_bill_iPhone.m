/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView_bill_iPhone.h"
#import "KalTileView_bill_iPhone.h"
#import "KalView_bill_iPhone.h"
#import "KalDate_bill_iPhone.h"
#import "KalPrivate_bill_iPhone.h"
#import "PokcetExpenseAppDelegate.h"

#import "BillFather.h"
#import "EP_BillItem.h"
#import "EP_BillRule.h"


@implementation KalMonthView_bill_iPhone

@synthesize numWeeks,isIpadShow;

- (id)initWithFrame:(CGRect)frame withShowStatus:(BOOL)s 
{
  if ((self = [super initWithFrame:frame]))
  {
      if (IS_IPHONE_6PLUS)
      {
          tileHigh = 59.14;
      }
      else if (IS_IPHONE_6)
          tileHigh = 53.57;
      else if(IS_IPHONE_5)
          tileHigh = 53.57;
      else
          tileHigh = 38;

      
    self.opaque = NO;
    self.clipsToBounds = YES;
	  isIpadShow = s;
 		  for (int i=0; i<6; i++) {
			  for (int j=0; j<7; j++) {
				  CGRect r = CGRectMake(j*SCREEN_WIDTH/7.0, i*tileHigh, SCREEN_WIDTH/7.0, tileHigh);
                  [self addSubview:[[KalTileView_bill_iPhone alloc] initWithFrame:r withShowStatus:s drawMonth:NO]];
                  
			  }
		  }
		  
	

  }
  return self;
}

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates
{
	int tileNum = 0;
	NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
	 for (KalTileView_bill_iPhone *tile in self.subviews)
		{
			[tile resetState];
			
		}
 	for (int i=0; i<3; i++) {
		for (KalDate_bill_iPhone *d in dates[i]) {
			KalTileView_bill_iPhone *tile = [self.subviews objectAtIndex:tileNum];
			[tile resetState];
			tile.date = d;
            if(i==0||i==2)
            {
                tile.showOutDate = FALSE;
					
            }
            else {
                tile.showOutDate = TRUE;
					
            }
	 	
			tile.type = dates[i] != mainDates
			? KalTileTypeAdjacent
			: [d isToday] ? KalTileTypeToday : KalTileTypeRegular;
			tileNum++;
		}
	}
	
	numWeeks = ceilf(tileNum / 7.f);
 	[self sizeToFit];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	if(!isIpadShow)
	{
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,CGSizeMake(SCREEN_WIDTH/7.0, tileHigh)}, [[UIImage imageNamed:@"kal_tile.png"] CGImage]);
	}
}

- (KalTileView_bill_iPhone *)todaysTileIfVisible
{
  KalTileView_bill_iPhone *tile = nil;
  for (KalTileView_bill_iPhone *t in self.subviews) {
    if ([t isToday]) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView_bill_iPhone *)firstTileOfMonth
{
  KalTileView_bill_iPhone *tile = nil;
  for (KalTileView_bill_iPhone *t in self.subviews) {
    if (!t.belongsToAdjacentMonth) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView_bill_iPhone *)tileForDate:(KalDate_bill_iPhone *)date
{
  KalTileView_bill_iPhone *tile = nil;
  for (KalTileView_bill_iPhone *t in self.subviews) {
    if ([t.date isEqual:date]) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (void)sizeToFit
{
	if(	  isIpadShow )
        self.height =tileHigh * 6;
 	else {
		self.height =tileHigh * numWeeks;

	}

}


- (void)paidmarkTilesForDates:(NSArray *)dates withDates1:(NSArray *)dates1 isTran:(BOOL)isTran
{
//    if(isTran)
//    {
//         /////////////////////////
//        //Kal mark type 
//        //0-not show
//        //1 - pay all
//        //2 -pay any
//        //3- not pay
//        //4-over due
//        NSInteger lastStart=0;
//        Transaction *firstTran=nil;
//        Transaction *lastTran=nil;
//        Transaction *tmpTran;
//
//        if([dates count]>0)
//        {
//            lastTran = [dates lastObject];
//            firstTran =[dates objectAtIndex:0];
//        }
//        PokcetExpenseAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        for (KalTileView *tile in self.subviews)
//        {
//            tile.totalExpAmount=0;
//            tile.totalExpPaid=0;
//            tile.totalIncAmount=0;
//            tile.totalIncPaid=0;
//            tile.isTran = TRUE;
//            if(firstTran !=nil&&lastTran!=nil)
//            {
//                if([appDelegate.epnc dateCompare:[tile.date NSDate] withDate:firstTran.dateTime]>=0
//                   &&[appDelegate.epnc dateCompare:[tile.date NSDate] withDate:lastTran.dateTime]<=0)
//                {
//                    for (int i=lastStart; i<[dates count];i++) {
//                        tmpTran = [dates objectAtIndex:i];
//                        if([appDelegate.epnc dateCompare:tmpTran.dateTime withDate:[tile.date NSDate]]==0)
//                        {
//                            if([tmpTran.transactionType isEqualToString: @"expense"])
//                            {
//                                tile.totalExpAmount +=[tmpTran.amount doubleValue];
//                                 
//                            }
//                            else {
//                                tile.totalIncAmount +=[tmpTran.amount doubleValue];
//                                 
//                            }
//                         }
//                        else     if([appDelegate.epnc dateCompare:tmpTran.dateTime withDate:[tile.date NSDate]]>0)
//                            
//                        {
//                            lastStart = i;
//                            break;
//                        }
//                    }
//                }
//            }
//        }
//        return;
//    }

    if (!isTran) {
        BillFather  *oneBillFather;
        /////////////////////////
        //Kal mark type
        //0-not show
        //1 - pay all
        //2 -pay any
        //3- not pay
        //4-over due
        NSInteger lastStart=0;
        NSInteger lastStart1=0;
        
        BillFather *firstBill=nil;
        BillFather *lastBill=nil;
        
        if([dates count] +[dates1 count] ==0)
        {
            for (KalTileView_bill_iPhone *tile in self.subviews)
            {
                tile.totalExpAmount=0;
                tile.totalExpPaid=0;
                tile.totalIncAmount=0;
                tile.totalIncPaid=0;
                tile.overDue = FALSE;
                tile.paid= FALSE;
                tile.unpaid= FALSE;
                tile.paidHalf= FALSE;
                [tile setNeedsDisplay];
                
            }
            return;
        }
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        for (KalTileView_bill_iPhone *tile in self.subviews)
        {
            tile.totalExpAmount=0;
            tile.totalExpPaid=0;
            tile.totalIncAmount=0;
            tile.totalIncPaid=0;
            tile.overDue = FALSE;
            tile.paid= FALSE;
            tile.unpaid= FALSE;
            tile.paidHalf= FALSE;
            /////////////////////////
            //Kal mark type
            //0-not show
            //1 - pay all
            //2 -pay any
            //3- not pay
            //4-over due
            if([dates count]>0)
            {
                lastBill = [dates lastObject];
                firstBill =[dates objectAtIndex:0];
            }
            else {
                lastBill = nil;
                firstBill =nil;
                
            }
            
            if(firstBill !=nil&&lastBill!=nil)
            {
                if([appDelegate.epnc dateCompare:[tile.date NSDate] withDate:firstBill.bf_billDueDate]>=0
                   &&[appDelegate.epnc dateCompare:[tile.date NSDate] withDate:lastBill.bf_billDueDate]<=0)
                {
                    for (long i=lastStart; i<[dates count];i++) {
                        oneBillFather = [dates objectAtIndex:i];
                        
                        //事件的时间与比较的时间相等，表明是这一天的事件
                        if([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[tile.date NSDate]]==0)
                        {
                            
                            NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
                            if ([oneBillFather.bf_billRecurringType isEqualToString:@"Never"])
                            {
                                [paymentArray setArray:[oneBillFather.bf_billRule.billRuleHasTransaction allObjects]];
                            }
                            else
                            {
                                [paymentArray setArray:[oneBillFather.bf_billItem.billItemHasTransaction allObjects]];
                            }
                           
                            
                            double paymentAmount = 0;
                            for (int i=0; i<[paymentArray count]; i++) {
                                Transaction *oneTrans = [paymentArray objectAtIndex:i];
                                if ([oneTrans.state isEqualToString:@"1"]) {
                                    paymentAmount += [oneTrans.amount doubleValue];

                                }
                            }
                            
                            //过期没支付完
                            if ((paymentAmount < oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]<0)) {
                                tile.overDue = 1;
                            }
                            //过期支付完
                            else if ((paymentAmount >= oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]<0)){
                                tile.paid = 1;
                            }
                            //没过期没支付
                            else if((paymentAmount ==0) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]>=0)){
                                tile.unpaid = 1;
                            }
                            //没过期 没支付完
                            else if ((paymentAmount < oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]>=0)){
                                tile.paidHalf = 1;
                            }
                            else if((paymentAmount >= oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]>=0)){
                                tile.paid =1;
                            }

                        }
                        //时间的时间比比较的时间大，那么要结束本个tile,获取下一个tile
                        else if([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[tile.date NSDate]]>0)
                        {
                            lastStart = i;
                            break;
                        }
                    }
                }
                
            }
            
            if([dates1 count]>0)
            {
                lastBill = [dates1 lastObject];
                firstBill =[dates1 objectAtIndex:0];
            }
            else {
                lastBill = nil;
                firstBill =nil;
                
            }
            if(firstBill !=nil&&lastBill!=nil)
            {
                
                if([appDelegate.epnc dateCompare:[tile.date NSDate] withDate:firstBill.bf_billDueDate]>=0
                   &&[appDelegate.epnc dateCompare:[tile.date NSDate] withDate:lastBill.bf_billDueDate]<=0)
                {
                    for (long i=lastStart1; i<[dates1 count];i++) {
                        oneBillFather = [dates1 objectAtIndex:i];
                        if([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[tile.date NSDate]]==0)
                        {
                            
                            
                            NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
                            if (oneBillFather.bf_billItem != nil) {
                                [paymentArray setArray:[oneBillFather.bf_billItem.billItemHasTransaction allObjects]];
                            }
                            else if(oneBillFather.bf_billRule != nil){
                                [paymentArray setArray:[oneBillFather.bf_billRule.billRuleHasTransaction allObjects]];
                            }
                            
                            double paymentAmount = 0;
                            for (int i=0; i<[paymentArray count]; i++) {
                                Transaction *oneTrans = [paymentArray objectAtIndex:i];
                                paymentAmount += [oneTrans.amount doubleValue];
                            }
                            
                            
                            //过期没支付完
                            if ((paymentAmount < oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]<0)) {
                                tile.overDue = 1;
                            }
                            //过期支付完
                            else if ((paymentAmount >= oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]<0))
                            {
                                tile.paid = 1;
                            }
                            //没过期没支付
                            else if((paymentAmount ==0) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]>=0)){
                                tile.unpaid = 1;
                            }

                            //没过期 没支付完
                            else if ((paymentAmount < oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]>=0)){
                                tile.paidHalf = 1;
                            }
                            //没过期 支付完
                            else
                            {
                                tile.paid = 1;

                            }

                        }
                        else if([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[tile.date NSDate]]>0)
                        {
                            lastStart1 = i;
                            break;
                        }
                    }
                }
            }
            
            [tile setNeedsDisplay];
        }

    }
}

- (void)unpaidmarkTilesForDates
{
    return;
 	for (KalTileView_bill_iPhone *tile in self.subviews)
		tile.unpaidmarked =TRUE;
	
}

@end
