//
//  Custom_iPad_Account_TransactionCell.h
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "SWTableViewCell.h"
#import "ClearCusBtn.h"
#import "ipad_AccountViewController.h"

@interface Custom_iPad_Account_TransactionCell : SWTableViewCell
@property (nonatomic,strong) ClearCusBtn                         *clearBtn;
@property (nonatomic,strong) UIImageView	 *bgImageView;
@property (nonatomic,strong)UIImageView                         *categoryIcon;
@property (nonatomic,strong)UILabel								*timeLabel;

@property (nonatomic,strong)UILabel                             *payeeLabel;
@property (nonatomic,strong)UILabel                             *memoLabel;
@property (nonatomic,strong)UIImageView                         *cycleImage;
@property (nonatomic,strong)UIImageView                         *photoImageView;

@property (nonatomic,strong)UILabel							     *spentLabel;
@property (nonatomic,strong)UILabel							     *runningBalanceLabel;

@property (nonatomic,strong)ipad_AccountViewController *accountViewController_iPad;

@end
