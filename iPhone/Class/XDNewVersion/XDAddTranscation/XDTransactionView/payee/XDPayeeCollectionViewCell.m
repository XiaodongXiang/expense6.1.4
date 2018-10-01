//
//  XDPayeeCollectionViewCell.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/9.
//

#import "XDPayeeCollectionViewCell.h"
#import "Category.h"
@interface XDPayeeCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *payeeLabel;
@property(nonatomic, strong)NSArray * colorArr;

@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;

@end

@implementation XDPayeeCollectionViewCell

-(void)setPayee:(Payee *)payee{
    _payee = payee;
    self.payeeLabel.text = payee.name;
    if (payee.category) {
        self.contentView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:payee.category.iconName]];
        self.categoryLbl.text = [[payee.category.categoryName componentsSeparatedByString:@":"]lastObject];
    }else{
        self.contentView.backgroundColor = RGBColor(113, 163, 245);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 15;
    self.contentView.layer.masksToBounds = YES;
}


@end
