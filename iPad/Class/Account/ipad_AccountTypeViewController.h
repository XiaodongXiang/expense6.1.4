//
// 
//  
//
//  Created by Joe Jia on 3/17/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountType.h"
#import "Accounts.h"
@class ipad_AccountEditViewController,ipad_AccountTypeEditViewController;

@interface ipad_AccountTypeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
	NSMutableArray      *accountTypeList;
 }

@property (nonatomic, strong) ipad_AccountEditViewController*	 accEditView;
@property (nonatomic, strong) IBOutlet UITableView         *type_tableView;

-(void)refleshUI;
 @end

 

