//
//  BudgetDetailViewController.h
//  Expense 5
//
//  Created by BHI_James on 4/23/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BudgetTemplate.h"

@class TransferViewController_NS;
@interface BudgetDetailViewController : UIViewController
<NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;




@property(nonatomic,strong)IBOutlet UIView           *headContainView;
@property(nonatomic,strong)IBOutlet UIButton         *bvc_backBtn;
@property(nonatomic,strong)IBOutlet UIButton         *bvc_transferBtn;
@property(nonatomic,strong)IBOutlet UILabel          *headerBudgetAmountLabel;


@property(nonatomic,strong)IBOutlet UILabel          *bdvc_categoryLabel;


@property(nonatomic,strong)IBOutlet UILabel          *noRecordLabelText;

@property(nonatomic,strong)IBOutlet UITableView      *mytableView;
@property(nonatomic,strong)NSFetchedResultsController*fetchedResultsController;

@property(nonatomic,strong)NSMutableArray            *dataSouceList;
@property(nonatomic,strong)BudgetItem                *budgetItem;

@property(nonatomic,strong)NSDateFormatter           *outputFormatter;
@property(nonatomic,strong)NSString                  *typeOftodo;
@property(nonatomic,strong)BudgetTemplate            *budgetTemplate;
@property(nonatomic,strong)IBOutlet UIView           *noRecordView;

@property(nonatomic,strong)NSDate                    *startDate;
@property(nonatomic,strong)NSDate                    *endDate;

@property(nonatomic,strong)TransferViewController_NS *transferViewController;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;



- (void) getDataSouce;


@end
