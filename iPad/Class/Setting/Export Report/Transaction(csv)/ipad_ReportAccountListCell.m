//
//  ipad_ReportAccountListCell.m
//  PocketExpense
//
//  Created by humingjing on 14-5-20.
//
//

#import "ipad_ReportAccountListCell.h"

@implementation ipad_ReportAccountListCell
@synthesize nameLabel,headImageView,bgImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		self.backgroundView = bgImageView;
        
		headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13.0, 12.0, 20.0, 20.0)];
        [headImageView setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:headImageView];
        
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(46.0, 0.0, 419.0, 44.0)];
		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
		[nameLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
 		[self.contentView addSubview:nameLabel];
        
        
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
