//
//  ipad_ExportSelectedAccountViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-20.
//
//

#import <UIKit/UIKit.h>

@class ipad_EmailViewController,ipad_RepTransactionFilterViewController;

@interface ipad_ExportSelectedAccountViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>{
    UITableView     *accountTable;
    UILabel         *selecedAccountAmountLabel;
    UIButton        *selectedAllBtn;
    
    NSInteger       selectedItemCount;

    UILabel         *selectAllLabelText;
    
    NSMutableArray  *accountArray;
    ipad_EmailViewController *emailViewController;
    ipad_RepTransactionFilterViewController *transactionPDFViewController;
    
}

@property(nonatomic,strong)IBOutlet UITableView     *accountTable;
@property(nonatomic,strong)IBOutlet UILabel         *selecedAccountAmountLabel;
@property(nonatomic,strong)IBOutlet UIButton        *selectedAllBtn;

@property(nonatomic,assign) NSInteger                selectedItemCount;

@property(nonatomic,strong)IBOutlet UILabel         *selectAllLabelText;


@property(nonatomic,strong) NSMutableArray          *accountArray;
@property(nonatomic,strong) ipad_EmailViewController *emailViewController;
@property(nonatomic,strong) ipad_RepTransactionFilterViewController *transactionPDFViewController;


@end
