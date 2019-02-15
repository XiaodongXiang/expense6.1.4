//
//  numberKeyboardView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/5.
//

#import <UIKit/UIKit.h>




typedef void(^returnAmount)(NSString* string);
typedef void(^completedTransaction)();
@interface numberKeyboardView : UIView

@property(nonatomic, copy)returnAmount  amountBlock;
@property(nonatomic, copy)completedTransaction  completed;

@property(nonatomic, assign)BOOL needCaculate;
@property(nonatomic, assign)BOOL reset;
@property(nonatomic, copy)NSString * oldAmountString;

@end
