//
// 
//  
//
//  Created by Joe Jia on 3/17/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyCell.h"
#import "Setting+CoreDataClass.h"
//#import "ipad_SettingViewController.h"

@interface CurrencyTypeViewController : UITableViewController 
{
  	NSMutableArray*									filteredFrequency;
	NSMutableArray*                                 symbolArray;
	NSMutableArray*                                 nameArray;
	NSString*                                       selectedCurrency;
	NSMutableArray									*currencyArray;
	NSMutableArray									*currencyNameArray;
    NSInteger selectIndexPath;
 }

 @property (nonatomic, strong) NSManagedObjectContext*		managedObjectContext;
@property (nonatomic, strong) NSMutableArray*			    filteredFrequency;
@property (nonatomic, strong) NSString*                     selectedCurrency;
@property (nonatomic, strong) NSMutableArray*               currencyArray;
@property (nonatomic, strong) NSMutableArray*               currencyNameArray;
 @property (nonatomic, strong) NSMutableArray*               symbolArray;
@property (nonatomic, strong) NSMutableArray*               nameArray;
 @property (nonatomic, assign) NSInteger selectIndexPath;

@end

 
