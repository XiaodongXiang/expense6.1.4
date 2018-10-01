//
//  NewGroupViewController.h
//  Expense 5
//
//  Created by ZQ on 9/9/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "HMJPickerView.h"

@class ipad_SettingPayeeEditViewController;
@class ipad_TranscactionQuickEditViewController;

@interface ipad_CategoryEditViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,HMJPickerViewDelegate>
{
    BOOL isParentCategory;
}

@property (nonatomic, strong) IBOutlet UITableView		*mytableView;
@property (nonatomic, strong) IBOutlet UITableViewCell	*nameCell;
@property (nonatomic, strong) IBOutlet UITableViewCell  *typeCell;

@property (nonatomic, strong) IBOutlet UITableViewCell  *iconCell;
@property (nonatomic, strong) IBOutlet UITableViewCell	 *subNameCell;

@property (nonatomic, strong) IBOutlet UITextField		*nameText;
@property (nonatomic, strong) IBOutlet UIImageView		*iconView;
@property (nonatomic, strong) IBOutlet UILabel  *suCategoryNameLabel;

@property (nonatomic, strong) IBOutlet UILabel       *nameLabelText;
@property (nonatomic, strong) IBOutlet UILabel       *typeLabelText;
@property (nonatomic, strong) IBOutlet UILabel       *subCategoryLabelText;
@property (nonatomic, strong) IBOutlet UILabel       *iconLabelText;

@property (nonatomic, strong) NSMutableArray			*iconArray;

@property (nonatomic, strong) NSString                  *editModule;
@property (nonatomic, strong) Category					*categories;
 
@property (nonatomic, strong) Category					*selectPCategory;

@property (nonatomic, strong) NSString					*iconName;
@property (nonatomic, assign) BOOL isEditParCate;

@property(nonatomic,strong)IBOutlet UIButton        *expenseBtn;
@property(nonatomic,strong)IBOutlet UIButton        *incomeBtn;
@property(nonatomic,strong)IBOutlet UIScrollView    *iconScrollView;
@property(nonatomic,strong)IBOutlet UIPageControl   *iconPageController;

@property(nonatomic,strong)NSMutableArray  *iconBtnArray;
@property(nonatomic,strong)ipad_TranscactionQuickEditViewController *transactionEditViewController;
@property(nonatomic,strong)ipad_SettingPayeeEditViewController   *payeeEditViewController;

-(void)refleshUI;
@end



