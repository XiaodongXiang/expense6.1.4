//
//  BudgetTableViewCell.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/67.
//

#import "BudgetTableViewCell.h"
#import "BudgetTemplate.h"
#import "Category.h"
#import "BudgetCountClass.h"

@interface BudgetTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *budgetName;
@property (weak, nonatomic) IBOutlet UILabel *budgetAmount;
@property (weak, nonatomic) IBOutlet UILabel *spendAmount;
@property (weak, nonatomic) IBOutlet UILabel *residueAmount;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIcon;

@end
@implementation BudgetTableViewCell

-(void)setBudgetCountClass:(BudgetCountClass *)budgetCountClass{
    _budgetCountClass = budgetCountClass;
  

    if (_budgetCountClass) {
        self.budgetName.text = budgetCountClass.bt.category.categoryName;
        self.budgetAmount.text = [XDDataManager moneyFormatter:budgetCountClass.btTotalRellover];
        self.categoryIcon.image = [UIImage imageNamed:budgetCountClass.bt.category.iconName];
        self.spendAmount.text = [NSString stringWithFormat:@"%@ of %@",[XDDataManager moneyFormatter:budgetCountClass.btTotalExpense],[XDDataManager moneyFormatter:_budgetCountClass.btTotalRellover]];
        if (budgetCountClass.btTotalRellover -budgetCountClass.btTotalExpense >= 0) {
            self.residueAmount.textColor = [UIColor blackColor];
            self.residueAmount.text = [NSString stringWithFormat:@"%@",[XDDataManager moneyFormatter:budgetCountClass.btTotalRellover -budgetCountClass.btTotalExpense]];
            self.budgetAmount.text = @"left";
        }else{
            self.residueAmount.text = [NSString stringWithFormat:@"%@",[XDDataManager moneyFormatter:fabs(budgetCountClass.btTotalRellover - budgetCountClass.btTotalExpense)]];
            self.budgetAmount.text = @"over";

        }
        [self setNeedsDisplay];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.clipsToBounds = YES;
    
    self.categoryIcon.layer.cornerRadius = 20;
    self.categoryIcon.layer.masksToBounds = YES;
}

-(void)drawRect:(CGRect)rect{
    
    if (_budgetCountClass) {
        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(67, CGRectGetMaxY(self.budgetName.frame)+5, SCREEN_WIDTH - 82, 22) cornerRadius:11];
        [RGBColor(218, 218, 218) set];
        [path fill];
        
        double budgetAmount = [_budgetCountClass.bt.amount doubleValue];
        double expenseAmount = _budgetCountClass.btTotalExpense;
        
        if (expenseAmount > budgetAmount) {
            UIBezierPath* spath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(67, CGRectGetMaxY(self.budgetName.frame)+5, SCREEN_WIDTH - 82, 22) cornerRadius:11];
            [RGBColor(240, 106, 68) set];
            [spath fill];
        }else{
            if (expenseAmount > 0) {
                double ratio = expenseAmount/budgetAmount;
                CGFloat width = ratio * (SCREEN_WIDTH - 82);
                UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(67, CGRectGetMaxY(self.budgetName.frame)+5, width, 22)];
                [RGBColor(113, 163, 245) set];
                [path fill];
                
                UIBezierPath* path2 = [UIBezierPath bezierPath];
                [path2 moveToPoint:CGPointMake(78, CGRectGetMaxY(self.budgetName.frame)+5)];
                [path2 addLineToPoint:CGPointMake(67, CGRectGetMaxY(self.budgetName.frame)+5)];
                [path2 addLineToPoint:CGPointMake(67, CGRectGetMaxY(self.budgetName.frame)+27)];
                [path2 addLineToPoint:CGPointMake(78, CGRectGetMaxY(self.budgetName.frame)+27)];
                [path2 addArcWithCenter:CGPointMake(78, CGRectGetMaxY(self.budgetName.frame)+16)
                                radius:11 startAngle:M_PI/2
                              endAngle:M_PI*3/2 clockwise:YES];
                
                [path2 closePath];
                [[UIColor whiteColor] set];
                [path2 fill];
                
                
                UIBezierPath* path3 = [UIBezierPath bezierPath];
                [path3 moveToPoint:CGPointMake(SCREEN_WIDTH - 26, CGRectGetMaxY(self.budgetName.frame)+5)];
                [path3 addLineToPoint:CGPointMake(SCREEN_WIDTH - 15, CGRectGetMaxY(self.budgetName.frame)+5)];
                [path3 addLineToPoint:CGPointMake(SCREEN_WIDTH - 15, CGRectGetMaxY(self.budgetName.frame)+27)];
                [path3 addLineToPoint:CGPointMake(SCREEN_WIDTH - 26, CGRectGetMaxY(self.budgetName.frame)+27)];
                [path3 addArcWithCenter:CGPointMake(SCREEN_WIDTH - 26, CGRectGetMaxY(self.budgetName.frame)+16)
                                 radius:11 startAngle:M_PI/2
                               endAngle:M_PI*3/2 clockwise:NO];
                
                [path3 closePath];
                [[UIColor whiteColor] set];
                [path3 fill];
            }
        }
    }
}




@end
