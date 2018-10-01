//
//  ReportOverViewCell.m
//  PocketExpense
//
//  Created by APPXY_DEV on 14-3-11.
//
//

#import "ReportOverViewCell.h"
#import "ExpenseViewController.h"

@implementation ReportOverViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
		[_bgImage setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:_bgImage];
        
        _colorLabel = [[UIImageView alloc] initWithFrame:CGRectMake(4, 3, 10, 10)];
		[_colorLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:_colorLabel];
        
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -2, 100, 20)];
		[_categoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
        [_categoryLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
		[_categoryLabel setTextAlignment:NSTextAlignmentLeft];
		[_categoryLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:_categoryLabel];
        
        double with = 0;
        if (IS_IPHONE_6PLUS)
            with = 178;
        else
            with = 160;
        _percentLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(with-80, -2, 80, 20)];
		[_percentLabel2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
        [_percentLabel2 setTextColor:[UIColor colorWithRed:172.0/255 green:173.0/255 blue:178.0/255 alpha:1]];
		[_percentLabel2 setTextAlignment:NSTextAlignmentRight];
		[_percentLabel2 setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:_percentLabel2];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
