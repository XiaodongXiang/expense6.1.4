//
//  CustomBillCell.h
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "SWTableViewCell.h"

@interface CustomBillCell : SWTableViewCell
@property (strong, nonatomic)  UIImageView *categoryIconImage;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *amountLabel;
@property (strong, nonatomic)  UILabel *dateLabel;
@property (strong, nonatomic)  UIImageView *memoImage;
@property (strong, nonatomic)  UIImageView *payIconImage;
@property (strong, nonatomic)  UIView *line2;
@property(nonatomic, strong) NSDate * date;
@property(nonatomic, strong) UILabel* leftLabel;

@end
