//
//  ZTwitter.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ZTwitter : NSManagedObject

@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSNumber * twitterAnnouncementsType;
@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSString * accessTokenSecret;
@property (nonatomic, retain) NSString * requestToken;
@property (nonatomic, retain) NSString * userWhiteList;
@property (nonatomic, retain) NSNumber * twitterEnabled;
@property (nonatomic, retain) NSString * requestTokenSecret;
@property (nonatomic, retain) NSString * accessToken;

@end
