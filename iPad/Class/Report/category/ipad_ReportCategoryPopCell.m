//
//  ipad_ReportCategoryPopCell.m
//  PocketExpense
//
//  Created by humingjing on 14-5-23.
//
//

#import "ipad_ReportCategoryPopCell.h"
#import "PokcetExpenseAppDelegate.h"


@implementation ipad_ReportCategoryPopCell
@synthesize bgImageView,nameLabel,spentLabel,timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        //bgImage
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 60)];
        bgImageView.image = [UIImage imageNamed:@"ipad_pop_cell_a1_320_60.png"];
		self.backgroundView = bgImageView;

        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 1, 120, 35)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1];
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16]];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];

        spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 0.0, 200.0, 60.0)];
		[spentLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
 		[spentLabel setTextAlignment:NSTextAlignmentRight];
 		[spentLabel setBackgroundColor:[UIColor clearColor]];
        [spentLabel setTextColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
        [self addSubview:spentLabel];
        
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 27, 200.0, 25.0)];
		[timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [timeLabel setTextColor:[UIColor colorWithRed:172.0/255 green:173.0/255 blue:178.0/255 alpha:1.0]];
        
		[timeLabel setTextAlignment:NSTextAlignmentLeft];
		[timeLabel setBackgroundColor:[UIColor clearColor]];
 		[self addSubview:timeLabel];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
