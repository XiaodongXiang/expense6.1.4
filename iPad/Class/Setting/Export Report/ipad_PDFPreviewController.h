//
//  ipad_PDFPreviewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-20.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TransactionReports.h"
#import "CashFlowReports.h"
#import "BillReports.h"
#import "BudgetReports.h"
#import "ReaderContentView.h"

@class ipad_RepTransactionFilterViewController;
@class ipad_RepCashflowFilterViewController;
@class RepBudgetFilterViewController,RepBillFilterViewController;
@interface ipad_PDFPreviewController : UIViewController

<UIActionSheetDelegate,
UIScrollViewDelegate,
MFMailComposeViewControllerDelegate,
//ReaderContentViewDelegate,
UIGestureRecognizerDelegate>
{
    ReaderScrollView *theScrollView;
	UIActivityIndicatorView							* indicatorView;
    ipad_RepTransactionFilterViewController *repTranFilterVC;
    ipad_RepCashflowFilterViewController *repCashFlowFilterVC;
    RepBudgetFilterViewController *repBudgetFilterVC;
    RepBillFilterViewController *repBillFilterVC;
    NSMutableArray *tranAccountSelectArray;
	NSMutableArray *tranCategorySelectArray;
	NSMutableArray *budgetSelectArray;
    
	NSMutableArray *billCategorySelectArray;
    
    NSString *pdfType;
    BOOL      isAccount;
    NSInteger pdfPageCount;
    NSInteger cunrrentpdfPageIndex;
    
    TransactionReports *itr;
    CashFlowReports *icr;
    BillReports *ibrep;
    BudgetReports *ibr;
    UIActivityIndicatorView *activityIndicatorView;
	NSMutableArray *contentViews;
    
    NSMutableParagraphStyle *psCenter;
    NSMutableParagraphStyle *psLeft;
    NSMutableParagraphStyle *psRight;
    NSDictionary *attrLeft;
    NSDictionary *attrRight;
    NSDictionary *attrCenter;
    NSDictionary *attrBoldCenter;
    NSDictionary *attrBoldMTLeft;
    
}
@property(nonatomic,strong) ReaderScrollView *theScrollView;
@property(nonatomic,strong) UIActivityIndicatorView	 * indicatorView;
@property(nonatomic,strong) ipad_RepTransactionFilterViewController *repTranFilterVC;
@property(nonatomic,strong) ipad_RepCashflowFilterViewController *repCashFlowFilterVC;
@property(nonatomic,strong) RepBudgetFilterViewController *repBudgetFilterVC;
@property(nonatomic,strong) RepBillFilterViewController *repBillFilterVC;
@property(nonatomic,copy)  NSString *pdfType;
@property(nonatomic,assign) NSInteger pdfPageCount;
@property(nonatomic,assign) BOOL      isAccount;
@property(nonatomic,strong) NSMutableArray *tranAccountSelectArray;
@property(nonatomic,strong) NSMutableArray *tranCategorySelectArray;
@property(nonatomic,strong) NSMutableArray *budgetSelectArray;
@property(nonatomic,strong) NSMutableArray *billCategorySelectArray;

@property(nonatomic,strong) TransactionReports *itr;
@property(nonatomic,strong) CashFlowReports *icr;
@property(nonatomic,strong) BillReports *ibrep;
@property(nonatomic,strong) BudgetReports *ibr;
@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic,assign)  NSInteger cunrrentpdfPageIndex;

@property(nonatomic,strong) NSMutableParagraphStyle *psCenter;
@property(nonatomic,strong) NSMutableParagraphStyle *psLeft;
@property(nonatomic,strong) NSMutableParagraphStyle *psRight;
@property(nonatomic,strong) NSDictionary            *attrLeft;
@property(nonatomic,strong) NSDictionary            *attrRight;
@property(nonatomic,strong) NSDictionary            *attrCenter;
@property(nonatomic,strong) NSDictionary            *attrBoldCenter;
@property(nonatomic,strong) NSDictionary            *attrBoldMTLeft;

@end
