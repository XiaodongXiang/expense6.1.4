//
//  iPad_Account_TransactionCell.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-9-30.
//
//

#import <UIKit/UIKit.h>

@class ClearCusBtn;
@class ipad_AccountViewController;
@interface iPad_Account_TransactionCell : UITableViewCell{
//    UIImageView							*bgImageView;

    ClearCusBtn                         *clearBtn;
    UIImageView                         *categoryIcon;
	UILabel								*timeLabel;
    
    UILabel                             *payeeLabel;
    UILabel                             *memoLabel;
    UIImageView                         *cycleImage;
    UIImageView                         *photoImageView;
    
	UILabel							    *spentLabel;
    UILabel							    *runningBalanceLabel;


    UIView                              *threeBtnContainView;
    UIImageView                         *threeBtnViewBgImage;
    UIButton                            *cellSearchBtn;
    UIButton                            *cellDuplicateBtn;
    UIButton                            *cellDeleteBtn;
    
    UISwipeGestureRecognizer            *swipGestureFromLeft;
    UISwipeGestureRecognizer            *swipGuetureFromRight;
    
    ipad_AccountViewController          *accountViewController_iPad;


}
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


@property (nonatomic,strong)UIView      *threeBtnContainView;
@property (nonatomic,strong)UIImageView *threeBtnViewBgImage;
@property (nonatomic,strong)UIButton                            *cellSearchBtn;
@property (nonatomic,strong)UIButton                            *cellDuplicateBtn;
@property (nonatomic,strong)UIButton                            *cellDeleteBtn;

@property (nonatomic,strong)UISwipeGestureRecognizer *swipGestureFromLeft;
@property (nonatomic,strong)UISwipeGestureRecognizer *swipGuetureFromRight;

@property (nonatomic,strong)ipad_AccountViewController *accountViewController_iPad;

-(void)layoutShowTwoCellBtns_iPad:(BOOL)showTwoBtns;
@end
