//
//  BillsCell.h
//  Bill Buddy
//
//  Created by Tommy on 1/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMJButton.h"

@class BillsViewController;
@class ipad_BillsViewController;

@interface BillsCell : UITableViewCell 

@property (strong, nonatomic)  UIImageView *categoryIconImage;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *amountLabel;
@property (strong, nonatomic)  UILabel *dateLabel;
@property (strong, nonatomic)  UIImageView *memoImage;
@property (strong, nonatomic)  UIImageView *payIconImage;

@property (strong, nonatomic)  UIView *twoBtnContainView;
@property (strong, nonatomic)  HMJButton *celleditBtn;
@property (strong, nonatomic)  HMJButton *celldeleteBtn;

@property (strong, nonatomic)  UIView *line2;

@property (nonatomic, strong)UISwipeGestureRecognizer *swipGestureFromLeft;
@property (nonatomic, strong)UISwipeGestureRecognizer *swipGuetureFromRight;
@property(nonatomic,strong)NSIndexPath                 *indePath;
//1:表示从overdue的tableview传过来的 2:表示是calendar的tableview
@property(nonatomic,assign)NSInteger                   viewType;

@property(nonatomic,strong)BillsViewController         *billViewController;
@property (strong, nonatomic)ipad_BillsViewController    *iBillsViewController;

-(void)layoutShowTwoCellBtns:(BOOL)showTwoBtns;

@end
