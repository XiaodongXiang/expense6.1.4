//
//  FatherCategorySelectedViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-7-15.
//
//

#import <UIKit/UIKit.h>
#import "Category.h"

@class CategoryEditViewController;
@interface FatherCategorySelectedViewController : UIViewController

@property(nonatomic,strong)IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSMutableArray       *parentCategoryArray;
@property(nonatomic,strong)Category             *parentCategory;
@property(nonatomic,strong)NSString             *categoryType;
@property(nonatomic,strong)CategoryEditViewController *categoryEditViewController;
@end
