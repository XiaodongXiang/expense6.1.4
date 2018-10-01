//
//  BillCategoryViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-6.
//
//

#import <UIKit/UIKit.h>

#import "Category.h"

@class BillEditViewController;

@interface BillCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    
    UITableView             *categoryTableView;
    NSMutableArray          *categoryArray;
    
    Category                *category;
    
    NSInteger               deleteIndex;
    BillEditViewController  *billEditViewController;

}

@property(nonatomic,strong)IBOutlet UITableView     *categoryTableView;
@property(nonatomic,strong)NSMutableArray           *categoryArray;

@property(nonatomic,strong)Category                *category;

@property(nonatomic,assign)NSInteger               deleteIndex;

@property(nonatomic,strong)BillEditViewController   *billEditViewController;

-(void)refleshUI;

@end
