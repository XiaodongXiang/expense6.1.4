//
//  XDAppriater.h
//  PocketExpense
//
//  Created by 下大雨 on 2018/7/20.
//

#define XDAPPIRATERNUMBERWITHIMPORTANTEVENT   10

#import <Foundation/Foundation.h>

@interface XDAppriater : NSObject
+(XDAppriater*)shareAppirater;
- (BOOL)connectedToNetwork;

-(void)showAppirater;
-(void)judgeShowRateView;
-(void)setEmptyAppirater;
@end
