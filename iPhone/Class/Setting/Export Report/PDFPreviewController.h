//
//  PDFPreviewController.h
//  PocketExpense
//
//  Created by MV on 12-1-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TransactionReports.h"
#import "CashFlowReports.h"
#import "BillReports.h"
#import "BudgetReports.h"
#import "ReaderContentView.h"

@class RepTransactionFilterViewController,RepCashflowFilterViewController,RepBudgetFilterViewController,RepBillFilterViewController;
@interface PDFPreviewController : UIViewController<UIActionSheetDelegate,UIScrollViewDelegate,MFMailComposeViewControllerDelegate,UIGestureRecognizerDelegate>


@property(nonatomic,strong) IBOutlet UIActivityIndicatorView    *activityIndicatorView;

//显示pdf的scrollview
@property(nonatomic,strong) ReaderScrollView                    *theScrollView;
@property(nonatomic,strong) UIActivityIndicatorView             *indicatorView;
@property(nonatomic,copy)   NSString                            *pdfType;//pdf数据类型
@property(nonatomic,assign) NSInteger                           pdfPageCount;//页数
@property(nonatomic,assign) BOOL                                isAccount;
@property(nonatomic,assign) NSInteger                           cunrrentpdfPageIndex;//当前处于第几页

//@property(nonatomic,strong) NSMutableArray                      *contentViews;
@property(nonatomic,strong) NSMutableArray                      *tranAccountSelectArray;
@property(nonatomic,strong) NSMutableArray                      *tranCategorySelectArray;

@property(nonatomic,strong) RepTransactionFilterViewController  *repTranFilterVC;
@property(nonatomic,strong) RepCashflowFilterViewController     *repCashFlowFilterVC;

@property(nonatomic,strong) NSMutableParagraphStyle             *psCenter;
@property(nonatomic,strong) NSMutableParagraphStyle             *psLeft;
@property(nonatomic,strong) NSMutableParagraphStyle             *psRight;
@property(nonatomic,strong) NSDictionary                        *attrLeft;
@property(nonatomic,strong) NSDictionary                        *attrRight;
@property(nonatomic,strong) NSDictionary                        *attrCenter;
@property(nonatomic,strong) NSDictionary                        *attrBoldCenter;
@property(nonatomic,strong) NSDictionary                        *attrBoldMTLeft;

@end
