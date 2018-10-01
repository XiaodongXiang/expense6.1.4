//
//  CashFlowCell.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-31.
//
//

#import "CashFlowCell.h"
#import "AppDelegate_iPhone.h"
#import "EPNormalClass.h"

@implementation CashFlowCell

-(void)awakeFromNib
{
    [_dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [_dateLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
    [_dateLabel setTextAlignment:NSTextAlignmentLeft];
    [_dateLabel setBackgroundColor:[UIColor clearColor]];
    _dateLabel.adjustsFontSizeToFitWidth = YES;
    [_dateLabel setMinimumScaleFactor:0];
    
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    [_inAmountLabel setFont:[appDelegate_iPhone.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    [_inAmountLabel setTextColor:[appDelegate_iPhone.epnc getAmountGreenColor]];
    [_inAmountLabel setTextAlignment:NSTextAlignmentCenter];
    [_inAmountLabel setBackgroundColor:[UIColor clearColor]];
    _inAmountLabel.adjustsFontSizeToFitWidth = YES;
    [_inAmountLabel setMinimumScaleFactor:0];
    
    [_outamountLabel setFont:[appDelegate_iPhone.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    [_outamountLabel setTextColor:[appDelegate_iPhone.epnc getAmountRedColor]];
    [_outamountLabel setTextAlignment:NSTextAlignmentRight];
    [_outamountLabel setBackgroundColor:[UIColor clearColor]];
    _outamountLabel.adjustsFontSizeToFitWidth = YES;
    [_outamountLabel setMinimumScaleFactor:0];
    
    _lineH.constant = EXPENSE_SCALE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
