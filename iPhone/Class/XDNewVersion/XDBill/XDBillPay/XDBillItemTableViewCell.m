//
//  XDBillItemTableViewCell.m
//  PocketExpense
//
//  Created by 晓东 on 2018/4/10.
//

#import "XDBillItemTableViewCell.h"
#import "Category.h"
#import "Payee.h"
@interface XDBillItemTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@end
@implementation XDBillItemTableViewCell

-(void)setTransaction:(Transaction *)transaction{
    _transaction = transaction;
    
    self.icon.image = [UIImage imageNamed:_transaction.category.iconName];
    self.name.text = _transaction.payee.name;
    self.amount.text = [XDDataManager moneyFormatter:[_transaction.amount doubleValue]];
    self.date.text = [self returnInitDate:_transaction.dateTime];

}

-(NSString*)returnInitDate:(NSDate*)date{
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:date];
    
    NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"ccc, LLL d, yyyy";
    NSString* dateStr = [formatter stringFromDate:newDate];
    
    return dateStr;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
