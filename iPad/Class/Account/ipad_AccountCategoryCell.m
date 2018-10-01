//
//  ipad_AccountCategoryCell.m
//  PocketExpense
//
//  Created by humingjing on 14-9-12.
//
//

#import "ipad_AccountCategoryCell.h"

@implementation ipad_AccountCategoryCell
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[self imageWithColor:[UIColor colorWithRed:196/255.0 green:198/255.0 blue:199/255.0 alpha:1]]];
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 28.0, 28.0)];
        [_headImageView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_headImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 0.0, 200.0, 44.0)];
        [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
        [_nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_nameLabel];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(53, 44-EXPENSE_SCALE, 378-53, EXPENSE_SCALE)];
        line.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
