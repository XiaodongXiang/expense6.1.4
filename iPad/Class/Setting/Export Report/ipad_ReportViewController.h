//
//  ipad_ReportViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-19.
//
//

#import <UIKit/UIKit.h>

@class ipad_ADSDeatailViewController;
@interface ipad_ReportViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *myTableView;
    UITableViewCell *transactionCSVcell;
    UITableViewCell *transactionPDFcell;
    UITableViewCell *flowcell;
    UITableViewCell *billcell;
    
    UILabel         *transactioncsvlabelText;
    UILabel         *transactionpdflabelText;
    UILabel         *flowlabelText;
    
}

@property(nonatomic,strong)IBOutlet UITableView     *myTableView;
@property(nonatomic,strong)IBOutlet UITableViewCell *transactionCSVcell;
@property(nonatomic,strong)IBOutlet UITableViewCell *transactionPDFcell;
@property(nonatomic,strong)IBOutlet UITableViewCell *flowcell;
@property(nonatomic,strong)IBOutlet UITableViewCell *billcell;

@property(nonatomic,strong)IBOutlet UILabel         *transactioncsvlabelText;
@property(nonatomic,strong)IBOutlet UILabel         *transactionpdflabelText;
@property(nonatomic,strong)IBOutlet UILabel         *flowlabelText;

@property(nonatomic,strong)IBOutlet UIImageView *proImage1;
@property(nonatomic,strong)IBOutlet UIImageView *proImage2;
@property (nonatomic, strong)ipad_ADSDeatailViewController *adsDetailViewController;
@end
