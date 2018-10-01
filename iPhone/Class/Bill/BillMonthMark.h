//
//  BillMonthMark.h
//  PocketExpense
//
//  Created by humingjing on 14-4-8.
//
//

#import <Foundation/Foundation.h>

@interface BillMonthMark : NSObject
{
    BOOL    isMarked;
    NSDate  *date;
    int     unClearedNum;
}

@property(nonatomic,assign)BOOL    isMarked;
@property(nonatomic,retain)NSDate  *date;
@property(nonatomic,assign)int     unClearedNum;

@end
