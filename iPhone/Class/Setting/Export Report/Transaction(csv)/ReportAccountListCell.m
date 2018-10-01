//
//  ReportAccountListCell.m
//  PocketExpense
//
//  Created by humingjing on 14-4-22.
//
//

#import "ReportAccountListCell.h"

@implementation ReportAccountListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {



    }
    return self;
}

- (void)awakeFromNib
{

    [_headImageView setBackgroundColor:[UIColor clearColor]];
    
    [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
    [_nameLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    
    _lineH.constant = EXPENSE_SCALE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
