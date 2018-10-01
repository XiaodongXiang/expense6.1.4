//
//  newAcountCell.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/10/28.
//
//

#import "newAcountCell.h"
#import "AppDelegate_iPhone.h"


@implementation newAcountCell
-(void)awakeFromNib
{
    if (ISPAD)
    {
        self.bgWidth.constant=345;
        self.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        self.bgView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    }
    else
    {
        self.bgWidth.constant=SCREEN_WIDTH-30;
    }
    if (IS_IPHONE_5)
    {
        self.bgHeight.constant=60;
        self.accountIconWidth.constant=30;
        self.nameLabelToTop.constant=12;
        self.nameLabelW.constant = 100;
    }
    else if (IS_IPHONE_6 || ISPAD)
    {
        self.bgHeight.constant=60;
        self.accountIconWidth.constant=30;
        self.nameLabelToTop.constant=12;
    }
    else if (IS_IPHONE_6PLUS)
    {
        self.bgHeight.constant=66;
        self.accountIconWidth.constant=31;
        self.nameLabelToTop.constant=14;
    }
    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    _balanceLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (self.editing == editing)
    {
        return;
    }
    
    [super setEditing:editing animated:animated];
    if (self.editing)
    {
                for (UIView * view in self.subviews) {
                    if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
                        for (UIView * subview in view.subviews) {
                            if ([subview isKindOfClass: [UIImageView class]]) {
                                ((UIImageView *)subview).image = [UIImage imageNamed: @"account_edit_sort_void"];
                            }
                        }
                    }
                }
        _balanceLabel.alpha=0;
        _deleteBtn.alpha=1;
        _detailButton.alpha=1;
        _sortImage.alpha=1;
        
    }
    else
    {
//        _balanceLabel.alpha=1;
        [UIView animateWithDuration:1.5 animations:^{
            _balanceLabel.alpha=1;
        }];
        _deleteBtn.alpha=0;
        _detailButton.alpha=0;
        _sortImage.alpha=0;
    }
    
}

@end
