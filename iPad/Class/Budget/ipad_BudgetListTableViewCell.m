//
//  ipad_BudgetListTableViewCell.m
//  PocketExpense
//
//  Created by humingjing on 14-5-21.
//
//

#import "ipad_BudgetListTableViewCell.h"
#import "PokcetExpenseAppDelegate.h"

@implementation ipad_BudgetListTableViewCell
@synthesize categoryIcon,categoryLabel,textAmountText;
@synthesize bgImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        PokcetExpenseAppDelegate *appDelegate_iphone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 540, 44)];
        [self.contentView addSubview:bgImageView];
        
        categoryIcon = [[UIImageView alloc]initWithFrame:CGRectMake(9, 8, 28, 28)];
        categoryIcon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:categoryIcon];
        
        categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(46, 0, 200, 43)];
        categoryLabel.backgroundColor = [UIColor clearColor];
        [categoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16]];
        categoryLabel.textColor = [appDelegate_iphone.epnc getAmountBlackColor];
        [self.contentView addSubview:categoryLabel];
        
        textAmountText = [[UITextField alloc]initWithFrame:CGRectMake(250, 7, 275, 30)];
        textAmountText.backgroundColor = [UIColor clearColor];
        textAmountText.textAlignment = NSTextAlignmentRight;
        textAmountText.textColor = [appDelegate_iphone.epnc getAmountBlackColor];
        [textAmountText setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
        textAmountText.keyboardType =UIKeyboardTypeNumberPad;
        textAmountText.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:textAmountText];
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
