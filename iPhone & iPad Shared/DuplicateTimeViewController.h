//
//  DuplicateTimeViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-16.
//
//

#import <UIKit/UIKit.h>

@protocol DuplicateTimeViewControllerDelegate <NSObject>

-(void)setDuplicateDateDelegate:(NSDate *)date;
-(void)setDuplicateGoOnorNotDelegate:(BOOL)goon;

@end

@class OverViewWeekCalenderViewController,Transaction;

@interface DuplicateTimeViewController : UIViewController

@property(nonatomic,strong)IBOutlet UIView      *dateSelectedView;
@property(nonatomic,strong)IBOutlet UIButton    *dateSelectedViewCancleBtn;
@property(nonatomic,strong)IBOutlet UIButton    *dateSelectedViewDoneBtn;

@property(nonatomic,strong)IBOutlet UILabel                         *titleLabelText;

@property(nonatomic,strong)IBOutlet UIDatePicker*datePickerView;
@property(nonatomic,strong)Transaction                     *trans;
@property(nonatomic,strong)id<DuplicateTimeViewControllerDelegate> delegate;




@end
