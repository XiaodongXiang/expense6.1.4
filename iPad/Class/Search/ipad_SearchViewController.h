//
//  ipad_SearchViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-8-26.
//
//

#import <UIKit/UIKit.h>

@class ipad_MainViewController;
@interface ipad_SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *myTableView;
    UIView      *searchView;
    UIImageView *seachIcon;
    UITextField *searchField;
    
    NSDateFormatter *outputFormatter;
    
    NSMutableArray  *transactionArray;
    
    BOOL firstToBeHere;
    
}
@property(nonatomic,strong)IBOutlet UITableView *myTableView;
@property(nonatomic,strong)IBOutlet UIView      *searchView;
@property(nonatomic,strong)IBOutlet UIImageView *seachIcon;
@property(nonatomic,strong)IBOutlet UITextField *searchField;

@property(nonatomic,strong)NSMutableArray  *transactionArray;
@property(nonatomic,assign)BOOL firstToBeHere;
@end
