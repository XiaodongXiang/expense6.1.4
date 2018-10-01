//
// 
//  
//
//  Created by Joe Jia on 3/17/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountType.h"
@class AccountEditViewController; 
@interface AccountTypeViewController : UITableViewController
{
	NSMutableArray*									accountTypeList;
}

@property (nonatomic, strong) AccountEditViewController*	 accEditView;

-(void)reflashUI;
 @end

 

