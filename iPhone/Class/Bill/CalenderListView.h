//
//  CalenderListView.h
//  BillKeeper
//
//  Created by APPXY_DEV on 13-9-5.
//  Copyright (c) 2013年 APPXY_DEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillsViewController;
@interface CalenderListView : UIView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIActionSheetDelegate>{
    UITableView *clv_monthTableView;
    
    NSDateFormatter *clv_monthDateFormatter;
    NSDateFormatter *yearFormatter;
    NSDateFormatter *monthFormatter;
    
    NSMutableArray *clv_monthDataArray;//这个是存放横划view的数组的

    
    //用来显示选中月份的控件
    UIImageView *clv_greenImageView;
    UILabel *clv_yearLabel;
    UILabel *clv_monthLabel;
    UIImageView *clv_expiredImage;
    
    long monthTableRowCount;
    NSDate *startDate;
    NSDate *endDate;
    NSInteger selectedMonth;
    
    NSIndexPath *clv_billSelectedIndexPath;
    NSMutableArray  *clv_expiredArray;
    
    BillsViewController *clv_billsViewController;
}
@property(nonatomic,strong)UITableView              *clv_monthTableView;

@property(nonatomic,strong)NSDate                   *startDate;
@property(nonatomic,strong)NSDate                   *endDate;
@property(nonatomic,strong)NSMutableArray           *clv_monthDataArray;

@property(nonatomic,strong)UIImageView *clv_greenImageView;
@property(nonatomic,strong)UILabel *clv_yearLabel;
@property(nonatomic,strong)UILabel *clv_monthLabel;
@property(nonatomic,strong)UIImageView *clv_expiredImage;

@property(nonatomic,strong)NSIndexPath *clv_billSelectedIndexPath;
@property(nonatomic,strong)NSMutableArray  *clv_expiredArray;

@property(nonatomic,strong)BillsViewController *clv_billsViewController;
//-(void)resetData;

@end
