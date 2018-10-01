//
//  TranDataRect.m
//  PocketExpense
//
//  Created by MV on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TranDataRect.h"

@implementation TranDataRect
@synthesize dateStringLabel,incView,expView ;

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
    {
        incView =[[UIView alloc] initWithFrame:CGRectZero];
        
        [incView setBackgroundColor :[UIColor colorWithRed:120/255 green:208.0/255 blue:62.0/255 alpha:1.0]];
        [self addSubview:incView];


        expView =[[UIView alloc] initWithFrame:CGRectZero];
         
        [expView setBackgroundColor :[UIColor colorWithRed:255.0/255 green:84.0/255 blue:44.0/255 alpha:1 ]];
        [self addSubview:expView];
        
        dateStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-26,frame.size.width,20)];
          dateStringLabel.textAlignment = NSTextAlignmentCenter;
         [dateStringLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:9.0]];

        [dateStringLabel setTextColor:[UIColor colorWithRed:105.f/255.f green:116.f/255.f blue:119.f/255.f alpha:1]];
		[dateStringLabel setBackgroundColor:[UIColor clearColor]];
		[self addSubview:dateStringLabel];
        
        line = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-29-EXPENSE_SCALE, frame.size.width, EXPENSE_SCALE)];
        line.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
        [self addSubview:line];
      
 	}
	return self;
}
 
-(void)setViewByMaxValue:(double)mV withIncAmount:(double)iV withExpAmount:(double)eV  anmtied:(BOOL)a ;
{
    //如果最大值是0
    double h = self.frame.size.height-29;
    double w = self.frame.size.width;
    double barWith = 10;
    double expenseLocaltionX = (w-barWith*2 -1)/2;
    double incomeLocaltionX = expenseLocaltionX + 11;
    if(mV ==0  )
    {
        
        expView.frame = CGRectMake(expenseLocaltionX, h-1, barWith,  1);
        incView.frame = CGRectMake(incomeLocaltionX, h- 1, barWith, 1 );

        return;
    }

    //如果income value>0
    if(iV>0)
    {
        double tmpHigh = iV/mV*h;
        if (tmpHigh<1)
            incView.frame = CGRectMake(incomeLocaltionX, h - 1, barWith,  1);
        else
            incView.frame = CGRectMake(incomeLocaltionX, h - (iV/mV*h), barWith,  iV/mV*h);

    }
    else
    {
        incView.frame = CGRectMake(incomeLocaltionX, h - 1, barWith,  1);
    }
    
    if(eV>0)
    {
        double tmpHigh = eV/mV*h;
        if (tmpHigh<1)
            expView.frame = CGRectMake(expenseLocaltionX, h  - 1, barWith, 1);
        else
            expView.frame = CGRectMake(expenseLocaltionX, h  - (eV/mV*h), barWith, eV/mV*h );

    }
    else {
        expView.frame = CGRectMake(expenseLocaltionX, h  - 1, barWith, 1);

    }
}




@end

