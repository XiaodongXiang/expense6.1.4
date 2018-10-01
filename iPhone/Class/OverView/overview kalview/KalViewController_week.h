/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
#import "KalView_week.h"
#import "KalDataSource_week.h"

@class KalLogic_week, KalDate_week;

@interface KalViewController_week : UIViewController <KalViewDelegate_week, KalDataSourceCallbacks_week>
{
  KalLogic_week *logic;
    
  UITableView *tableView;
  id <UITableViewDelegate> delegate;
  id <KalDataSource_week> dataSource;
  NSDate *initialDate;
    NSDate *selectedDate;
    KalView_week *kalView;
    
    NSDate  *startDate;
    NSDate  *endDate;
    
    
}

@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) id<UITableViewDelegate> delegate;
@property (nonatomic, strong) id<KalDataSource_week> dataSource;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong)KalLogic_week *logic;
@property (nonatomic, strong)KalView_week *kalView;

@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate  *endDate;

- (id)initWithSelectedDate:(NSDate *)selectedDate;
- (void)reloadData;
- (void)showAndSelectDate:(NSDate *)date;

-(void)showCurrentDay_Month;
@end
