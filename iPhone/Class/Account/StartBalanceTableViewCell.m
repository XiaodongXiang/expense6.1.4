//
//  StartBalanceTableViewCell.m
//  PocketExpense
//
//  Created by humingjing on 14-4-25.
//
//

#import "StartBalanceTableViewCell.h"
#import "AppDelegate_iPhone.h"

@implementation StartBalanceTableViewCell
@synthesize startBalanceLabel,amountLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        startBalanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(53, 16, 120, 20)];
        startBalanceLabel.text = NSLocalizedString(@"VC_StartBalance", nil);
        [startBalanceLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
        startBalanceLabel.adjustsFontSizeToFitWidth = YES;
        [startBalanceLabel setMinimumScaleFactor:0];
        [startBalanceLabel setTextColor:[UIColor colorWithRed:166.0/255 green:166.0/255 blue:166.0/255 alpha:1]];
        [startBalanceLabel setTextAlignment:NSTextAlignmentLeft];
        startBalanceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:startBalanceLabel];
        
        amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150-15, 16, 150, 20)];
        amountLabel.font=[appDelegate_iPhone.epnc getMoneyFont_exceptInCalendar_WithSize:17];
        [amountLabel setTextColor:[UIColor colorWithRed:166.0/255 green:166.0/255 blue:166.0/255 alpha:1]];
        [amountLabel setTextAlignment:NSTextAlignmentRight];
        amountLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:amountLabel];

        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(53, 53-EXPENSE_SCALE, SCREEN_WIDTH,EXPENSE_SCALE)];
        line.backgroundColor = [appDelegate_iPhone.epnc getColor_204_204_204];
        [self.contentView addSubview:line];
    }
    return self;
}

//- (void)awakeFromNib
//{
//    // Initialization code
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}



@end
