//
//  ReportOverViewCell.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-3-11.
//
//

#import <UIKit/UIKit.h>

@class ExpenseViewController;
@interface ReportOverViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView       *colorLabel;
@property (nonatomic, strong) UILabel           *categoryLabel;
@property (nonatomic, strong) UIImageView       *bgImage;
@property (nonatomic, strong) UILabel           *percentLabel2;

@property (nonatomic, strong) ExpenseViewController *expenseViewController;
@end
