//
//  CashFlowReports.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CashFlowReports : NSManagedObject

@property (nonatomic, retain) NSDate * genDateTime;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * reportName;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * columnString;

@end
