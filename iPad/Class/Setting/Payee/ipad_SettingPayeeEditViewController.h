//
//  DetailPayeeViewController.h
//  PokcetExpense
//
//  Created by ZQ on 9/10/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Payee.h"
#import "Category.h"
#import "UICustomSwitch.h"
#import "ipad_TranscactionQuickEditViewController.h"

@class ipad_TranscactionQuickEditViewController;
@interface ipad_SettingPayeeEditViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
UIScrollViewDelegate> {
	
	UITableViewCell *nameCell;
	UITableViewCell *categoryCell;
	UITableViewCell *noteCell;
    
	UITextField*                 nameText;
    
	UILabel*                     CategoryLabel;
    UITextField*                  noteText;
    
    UILabel                     *nameLabelText;
    UILabel                     *categoryLabelText;
    UILabel                     *memoLabelText;
	
 	UITableView *showCellTable;
    
	double                      amountNum;
 	Payee*                       payees;
 	Category*                    categories;
 	NSString*                    typeOftodo;
    
    ipad_TranscationCategorySelectViewController *iTransactionCategoryViewController;
}

@property (nonatomic,strong) IBOutlet UITableViewCell *nameCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *categoryCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *noteCell;

@property (nonatomic,strong) IBOutlet UITextField*          nameText;

@property (nonatomic,strong) IBOutlet UILabel*        CategoryLabel;
@property (nonatomic,strong) IBOutlet UITextField*    noteText;

@property (nonatomic,strong) IBOutlet UILabel                     *nameLabelText;
@property (nonatomic,strong) IBOutlet UILabel                     *categoryLabelText;
@property (nonatomic,strong) IBOutlet UILabel                     *memoLabelText;

@property (nonatomic,strong) IBOutlet UITableView *showCellTable;


@property (nonatomic,strong) Payee*                       payees;
@property (nonatomic,strong) Category*                    categories;
@property (nonatomic,strong) NSString*		typeOftodo;

@property(nonatomic,strong) ipad_TranscationCategorySelectViewController *iTransactionCategoryViewController;
-(void)refleshUI;
@end
