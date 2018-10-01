//
//  AccountPickerCell.m
//  PocketExpense
//
//  Created by humingjing on 14-3-24.
//
//

#import "ipad_AccountPickerCell.h"

@implementation ipad_AccountPickerCell
@synthesize nameLabel,bgImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
        self.backgroundView = bgImage;
        
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, 200.0, 44.0)];
		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
		[nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
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
