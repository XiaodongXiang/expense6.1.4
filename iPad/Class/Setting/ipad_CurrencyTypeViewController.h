//
// 
//  
//
//  Created by Joe Jia on 3/17/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting+CoreDataClass.h"
#import "ipad_SettingViewController.h"
 
@interface ipad_CurrencyTypeViewController : UITableViewController 
{
 	NSMutableArray*									filteredFrequency;
	NSMutableArray*                                 symbolArray;
	NSMutableArray*                                 nameArray;
	NSString*                                       selectedCurrency;
	NSMutableArray									*currencyArray;
	NSMutableArray									*currencyNameArray;
	UITableView*                                    mytableview;
 }

@property (nonatomic, strong) NSMutableArray*			    filteredFrequency;
@property (nonatomic, strong) NSString*                     selectedCurrency;
@property (nonatomic, strong) NSMutableArray*               currencyArray;
@property (nonatomic, strong) NSMutableArray*               currencyNameArray;
@property (nonatomic, strong) NSMutableArray*               symbolArray;
@property (nonatomic, strong) NSMutableArray*               nameArray;
 

@end
 
