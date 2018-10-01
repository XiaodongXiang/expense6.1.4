//
//  TranscationPayeeSelectViewController.h
//  PocketExpense
//
//  Created by Tommy on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class SettingPayeeEditViewController;
@interface SettingPayeeViewController :  UIViewController
<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIPopoverControllerDelegate,NSFetchedResultsControllerDelegate>
{
    NSInteger deleteIndex;
}

@property (nonatomic,strong) IBOutlet UIView *noRecordView;

@property (nonatomic,strong) IBOutlet UITableView*             mytableview;
@property (nonatomic,strong) IBOutlet UILabel *reminderLabelText;

@property(nonatomic,strong)SettingPayeeEditViewController *settingPayeeEditViewController;
@property (nonatomic,strong) NSFetchedResultsController     *fetchRequestResultsController;

- (void)getDataSouce;
-(void)refleshUI;
@end

