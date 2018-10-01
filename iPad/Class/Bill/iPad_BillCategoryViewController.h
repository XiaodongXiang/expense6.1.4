//
//  iPad_BillCategoryViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-16.
//
//

#import <UIKit/UIKit.h>
#import "Category.h"

@class ipad_BillEditViewController;

@interface iPad_BillCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    
    UITableView             *categoryTableView;
    NSMutableArray          *categoryArray;
    
    Category                *category;
    
    NSInteger               deleteIndex;
    ipad_BillEditViewController  *iBillEditViewController;
    
}

@property(nonatomic,strong)IBOutlet UITableView     *categoryTableView;
@property(nonatomic,strong)NSMutableArray           *categoryArray;

@property(nonatomic,strong)Category                *category;

@property(nonatomic,assign)NSInteger               deleteIndex;

@property(nonatomic,strong)ipad_BillEditViewController  *iBillEditViewController;

-(void)refleshUI;


@end
