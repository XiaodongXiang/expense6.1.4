//
//  ipad_BillCell.h
//  PocketExpense
//
//  Created by Tommy on 11-4-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ipad_BillsViewController.h"

@class HMJButton;
@class ipad_DateSelBillsViewController;

@interface ipad_BillsCell : UITableViewCell
{
    UIImageView *bgImageView;

	UIImageView *categoryIconImage;
    UILabel     *nameLabel;
	UILabel     *amountLabel;
    UILabel     *dateLabel;
    UIImageView *memoImage;
    UIImageView *paidStateImageView;
	

    UIView                                  *twoBtnContainView;
    UIImageView                             *twoBtnContainViewImage;
 	HMJButton                               *celleditBtn;
    HMJButton                               *celldeleteBtn;
    
    UISwipeGestureRecognizer                *swipGestureFromLeft;
    UISwipeGestureRecognizer                *swipGuetureFromRight;
    NSIndexPath                             *indePath;
    
    ipad_BillsViewController                *billViewController;
    ipad_DateSelBillsViewController         *iDateSelBillsViewController;
 }
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *categoryIconImage;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *amountLabel;
@property (nonatomic, strong) UILabel     *dateLabel;
@property (nonatomic, strong) UIImageView *memoImage;

@property (nonatomic, strong) UIImageView *paidStateImageView;


@property (nonatomic, strong) UIView                                  *twoBtnContainView;
@property (nonatomic, strong) UIImageView                             *twoBtnContainViewImage;
@property (nonatomic, strong) HMJButton                               *celleditBtn;
@property (nonatomic, strong) HMJButton                               *celldeleteBtn;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipGestureFromLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipGuetureFromRight;
@property (nonatomic, strong) NSIndexPath              *indePath;

@property (nonatomic, strong) ipad_BillsViewController         *billViewController;
@property (nonatomic, strong)ipad_DateSelBillsViewController         *iDateSelBillsViewController;

-(void)layoutShowTwoCellBtns:(BOOL)showTwoBtns;
@end
