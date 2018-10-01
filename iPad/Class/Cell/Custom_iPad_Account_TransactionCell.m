//
//  Custom_iPad_Account_TransactionCell.m
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "Custom_iPad_Account_TransactionCell.h"
#import "PokcetExpenseAppDelegate.h"

@implementation Custom_iPad_Account_TransactionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0,566,44)];
        [self.contentView addSubview:_bgImageView];
        
        _categoryIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 28, 28)];
        [self.contentView addSubview:_categoryIcon];
        
        _timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(58, 0, 113, 44)];
        [_timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [_timeLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_timeLabel];
        
        _payeeLabel =[[UILabel alloc] initWithFrame:CGRectMake(58+113+15, 13, 68, 17)];
        [_payeeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [_payeeLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
        [_payeeLabel setTextAlignment:NSTextAlignmentLeft];
        [_payeeLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_payeeLabel];
        
        _memoLabel=[[UILabel alloc] initWithFrame:CGRectMake(162, 17, 160, 22.0)];
        [_memoLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [_memoLabel setTextColor:[appDelegate.epnc getiPADColor_149_150_156]];
        [_memoLabel setTextAlignment:NSTextAlignmentLeft];
        [_memoLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_memoLabel];
        
        _cycleImage = [[UIImageView alloc] initWithFrame:CGRectMake(58+168+113-15-20,17, 13, 11)];
        _cycleImage.image = [UIImage imageNamed:@"icon_cycle.png"];
        _cycleImage.hidden = YES;
        [self.contentView addSubview:_cycleImage];
        
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(58+168+113-15,17, 13, 11)];
        _photoImageView.image = [UIImage imageNamed:@"icon_photo.png"];
        _photoImageView.hidden = YES;
        [self.contentView addSubview:_photoImageView];
        
        _spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(58+113+168+114-15-100, 0, 100, 44)];
        [_spentLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
        [_spentLabel setTextAlignment:NSTextAlignmentRight];
        [_spentLabel setBackgroundColor:[UIColor clearColor]];
        _spentLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_spentLabel];
        
        _runningBalanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(566-15-100, 0, 100, 44)];
        [_runningBalanceLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
        [_runningBalanceLabel setTextAlignment:NSTextAlignmentRight];
        [_runningBalanceLabel setBackgroundColor:[UIColor clearColor]];
        _runningBalanceLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_runningBalanceLabel];
        
        _clearBtn = [[ClearCusBtn alloc] init];
        _clearBtn.frame = CGRectMake(15, 8, 28, 28);
        [_clearBtn setImage:[UIImage imageNamed:@"icon_check3_sel.png"] forState:UIControlStateSelected];
        [_clearBtn setImage:[UIImage imageNamed:@"icon_check3.png"] forState:UIControlStateNormal];
        _clearBtn.hidden = YES;
        [self addSubview:_clearBtn];
    
    }
    return self;
}


@end
