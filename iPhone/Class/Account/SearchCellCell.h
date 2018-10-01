//
//  SearchCellCell.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-14.
//
//

#import <UIKit/UIKit.h>

@class AccountSearchViewController;
@interface SearchCellCell : UITableViewCell<UIGestureRecognizerDelegate> 

@property (nonatomic,strong) UILabel									*nameLabel;
@property (nonatomic,strong) UILabel									*spentLabel;
@property (nonatomic,strong) UILabel									*timeLabel;
@property (nonatomic,strong) UIImageView							    *phontoImage;
@property (nonatomic,strong) UIImageView                             *memoImage;
@property (nonatomic,strong) UIImageView                             *categoryIcon;

@property (nonatomic,strong) UIView                                  *cellBtnContainView;
@property (nonatomic,strong) UIButton                                *cellsearchBtn;
@property (nonatomic,strong) UIButton                               *cellDeleteBtn;

@property (nonatomic,strong) UISwipeGestureRecognizer *swipGestureFromLeft;
@property (nonatomic,strong) UISwipeGestureRecognizer *swipGuetureFromRight;
@property (nonatomic,strong) AccountSearchViewController *accountSearchViewController;

-(void)layoutShowTwoCellBtns:(BOOL)showTwoBtns;

@end
