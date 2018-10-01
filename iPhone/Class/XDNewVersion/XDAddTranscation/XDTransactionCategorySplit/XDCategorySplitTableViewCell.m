//
//  XDCategorySplitTableViewCell.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/1.
//

#import "XDCategorySplitTableViewCell.h"
#import "Setting+CoreDataClass.h"
#import "numberKeyboardView.h"
@interface XDCategorySplitTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *categoryIcon;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UITextField *categoryMoneyTextF;
@property(nonatomic, strong)Setting * setting;
@property(nonatomic, strong)numberKeyboardView* number;

@property(nonatomic, assign)CGFloat amount;

@end
@implementation XDCategorySplitTableViewCell

-(void)setCategorySelect:(CategorySelect *)categorySelect{
    _categorySelect = categorySelect;
    
    self.categoryIcon.image = [UIImage imageNamed:_categorySelect.category.iconName];
    self.categoryName.text = [[_categorySelect.category.categoryName componentsSeparatedByString:@": "] lastObject];
    self.number = [[[NSBundle mainBundle]loadNibNamed:@"numberKeyboardView" owner:self options:nil]lastObject];
    if (categorySelect.amount > 0) {
        self.number.oldAmountString = [NSString stringWithFormat:@"%.2f",categorySelect.amount];
    }
    __weak __typeof__(self) weakSelf = self;
    self.number.amountBlock = ^(NSString *string) {
      weakSelf.categoryMoneyTextF.text = string;
    };
    
    
    self.categoryMoneyTextF.inputView  = self.number;
    self.amount = _categorySelect.amount;
    
    if ( self.amount != 0.0) {
        self.categoryMoneyTextF.text = [NSString stringWithFormat:@"%@ %.2f",[[self.setting.currency componentsSeparatedByString:@"-"]firstObject],_categorySelect.amount];
    }else{
        self.categoryMoneyTextF.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.setting = [[[XDDataManager shareManager] getObjectsFromTable:@"Setting"]lastObject];
    self.categoryMoneyTextF.placeholder = [NSString stringWithFormat:@"%@ 0.00",[[self.setting.currency componentsSeparatedByString:@"-"]firstObject]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        
        self.categoryMoneyTextF.hidden = NO;
        [self.categoryMoneyTextF becomeFirstResponder];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.number.needCaculate = YES;
    
    NSString* str = [[self.categoryMoneyTextF.text componentsSeparatedByString:@" "]lastObject];
    if ([str doubleValue] == 0) {
        self.categoryMoneyTextF.hidden = YES;
    }else{
       self.categoryMoneyTextF.text = [NSString stringWithFormat:@"%@ %.2f",[[self.setting.currency componentsSeparatedByString:@"-"]firstObject],[str doubleValue]];
    }
    _categorySelect.amount = [str doubleValue];
    
    if ([self.delegate respondsToSelector:@selector(returnSplitAmount:)]) {
        [self.delegate returnSplitAmount:self];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(returnCellFrame:)]) {
        [self.delegate returnCellFrame:self];
    }
    
    return YES;
}


@end
