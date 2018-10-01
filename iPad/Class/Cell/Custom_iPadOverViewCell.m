//
//  Custom_iPadOverViewCell.m
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "Custom_iPadOverViewCell.h"
#import "PokcetExpenseAppDelegate.h"


@implementation Custom_iPadOverViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        
        _categoryIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 23, 23)];
        _categoryIconImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_categoryIconImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(53, 7, 120, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1];
        [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        _accountNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(53, 31, 200, 15)];
        _accountNameLabel.backgroundColor = [UIColor clearColor];
        _accountNameLabel.textColor = [UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1];
        [_accountNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        _accountNameLabel.textAlignment = NSTextAlignmentLeft;
        _accountNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_accountNameLabel];
        
        _amountLabel=[[UILabel alloc]initWithFrame:CGRectMake(378-15-200, 0, 200, 53)];
        _amountLabel.backgroundColor = [UIColor clearColor];
        [_amountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
        _amountLabel.textAlignment = NSTextAlignmentRight;
        _amountLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_amountLabel];
        
        UIView *bottomLine=[[UIView alloc]initWithFrame:CGRectMake(53, 53-EXPENSE_SCALE, 310, EXPENSE_SCALE)];
        bottomLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [self.contentView addSubview:bottomLine];
        
        
    }
    return self;
}


@end
