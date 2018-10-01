//
//  ipad_BillsViewController.h
//  PocketExpense
//
//  Created by Tommy on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "BillFather.h"

#import "KalViewController.h"
#import "KalDataSource_bill_iPhone.h"
#import "SWTableViewCell.h"

@class  ipad_BillEditViewController;
@class  ipad_PaymentViewController;
@class BillEditViewController;
@class PaymentViewController;
@interface BillCusBtn : UIButton {
	 NSInteger sectionindex;
    NSInteger rowindex;

}

@property (nonatomic, assign) NSInteger sectionindex;
@property (nonatomic, assign) NSInteger rowindex;
 
@end

@class ipad_BillEditViewController,ipad_PaymentViewController;
@interface ipad_BillsViewController : UIViewController<UIActionSheetDelegate,UIPopoverControllerDelegate,SWTableViewCellDelegate>{
    //日历
    UIView                      *calendarContainView;
    KalViewController           *kalViewController;
	id                          dataSource;
	
	UITableView                 *myTableview;
    UIButton                    *addBtn;
    UIView                      *noRemnderView;
	NSDateFormatter				*outputFormatter;
	NSDateFormatter				*outputFormatterCell;
    NSDate                      *bvc_MonthStartDate;
    NSDate                      *bvc_MonthEndDate;
   
    double                      totalExpenseAmount;
    double                      totalExpensePaidAmount;
    double                      totalPastAmount;
    double                      totalSevenDayAmount;
    double                      totalThirthDayAmount;
    NSMutableArray              *selectedMonthBill1Array;
    NSMutableArray              *selectedMonthbill2Array;
    NSMutableArray              *selectedMonthBillAllArray;
    NSMutableArray              *selectedMonthunpaidArray;
    NSMutableArray              *selectedMonthpaidArray;
    
    NSMutableArray              *bill1Array;
    NSMutableArray              *bill2Array;
    NSMutableArray              *totalBillsArray;
    NSMutableArray              *pastMutableArray;
    NSMutableArray              *sevenMutableArray;
    NSMutableArray              *thiredMutableArray;
    NSDate *thirtyDaysLater;
    NSDate  *yestary;
    NSDate  *sevendaysLater;
    
    NSIndexPath             *swipIndex;
    ipad_BillEditViewController *iBillEditVoewController;
    
    UILabel             *upcomingLabelText;
    UILabel             *noRecordLabelText;
    
    BOOL                needShowSelectedDateBillViewController;//是否需要显示某一天选中时的bill弹框

}

//日历
@property(nonatomic,strong)IBOutlet UIView             *calendarContainView;
@property(nonatomic,strong)KalViewController           *kalViewController;
@property(nonatomic,strong)id                           dataSource;

@property(nonatomic,strong)IBOutlet UITableView                 *myTableview;
@property(nonatomic,strong)IBOutlet UIButton                    *addBtn;
@property(nonatomic,strong)IBOutlet UIView                      *noRemnderView;
@property(nonatomic,strong)NSDateFormatter				*outputFormatter;
@property(nonatomic,strong)NSDateFormatter				*outputFormatterCell;
@property(nonatomic,strong)NSDate                      *bvc_MonthStartDate;
@property(nonatomic,strong)NSDate                      *bvc_MonthEndDate;


@property(nonatomic,assign)double                  totalExpenseAmount;
@property(nonatomic,assign)double                  totalExpensePaidAmount;
@property(nonatomic,assign)double                      totalPastAmount;
@property(nonatomic,assign)double                      totalSevenDayAmount;
@property(nonatomic,assign)double                      totalThirthDayAmount;
@property(nonatomic,strong)NSMutableArray              *selectedMonthBill1Array;
@property(nonatomic,strong)NSMutableArray              *selectedMonthbill2Array;
@property(nonatomic,strong)NSMutableArray              *selectedMonthBillAllArray;
@property(nonatomic,strong)NSMutableArray              *selectedMonthunpaidArray;
@property(nonatomic,strong)NSMutableArray              *selectedMonthpaidArray;

@property(nonatomic,strong)NSMutableArray              *bill1Array;
@property(nonatomic,strong)NSMutableArray              *bill2Array;
@property(nonatomic,strong)NSMutableArray              *totalBillsArray;
@property(nonatomic,strong)NSMutableArray              *pastMutableArray;
@property(nonatomic,strong)NSMutableArray              *sevenMutableArray;
@property(nonatomic,strong)NSMutableArray              *thiredMutableArray;

@property(nonatomic,strong)NSDate *thirtyDaysLater;
@property(nonatomic,strong)NSDate  *yestary;
@property(nonatomic,strong)NSDate  *sevendaysLater;

@property(nonatomic,strong)NSIndexPath             *swipIndex;
@property(nonatomic,strong)ipad_BillEditViewController *iBillEditVoewController;
@property(nonatomic,strong)ipad_PaymentViewController *iPaymentViewController;

@property(nonatomic,strong)IBOutlet UILabel             *upcomingLabelText;
@property(nonatomic,strong)IBOutlet UILabel             *noRecordLabelText;
@property (weak, nonatomic) IBOutlet UILabel *rightDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightPayeeLaebl;
@property (weak, nonatomic) IBOutlet UILabel *rightAMountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleLineW;
@property(nonatomic,assign)BOOL                needShowSelectedDateBillViewController;

-(void)reFlashBillModuleViewData;
- (void)payBillWithBills:(BillFather *)tmpBills;
-(void)getSelectedMonthData;
-(void)refleshUI;
-(void)resetCalendarStyle;

@end
