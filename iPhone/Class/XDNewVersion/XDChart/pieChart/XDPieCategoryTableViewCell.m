//
//  XDPieCategoryTableViewCell.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/26.
//

#import "XDPieCategoryTableViewCell.h"
#import "XDPieChartModel.h"
#import "Category.h"
#import "Transaction.h"
#import "Payee.h"
@interface XDPieCategoryTableViewCell()
{
    double _precentNum;
}
@property (weak, nonatomic) IBOutlet UIImageView *categoryIcon;
@property (weak, nonatomic) IBOutlet UILabel *transactionName;
@property (weak, nonatomic) IBOutlet UILabel *precent;
@property (weak, nonatomic) IBOutlet UILabel *amout;

@end
@implementation XDPieCategoryTableViewCell
@synthesize amount;
-(void)setModel:(XDPieChartModel *)model{
    _model = model;
    
    self.categoryIcon.image = [UIImage imageNamed:model.category.iconName];
    self.transactionName.text = model.category.categoryName;
    self.amout.text = [XDDataManager moneyFormatter:model.amount];
    
    _precentNum = model.amount/amount;
    self.precent.text = [NSString stringWithFormat:@"%.1f%%",_precentNum*100];
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect{
    
    CGPoint point = CGPointMake(self.transactionName.x, CGRectGetMaxY(self.transactionName.frame)+5);
    CGSize size = CGSizeMake(CGRectGetMaxX(self.amout.frame) - self.transactionName.x, 10);
    
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(point.x, point.y, size.width, size.height)];
    [RGBColor(238, 238, 238) set];
    [path fill];
    
    
    UIColor * color = [UIColor mostColor:[UIImage imageNamed:_model.category.iconName]];
    
    self.amout.textColor = color;
    UIBezierPath* colorPath = [UIBezierPath bezierPathWithRect:CGRectMake(point.x, point.y, size.width * _precentNum, size.height)];
    [color set];
    [colorPath fill];
}

@end
