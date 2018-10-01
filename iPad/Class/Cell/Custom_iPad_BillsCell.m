//
//  Custom_iPad_BillsCell.m
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "Custom_iPad_BillsCell.h"
#import "PokcetExpenseAppDelegate.h"

@implementation Custom_iPad_BillsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        //        bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 330, 60)];
        //        self.backgroundView = bgImageView;
        _bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 566, 44)];
        [self.contentView addSubview:_bgImageView];
        
        //category
        _categoryIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 28, 28)];
        _categoryIconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_categoryIconImage];
        
        //name
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(203, 0, 218, 44)];
        [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [_nameLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_nameLabel];
        
        //amount
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(566-14-155, 0.0, 155.0, 44) ];
        [_amountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
        [_amountLabel setTextColor:[UIColor colorWithRed:94.f/255 green:99.f/255 blue:117.f/255 alpha:1.f]];
        [_amountLabel setTextAlignment:NSTextAlignmentRight];
        [_amountLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_amountLabel];
        
        //date
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 0, 110.0, 44)];
        [_dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [_dateLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.f]];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_dateLabel];
        
        //memo
        //		memoImage = [[UIImageView alloc] initWithFrame:CGRectMake(140,30, 20, 20)];
        //		memoImage.image = [UIImage imageNamed:@"icon_memo.png"];
        //		memoImage.hidden = YES;
        //		[self.contentView addSubview:memoImage];
        
        //paid image
        _paidStateImageView =[[UIImageView alloc] initWithFrame:CGRectMake(300,40, 8, 8)];
        _paidStateImageView.hidden = YES;
        [self.contentView addSubview:_paidStateImageView];
        
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}


@end
