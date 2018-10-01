//
//  XDBudgetSelectTableViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/16.
//

#import <UIKit/UIKit.h>

@protocol  XDBudgetSelectTableViewDelegate <NSObject>
-(void)returnSelectCategoryArray:(NSMutableArray *)array;
@end

@interface XDBudgetSelectTableViewController : UITableViewController

@property(nonatomic, weak)id<XDBudgetSelectTableViewDelegate> selectDelegate;
@property(nonatomic, strong)NSMutableArray * selectMuArr;

@end
