//
//  BudgetTableViewCell.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/15.
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

@end
@implementation BudgetTableViewCell
@synthesize expenseAmount;

-(void)setAllBudgetAmount:(double)allBudgetAmount{
    _allBudgetAmount = allBudgetAmount;
    
    self.budgetName.text = NSLocalizedString(@"VC_Total", nil);
    self.budgetAmount.text = [XDDataManager moneyFormatter:_allBudgetAmount];
    self.spendAmount.text = [XDDataManager moneyFormatter:expenseAmount];
    if (_allBudgetAmount - expenseAmount >= 0) {
        self.residueAmount.textColor = [UIColor blackColor];
        self.residueAmount.text = [NSString stringWithFormat:@"%@ left",[XDDataManager moneyFormatter:_allBudgetAmount-expenseAmount]];
    }else{
        self.residueAmount.textColor = RGBColor(240, 106, 68);
        self.residueAmount.text = [NSString stringWithFormat:@"%@ over",[XDDataManager moneyFormatter:fabs(_allBudgetAmount-expenseAmount)]];
        self.spendAmount.textColor = RGBColor(200, 200, 200);
    }
    
    [self setNeedsDisplay];
    
}

-(void)setBudgetCountClass:(BudgetCountClass *)budgetCountClass{
    _budgetCountClass = budgetCountClass;
    
    if (_budgetCountClass) {
        self.budgetName.text = budgetCountClass.bt.category.categoryName;
        self.budgetAmount.text = [XDDataManager moneyFormatter:budgetCountClass.btTotalRellover];
        self.spendAmount.text = [XDDataManager moneyFormatter:budgetCountClass.btTotalExpense];
        if (budgetCountClass.btTotalRellover -budgetCountClass.btTotalExpense >= 0) {
            self.residueAmount.textColor = [UIColor blackColor];
            self.residueAmount.text = [NSString stringWithFormat:@"%@ left",[XDDataManager moneyFormatter:budgetCountClass.btTotalRellover -budgetCountClass.btTotalExpense]];
        }else{
            self.residueAmount.textColor = RGBColor(240, 106, 68);
            self.residueAmount.text = [NSString stringWithFormat:@"%@ over",[XDDataManager moneyFormatter:fabs(budgetCountClass.btTotalRellover - budgetCountClass.btTotalExpense)]];
            self.spendAmount.textColor = RGBColor(200, 200, 200);

        }
        [self setNeedsDisplay];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.clipsToBounds = YES;
}

-(void)drawRect:(CGRect)rect{
    
    
    if (_budgetCountClass) {
        UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(15, CGRectGetMaxY(self.budgetName.frame)+3, SCREEN_WIDTH - 30, self.spendAmount.y - CGRectGetMaxY(self.budgetName.frame) - 6)];
        [RGBColor(238, 238, 238) set];
        [path fill];
        
        double budgetAmount = [_budgetCountClass.bt.amount doubleValue];
        double expenseAmount = _budgetCountClass.btTotalExpense;
        
        if (expenseAmount > budgetAmount) {
            UIBezierPath* spath = [UIBezierPath bezierPathWithRect:CGRectMake(15, CGRectGetMaxY(self.budgetName.frame)+3, SCREEN_WIDTH - 30, self.spendAmount.y - CGRectGetMaxY(self.budgetName.frame) - 6)];
            [RGBColor(240, 106, 68) set];
            [spath fill];
        }else{
            if (expenseAmount > 0) {
                double ratio = expenseAmount/budgetAmount;
                CGFloat width = ratio * (SCREEN_WIDTH - 30);
                
                UIBezierPath* spath = [UIBezierPath bezierPathWithRect:CGRectMake(15, CGRectGetMaxY(self.budgetName.frame)+3, width, self.spendAmount.y - CGRectGetMaxY(self.budgetName.frame) - 6)];
                [RGBColor(113, 163, 245) set];
                [spath fill];
            }
            
        }
    }else{
        UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(15, CGRectGetMaxY(self.budgetName.frame)+10, SCREEN_WIDTH - 30, self.spendAmount.y - CGRectGetMaxY(self.budgetName.frame) - 20)];
        [RGBColor(238, 238, 238) set];
        [path fill];
    }
    
    if (_allBudgetAmount != 0 && !_budgetCountClass) {
        
        UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(15, CGRectGetMaxY(self.budgetName.frame)+10, SCREEN_WIDTH - 30, self.spendAmount.y - CGRectGetMaxY(self.budgetName.frame) - 20)];
        [RGBColor(238, 238, 238) set];
        [path fill];
        
        double ratio = expenseAmount/_allBudgetAmount;
        
        CGFloat width;
        if (ratio>=1) {
            width = SCREEN_WIDTH - 30;
            UIBezierPath* spath = [UIBezierPath bezierPathWithRect:CGRectMake(15, CGRectGetMaxY(self.budgetName.frame)+10, width, self.spendAmount.y - CGRectGetMaxY(self.budgetName.frame) - 20)];
            [RGBColor(240, 106, 68) set];
            [spath fill];
        }else{
            width = ratio * (SCREEN_WIDTH - 30);
            UIBezierPath* spath = [UIBezierPath bezierPathWithRect:CGRectMake(15, CGRectGetMaxY(self.budgetName.frame)+10, width, self.spendAmount.y - CGRectGetMaxY(self.budgetName.frame) - 20)];
            [RGBColor(113, 163, 245) set];
            [spath fill];
        }
        
       
    }
    
    
}

@end
