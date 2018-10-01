//
//  ExportSelectedAccountViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-22.
//
//

#import <UIKit/UIKit.h>
@class EmailViewController,RepTransactionFilterViewController;
@interface ExportSelectedAccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@property(nonatomic,strong)IBOutlet UITableView     *accountTable;
@property(nonatomic,strong)IBOutlet UILabel         *selecedAccountAmountLabel;
@property(nonatomic,strong)IBOutlet UIButton        *selectedAllBtn;

@property(nonatomic,assign) NSInteger                selectedItemCount;

@property(nonatomic,strong)IBOutlet UILabel         *selectAllLabelText;

@property(nonatomic,strong) NSMutableArray          *accountArray;
@property(nonatomic,strong) EmailViewController     *emailViewController;

@property(nonatomic,strong) RepTransactionFilterViewController *transactionPDFViewController;

@end
