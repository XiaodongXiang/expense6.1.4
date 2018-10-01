//
//  ipad_SeachCell.m
//  PocketExpense
//
//  Created by humingjing on 14-8-27.
//
//

#import "ipad_SearchCell.h"
#import "PokcetExpenseAppDelegate.h"

@implementation ipad_SearchCell
@synthesize categoryIcon,nameLabel,timeLabel,spentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        categoryIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10,16, 28, 28)];
        categoryIcon.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:categoryIcon];
        
        //name
		nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(46, 1, 120, 35)];
 		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16]];
        [nameLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:nameLabel];
        
        //time
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 27, 120, 25)];
		[timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
        [timeLabel setTextColor:[UIColor colorWithRed:172.0/255 green:173.0/255 blue:178.0/255 alpha:1.0]];
		[timeLabel setTextAlignment:NSTextAlignmentLeft];
		[timeLabel setBackgroundColor:[UIColor clearColor]];
 		[self addSubview:timeLabel];
        
        //amount
 		spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(185, 0, 120, 59)];
		[spentLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
 		[spentLabel setTextAlignment:NSTextAlignmentRight];
 		[spentLabel setBackgroundColor:[UIColor clearColor]];
        [spentLabel setTextColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
        spentLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:spentLabel];

        UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line_320_1.png"]];
        line.frame = CGRectMake(46, 59, self.frame.size.width, 1);
        [self addSubview:line];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
