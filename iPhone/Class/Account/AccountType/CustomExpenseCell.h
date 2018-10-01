//
//  CustomExpenseCell.h
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "SWTableViewCell.h"
#import "PokcetExpenseAppDelegate.h"
#import "ClearCusBtn.h"


@interface CustomExpenseCell : SWTableViewCell

@property (nonatomic,strong) UILabel		*nameLabel;
@property (nonatomic,strong) UILabel        *spentLabel;
@property (nonatomic,strong) UILabel        *timeLabel;
@property (nonatomic,strong) UIImageView    *cycleImage;
@property (nonatomic,strong) UIImageView    *memoImage;
@property (nonatomic,strong) UIImageView    *photoImage;
@property (nonatomic,strong) UIImageView    *categoryIcon;
@property (nonatomic,strong) UIView         *line;
@property (nonatomic,strong) UILabel        *runningBalaceLabel;

@property (nonatomic,strong)  ClearCusBtn *clearBtn;


@end
