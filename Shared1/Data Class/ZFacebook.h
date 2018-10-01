//
//  ZFacebook.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ZFacebook : NSManagedObject

@property (nonatomic, retain) NSNumber * facebookEnabled;
@property (nonatomic, retain) NSString * userWhiteList;
@property (nonatomic, retain) NSNumber * facebookAnnouncementsType;
@property (nonatomic, retain) NSString * userName;

@end
