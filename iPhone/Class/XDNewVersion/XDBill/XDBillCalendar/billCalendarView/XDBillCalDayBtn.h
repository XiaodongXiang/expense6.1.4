//
//  XDBillCalDayBtn.h
//  PocketExpense
//
//  Created by 晓东 on 2018/4/9.
//

#import <UIKit/UIKit.h>

@interface XDBillCalDayBtn : UIButton

@property(nonatomic, strong)NSDate * date;
@property(nonatomic, assign)BOOL lightColor;

@property(nonatomic, copy)NSString* pointColor;

@end
