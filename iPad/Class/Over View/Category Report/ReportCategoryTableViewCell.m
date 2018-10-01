//
//  ReportCategoryTableViewCell.m
//  PocketExpense
//
//  Created by appxy_dev on 14-3-3.
//
//

#import "ReportCategoryTableViewCell.h"
#import "PokcetExpenseAppDelegate.h"

#define distanceFromTop 16


@implementation ReportCategoryTableViewCell
@synthesize nameLabel;
@synthesize spentLabel;
@synthesize percentLabel;
@synthesize colorImage;
@synthesize bgImageView;
@synthesize backgroundView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400, 30)];
 		[self.contentView addSubview:bgImageView];
        
        colorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 8, 14, 14)];
		[colorImage setBackgroundColor:[UIColor clearColor]];
        [colorImage.layer setCornerRadius:7];
        colorImage.layer.masksToBounds=YES;
		[self.contentView addSubview:colorImage];


        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 7, 140.0, 17)];
 		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        
		[nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
  		[self.contentView addSubview:nameLabel];
		
		percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(377-100-170, 0, 100, 30) ];
		[percentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        
		[percentLabel setTextColor:[UIColor colorWithRed:172.0/255 green:173.0/255 blue:178.0/255 alpha:1.0]];
		[percentLabel setTextAlignment:NSTextAlignmentRight];
		[percentLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:percentLabel];
        
        
        spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(377-100, 0, 100, 30)];
        [spentLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
 		[spentLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1.0]];
		[spentLabel setTextAlignment:NSTextAlignmentRight];//how to set the LabelText center
 		[spentLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:spentLabel];
		
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(25, 30-EXPENSE_SCALE, 377-25, EXPENSE_SCALE)];
        line.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [self.contentView addSubview:line];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
