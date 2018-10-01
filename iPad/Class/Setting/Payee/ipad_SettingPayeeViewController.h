//
//  ipad_SettingPayeeViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-19.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class ipad_SettingPayeeEditViewController;
@interface ipad_SettingPayeeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate,NSFetchedResultsControllerDelegate>
{
    NSInteger deleteIndex;
}

@property (nonatomic,strong) IBOutlet UIView *noRecordView;
@property (nonatomic,strong) NSMutableArray*                  payeesArray;

@property (nonatomic,strong) IBOutlet UITableView*             mytableview;
@property (nonatomic,strong) IBOutlet UILabel *reminderLabelText;

@property(nonatomic,strong)ipad_SettingPayeeEditViewController *iSettingPayeeEditViewController;
@property (nonatomic,strong) NSFetchedResultsController     *fetchRequestResultsController;

- (void)getDataSouce;
-(void)refleshUI;

@end
