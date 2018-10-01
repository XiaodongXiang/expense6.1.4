//
//  ipad_ReportCashFlowCell.m
//  PocketExpense
//
//  Created by humingjing on 14-5-23.
//
//

#import "ipad_ReportCashFlowCell.h"
#import "PokcetExpenseAppDelegate.h"

@implementation ipad_ReportCashFlowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        PokcetExpenseAppDelegate    *appDelegate= (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
        
        _dateLabel =[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120, 50)];
        [_dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [_dateLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
        [_dateLabel setTextAlignment:NSTextAlignmentLeft];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        _dateLabel.adjustsFontSizeToFitWidth = YES;
        [_dateLabel setMinimumScaleFactor:0];
        [self.contentView addSubview:_dateLabel];


        _inAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 0, 140, 50.0)];
        [_inAmountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
        [_inAmountLabel setTextColor:[appDelegate.epnc getAmountGreenColor]];
        [_inAmountLabel setTextAlignment:NSTextAlignmentRight];
        [_inAmountLabel setBackgroundColor:[UIColor clearColor]];
        _inAmountLabel.adjustsFontSizeToFitWidth = YES;
        [_inAmountLabel setMinimumScaleFactor:0];
        [self.contentView addSubview:_inAmountLabel];
        
        _outamountLabel = [[UILabel alloc] initWithFrame:CGRectMake(280.0, 0, 140, 50.0)];
        [_outamountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
        [_outamountLabel setTextColor:[appDelegate.epnc getAmountRedColor]];
        [_outamountLabel setTextAlignment:NSTextAlignmentRight];
        [_outamountLabel setBackgroundColor:[UIColor clearColor]];
        _outamountLabel.adjustsFontSizeToFitWidth = YES;
        [_outamountLabel setMinimumScaleFactor:0];
        [self.contentView addSubview:_outamountLabel];

        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 50-EXPENSE_SCALE, 420, EXPENSE_SCALE)];
        _line.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
        [self.contentView addSubview:_line];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
