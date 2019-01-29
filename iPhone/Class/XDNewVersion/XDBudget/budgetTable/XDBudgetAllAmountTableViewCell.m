//
//  XDBudgetAllAmountTableViewCell.m
//  PocketExpense
//
//  Created by 晓东项 on 2019/1/23.
//

#import "XDBudgetAllAmountTableViewCell.h"

@interface XDBudgetAllAmountTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *allAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *infoLbl;


@end
@implementation XDBudgetAllAmountTableViewCell
@synthesize expenseAmount;
-(void)setAllBudgetAmount:(double)allBudgetAmount{
    _allBudgetAmount = allBudgetAmount;
    
    self.infoLbl.text = [NSString stringWithFormat:@"%@ of %@",[XDDataManager moneyFormatter:expenseAmount],[XDDataManager moneyFormatter:allBudgetAmount]];
    
    if (expenseAmount > allBudgetAmount) {
        self.typeLbl.text = @"over";
        self.allAmountLbl.text = [XDDataManager moneyFormatter:expenseAmount-allBudgetAmount];
    }else{
        self.typeLbl.text = @"left";
        self.allAmountLbl.text = [XDDataManager moneyFormatter:allBudgetAmount-expenseAmount];
    }
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    
    CGFloat width =  SCREEN_WIDTH - 30;
   
    if (expenseAmount <= _allBudgetAmount) {
        float ratio = expenseAmount / _allBudgetAmount;

        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15, 44, width, 22) cornerRadius:11];
        [RGBColor(218, 218, 218) set];
        [path fill];
        
        if (expenseAmount == 0) {
            return;
        }
        
        UIBezierPath* spath = [UIBezierPath bezierPathWithRect:CGRectMake(15, 44, width * ratio, 22)];
        [RGBColor(113, 163, 245) set];
        [spath fill];
        
        UIBezierPath* path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:CGPointMake(26, 44)];
        [path1 addLineToPoint:CGPointMake(15, 44)];
        [path1 addLineToPoint:CGPointMake(15, 66)];
        [path1 addLineToPoint:CGPointMake(26, 66)];
        [path1 addArcWithCenter:CGPointMake(26, 55) radius:11 startAngle:M_PI/2 endAngle:M_PI/2*3 clockwise:YES];
        [path1 closePath];
        [[UIColor whiteColor] set];
        [path1 fill];
        
        UIBezierPath* path2 = [UIBezierPath bezierPath];
        [path2 moveToPoint:CGPointMake(SCREEN_WIDTH-26, 44)];
        [path2 addLineToPoint:CGPointMake(SCREEN_WIDTH-15, 44)];
        [path2 addLineToPoint:CGPointMake(SCREEN_WIDTH-15, 66)];
        [path2 addLineToPoint:CGPointMake(SCREEN_WIDTH-26, 66)];
        [path2 addArcWithCenter:CGPointMake(SCREEN_WIDTH-26, 55) radius:11 startAngle:M_PI/2 endAngle:M_PI/2*3 clockwise:NO];
        [path2 closePath];
        [[UIColor whiteColor] set];
        [path2 fill];
        
        
    }else{
        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15, 44, width, 22) cornerRadius:11];
        [RGBColor(240, 106, 68) set];
        [path fill];
    }
}

@end
