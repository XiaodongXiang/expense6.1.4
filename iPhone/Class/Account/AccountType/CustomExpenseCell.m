//
//  CustomExpenseCell.m
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "CustomExpenseCell.h"

@implementation CustomExpenseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        PokcetExpenseAppDelegate *appdelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //category
        _categoryIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15,12, 28, 28)];
        _categoryIcon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_categoryIcon];
        
        //name
        _nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(53, 9, 150, 20)];
        [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
        [_nameLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_nameLabel];
        
        //time
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 29, 150, 15)];
        [_timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [_timeLabel setTextColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0]];
        [_timeLabel setTextAlignment:NSTextAlignmentLeft];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_timeLabel];
        
        _cycleImage = [[UIImageView alloc] initWithFrame:CGRectMake(140,33, 13, 11)];
        _cycleImage.image = [UIImage imageNamed:@"icon_cycle.png"];
        _cycleImage.hidden = YES;
        [self.contentView addSubview:_cycleImage];
        
        //memo
        _memoImage = [[UIImageView alloc] initWithFrame:CGRectMake(160,33, 13, 11)];
        _memoImage.image = [UIImage imageNamed:@"icon_memo.png"];
        _memoImage.hidden = YES;
        [self.contentView addSubview:_memoImage];
        
        //photo
        _photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(180,33, 13, 11)];
        _photoImage.image = [UIImage imageNamed:@"icon_photo.png"];
        _photoImage.hidden = YES;
        [self.contentView addSubview:_photoImage];
        
        //amount
        _spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 9, SCREEN_WIDTH-230, 20)];
        _spentLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
        [_spentLabel setTextAlignment:NSTextAlignmentRight];
        [_spentLabel setBackgroundColor:[UIColor clearColor]];
        [_spentLabel setTextColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
        _spentLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_spentLabel];
        [_spentLabel setFont:[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
        
        //clear btn
        _clearBtn = [[ClearCusBtn alloc] init];
        _clearBtn.frame = CGRectMake(0, 0, 53, 53);
        [_clearBtn setImage:[UIImage imageNamed:@"icon_check3_sel.png"] forState:UIControlStateSelected];
        [_clearBtn setImage:[UIImage imageNamed:@"icon_check3.png"] forState:UIControlStateNormal];
        _clearBtn.hidden = YES;
        [self.contentView addSubview:_clearBtn];
        
        _runningBalaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 29.0, SCREEN_WIDTH-230, 15)];
        [_runningBalaceLabel setTextColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0]];
        [_runningBalaceLabel setTextAlignment:NSTextAlignmentRight];
        [_runningBalaceLabel setBackgroundColor:[UIColor clearColor]];
        _runningBalaceLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_runningBalaceLabel];
        _runningBalaceLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
        
        
    }
    return self;
}


@end
