//
//  payeeSettingCell.m
//  PocketExpense
//
//  Created by humingjing on 14-5-27.
//
//

#import "PayeeSettingCell.h"

@implementation PayeeSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        _payeeLabel =[[UILabel alloc] initWithFrame:CGRectMake(15, 1, SCREEN_WIDTH - 80, 30.0)];
        [_payeeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0]];
        [_payeeLabel setTextColor:[UIColor  colorWithRed:94/255.f green:94/255.f blue:94/255.f alpha:1]];
        [_payeeLabel setTextAlignment:NSTextAlignmentLeft];
        [_payeeLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_payeeLabel];
        
        
        _categoryLabel =[[UILabel alloc] initWithFrame:CGRectMake(15, 25  , 160, 20.0) ];
        [_categoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
        [_categoryLabel setTextColor:[UIColor colorWithRed:166.0/255 green:166.0/255 blue:166.0/255 alpha:1]];
        [_categoryLabel setTextAlignment:NSTextAlignmentLeft];
        [_categoryLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_categoryLabel];
        
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 50-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
        _line.backgroundColor = [UIColor colorWithRed:218/255.f green:218/255.f blue:218/255.f alpha:1];
        [self.contentView addSubview:_line];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

@end
