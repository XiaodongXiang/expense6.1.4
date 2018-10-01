//
//  RepTransactionFilterViewController.h
//  PocketExpense
//
//  Created by MV on 11-12-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepTransactionFilterViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *myTableView;
	UITableViewCell*												cellType;
	UITableViewCell*												cellDateRange;
	UITableViewCell*												cellSort;
	UITableViewCell*                                                cellCategory;
    UITableViewCell*                                                cellAccount;
    UITableViewCell*                                                celltransfer;

	NSDate*															startDate;
	NSDate*															endDate;
 	UIButton                    *accountBtn;
    UIButton                    *cateogryBtn;
    
    UIButton                    *allBtn;
    UIButton                    *expenseBtn;
    UIButton                    *incomeBtn;
    UIButton                    *generateBtn;
    
    UILabel*                                                        lblDateRange;
 	UILabel*                                                        lblCategory;
	UILabel*                                                        lblAccount;
    UISwitch       *transferSwitch;
    
    NSString *tranDateTypeString;
    NSMutableArray *tranAccountSelectArray;
	NSMutableArray *tranCategorySelectArray;
    
    UILabel         *typeLabelText;
    UILabel         *accountsLabelText;
    UILabel         *categoryLabelText;
    UILabel         *dateRangeLabelText;
    UILabel         *sortByLabelText;
    UILabel         *transferLabelText;
    
 }
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transferLineHigh;


@property (nonatomic, strong) IBOutlet UITableView     *myTableView;
@property (nonatomic, strong) IBOutlet UITableViewCell*						 cellType;

@property (nonatomic, strong) IBOutlet UITableViewCell*						 cellSort;
@property (nonatomic, strong) IBOutlet UITableViewCell*						 cellDateRange;
@property (nonatomic, strong) IBOutlet UITableViewCell*                      cellCategory;
@property (nonatomic, strong) IBOutlet UITableViewCell*                      cellAccount;

@property (nonatomic, strong) NSDate*								startDate;
@property (nonatomic, strong) NSDate*								endDate;

@property (nonatomic, strong) IBOutlet UIButton                    *accountBtn;
@property (nonatomic, strong) IBOutlet UIButton                    *cateogryBtn;

@property (nonatomic, strong) IBOutlet UIButton                    *allBtn;
@property (nonatomic, strong) IBOutlet UIButton                    *expenseBtn;
@property (nonatomic, strong) IBOutlet UIButton                    *incomeBtn;
@property (nonatomic, strong) IBOutlet UIButton                    *generateBtn;
@property (nonatomic, strong) IBOutlet UILabel*                     lblDateRange;
@property (nonatomic, strong) IBOutlet UILabel*                     lblCategory;
@property (nonatomic, strong) IBOutlet UILabel*                     lblAccount;

@property (nonatomic, strong) IBOutlet UILabel         *typeLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *accountsLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *categoryLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *dateRangeLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *sortByLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *transferLabelText;

@property (nonatomic, copy)   NSString *tranDateTypeString;
@property (nonatomic, strong) NSMutableArray *tranAccountSelectArray;
@property (nonatomic, strong) NSMutableArray *tranCategorySelectArray;
@property (nonatomic, strong) IBOutlet UISwitch       *transferSwitch;
@property (nonatomic, strong) IBOutlet UITableViewCell*  celltransfer;

-(IBAction)generateReportBtn:(id)sender;

@end
