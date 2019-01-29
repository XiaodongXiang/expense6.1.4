//
//  CustomSearchCell.m
//  PocketExpense
//
//  Created by 刘晨 on 16/3/3.
//
//

#import "CustomSearchCell.h"

@implementation CustomSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        //category
        _categoryIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15,12, 28, 28)];
        _categoryIcon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_categoryIcon];
        
        //name
        _nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(53, 7, (SCREEN_WIDTH - 60)/2, 20)];
        [_nameLabel setFont:[UIFont fontWithName:FontSFUITextRegular size:16]];
        [_nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        _nameLabel.minimumScaleFactor = 0.6;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_nameLabel];
        
        //time
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 29, 120, 15)];
        [_timeLabel setFont:[UIFont fontWithName:FontSFUITextRegular size:12]];
        [_timeLabel setTextColor:[UIColor colorWithRed:168.0/255 green:168.0/255 blue:168.0/255 alpha:1.0]];
        [_timeLabel setTextAlignment:NSTextAlignmentLeft];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_timeLabel];
        
        //photo
        _phontoImage = [[UIImageView alloc] initWithFrame:CGRectMake(160,29, 13, 11)];
        _phontoImage.image = [UIImage imageNamed:@"icon_photo.png"];
        _phontoImage.hidden = YES;
        [self.contentView addSubview:_phontoImage];
        
        //memo
        _memoImage = [[UIImageView alloc] initWithFrame:CGRectMake(140,29, 13, 11)];
        _memoImage.image = [UIImage imageNamed:@"icon_memo.png"];
        _memoImage.hidden = YES;
        [self.contentView addSubview:_memoImage];
        
        //amount
        _spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-(SCREEN_WIDTH - 60)/2, 16,(SCREEN_WIDTH - 60)/2, 20)];
        [_spentLabel setFont:[UIFont fontWithName:FontSFUITextRegular size:17]];
        _spentLabel.minimumScaleFactor = 0.6;
        _spentLabel.adjustsFontSizeToFitWidth = YES;
        [_spentLabel setTextAlignment:NSTextAlignmentRight];
        [_spentLabel setBackgroundColor:[UIColor clearColor]];
        [_spentLabel setTextColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
        _spentLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_spentLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(53, 53-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
        line.backgroundColor = RGBColor(238, 238, 238);
        [self.contentView addSubview:line];
        
    }
    return self;
}


@end
