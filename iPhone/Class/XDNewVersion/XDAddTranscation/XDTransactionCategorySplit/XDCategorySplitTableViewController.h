//
//  XDCategorySplitTableViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/1/31.
//

#import <UIKit/UIKit.h>

@protocol XDCategorySplitTableViewDelegate <NSObject>
-(void)returnSelectedSplitArray:(NSArray*)array;
@end
@interface XDCategorySplitTableViewController : UITableViewController
@property(nonatomic, weak)id<XDCategorySplitTableViewDelegate> splitDelegate;

@property(nonatomic, assign)NSMutableArray * editSplitMuArr;


@end
