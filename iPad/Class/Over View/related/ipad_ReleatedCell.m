//
//  ipad_ReleatedCell.m
//  PocketExpense
//
//  Created by humingjing on 14-5-26.
//
//

#import "ipad_ReleatedCell.h"
#import "ipad_SearchRelatedViewController.h"
#import "PokcetExpenseAppDelegate.h"

#define TWOBTNLEFT 380
#define TWOBTNWITH 100

@implementation ipad_ReleatedCell
@synthesize nameLabel,blanceLabel,bgImageView,cateIcon;
@synthesize memoIcon,phonteIcon,dateTimeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 60.0)];
        self.backgroundView = bgImageView;
        
        cateIcon = [[UIImageView alloc]initWithFrame:CGRectMake(9, 16, 28, 28)];
        cateIcon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:cateIcon];
        
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 1, 200, 30)];
		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0]];
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
		[nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
 		[self.contentView addSubview:nameLabel];
 		
 		blanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(250.0, 0.0, 275.0, 59.0)];
        [blanceLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
 		[blanceLabel setTextAlignment:NSTextAlignmentRight];
		[blanceLabel setBackgroundColor:[UIColor clearColor]];
 		[blanceLabel setTextColor:[UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1]];
        blanceLabel.adjustsFontSizeToFitWidth = YES;
		[self.contentView addSubview:blanceLabel];
        
        dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(46.0, 27, 164.0, 25.0)];
        dateTimeLabel.backgroundColor = [UIColor clearColor];
        dateTimeLabel.textColor = [UIColor colorWithRed:168.0/255.f green:168.0/255.f blue:168.0/255.f alpha:1];
        [dateTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        dateTimeLabel.textAlignment = NSTextAlignmentLeft;
        dateTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:dateTimeLabel];
        
        memoIcon = [[UIImageView alloc]initWithFrame:CGRectMake(140, 33, 13, 11)];
        memoIcon.image = [UIImage imageNamed:@"icon_memo.png"];
        memoIcon.hidden = YES;
        [self.contentView addSubview:memoIcon];
        
        phonteIcon = [[UIImageView alloc]initWithFrame:CGRectMake(160, 33, 13, 11)];
        phonteIcon.image = [UIImage imageNamed:@"icon_photo.png"];
        phonteIcon.hidden = YES;
        [self.contentView addSubview:phonteIcon];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
