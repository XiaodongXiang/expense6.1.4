//
//  TripsViewController.h
//  Mileage Buddy
//
//  Created by Tommy on 3/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class CategoryTotal ,PayeeTotal;
@interface ipad_CategoryTransactionViewController : UITableViewController  {
  	NSDateFormatter				*outputFormatter;
    CategoryTotal *ct;
    PayeeTotal *pt;
}
@property (nonatomic, strong) NSDateFormatter			*outputFormatter;
@property (nonatomic, strong) CategoryTotal *ct;
@property (nonatomic, strong) PayeeTotal *pt;
@end
