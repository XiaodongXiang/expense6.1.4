//
//  ipad_RepCashflowFilterViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-20.
//
//

#import <UIKit/UIKit.h>

@interface ipad_RepCashflowFilterViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView     *myTableView;
    UITableViewCell*						 cellType;
    UITableViewCell*												cellDateRange;
    UITableViewCell*												cellDateColumn;
    UILabel*                                                        lblDateRange;
    UILabel*                                                        lblDateColumn;
    UIButton            *allBtn;
    UIButton            *outFlowBtn;
    UIButton            *inFlowBtn;
    
    UILabel         *typeLabelText;
    UILabel         *dateRangeLabelText;
    UILabel         *columnLabelText;
    UIButton            *generateBtn;

    
	NSDate*															startDate;
	NSDate*															endDate;
    NSString *cashDateTypeString;
}

@property (nonatomic, strong) IBOutlet UITableView     *myTableView;
@property (nonatomic, strong) IBOutlet UITableViewCell*						 cellType;
@property (nonatomic, strong) IBOutlet UITableViewCell*				cellDateRange;
@property (nonatomic, strong) IBOutlet UITableViewCell*				cellDateColumn;
@property (nonatomic, strong) IBOutlet UILabel*                     lblDateRange;
@property (nonatomic, strong) IBOutlet UILabel*                     lblDateColumn;
@property (nonatomic, strong) IBOutlet UIButton            *allBtn;
@property (nonatomic, strong) IBOutlet UIButton            *outFlowBtn;
@property (nonatomic, strong) IBOutlet UIButton            *inFlowBtn;

@property (nonatomic, strong) IBOutlet UILabel         *typeLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *dateRangeLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *columnLabelText;
@property (nonatomic, strong) IBOutlet UIButton            *generateBtn;


@property (nonatomic, strong) NSDate*								startDate;
@property (nonatomic, strong) NSDate*								endDate;
@property (nonatomic, copy)  NSString *cashDateTypeString;
-(IBAction)generateReportBtn:(id)sender;

@end
