//
//  CategorySplitCell.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-10.
//
//

#import "CategorySplitCell.h"

@implementation CategorySplitCell
@synthesize bgImage,categoryIconImage,categoryNameLabel,amountTextField,thisCellisEdit;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
		self.backgroundView = bgImage;
        
		categoryIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9.0, 8.0, 28.0, 28.0)];
		[self.contentView addSubview:categoryIconImage];
        
		categoryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(46.0, 0.0, 170.0, 44.0)];
		[categoryNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
		[categoryNameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
		[categoryNameLabel setTextAlignment:NSTextAlignmentLeft];
		[categoryNameLabel setBackgroundColor:[UIColor clearColor]];
 		[self.contentView addSubview:categoryNameLabel];
        
        amountTextField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-95, 0, 85, 43)];
        [amountTextField setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
		[amountTextField setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
        amountTextField.textAlignment = NSTextAlignmentRight;
        amountTextField.backgroundColor = [UIColor clearColor];
        amountTextField.keyboardType =UIKeyboardTypeDecimalPad;
//        amountTextField.clearsOnBeginEditing = YES;
        [self.contentView addSubview:amountTextField];
        
        self.thisCellisEdit = NO;
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 44-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
        _line.backgroundColor = RGBColor(226, 226, 226);
        [self.contentView addSubview:_line];
    }
    return self;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    [self.contentView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    self.backgroundView.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
//    
//    if(self.thisCellisEdit){
//        categoryIconImage.frame = CGRectMake(45, 6.0, 30.0, 30.0);
//        categoryNameLabel.frame = CGRectMake(92.0, 0.0, 200.0, 44.0);
//    }
//    else
//    {
//        categoryIconImage.frame = CGRectMake(15, 6.0, 30.0, 30.0);
//        categoryNameLabel.frame = CGRectMake(62.0, 0.0, 200.0, 44.0);
//    }
//
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
