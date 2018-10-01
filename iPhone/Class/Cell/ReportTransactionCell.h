//
//  ReportTransactionCell.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-26.
//
//

#import <UIKit/UIKit.h>

@class CashDetailTransactionViewController;

@interface ReportTransactionCell : UITableViewCell

@property(nonatomic,strong)UILabel         *nameLabel;
@property(nonatomic,strong)UILabel         *timeLabel;
@property(nonatomic,strong)UILabel         *amountLabel;

@property(nonatomic,strong)UIView          *twoBtnContainView;
@property(nonatomic,strong)UIImageView     *twoBtnContainImage;
@property(nonatomic,strong)UIButton        *searchBtn;
@property(nonatomic,strong)UIButton        *deleteBtn;
@property(nonatomic,strong)UIView           *line;

@property(nonatomic,strong)CashDetailTransactionViewController         *cashDetailViewController;

@property(nonatomic,strong)UISwipeGestureRecognizer *swipGestureFromLeft;
@property(nonatomic,strong)UISwipeGestureRecognizer *swipGuetureFromRight;

-(void)layoutShowTwoCellBtns:(BOOL)showTwoBtns;
@end
