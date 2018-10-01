//
//  BudgetListTableViewCell.m
//  PocketExpense
//
//  Created by humingjing on 14-4-2.
//
//

#import "BudgetListTableViewCell.h"
#import "AppDelegate_iPhone.h"

@implementation BudgetListTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    _categoryLabel.backgroundColor = [UIColor clearColor];
    [_categoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16]];
    _categoryLabel.textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    
    _textAmountText.backgroundColor = [UIColor clearColor];
    _textAmountText.textAlignment = NSTextAlignmentRight;
    _textAmountText.textColor =  [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    [_textAmountText setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    _textAmountText.keyboardType =UIKeyboardTypeNumberPad;
    _textAmountText.adjustsFontSizeToFitWidth = YES;
    
    _line1H.constant = EXPENSE_SCALE;
    _line2H.constant =EXPENSE_SCALE;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
