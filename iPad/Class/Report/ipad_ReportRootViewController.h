//
//  ipad_ReportRootViewController.h
//  PocketExpense
//
//  Created by appxy_dev on 14-5-4.
//
//

#import <UIKit/UIKit.h>
#import "SVTopScrollView.h"
#import "SVRootScrollView.h"
#import "SVGloble.h"

#import "ipad_ReportCashFlowViewController.h"
#import "ipad_ReportCategotyViewController.h"

//@class ipad_ReportCategotyViewController,ipad_ReportCashFlowViewController,ipad_ReportComparisonViewController;

@interface ipad_ReportRootViewController : UIViewController
{
    ipad_ReportCategotyViewController *categoryVC;
    ipad_ReportCashFlowViewController *cashFlowVC;
    
    SVTopScrollView *topScrollView;
    SVRootScrollView *rootScrollView;
}

@property(strong,nonatomic)ipad_ReportCategotyViewController *categoryVC;
@property(strong,nonatomic)ipad_ReportCashFlowViewController *cashFlowVC;
//@property(strong,nonatomic)ipad_ReportComparisonViewController *comparisonVC;
@property(strong,nonatomic)SVTopScrollView *topScrollView;
@property(strong,nonatomic)SVRootScrollView *rootScrollView;

-(void)reFlashTableViewData;
-(void)refleshUI;

@end
