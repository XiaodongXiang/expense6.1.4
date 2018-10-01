//
//  numberKeyboardView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/5.
//

#import <UIKit/UIKit.h>

typedef void(^returnAmount)(NSString* string);
@interface numberKeyboardView : UIView

@property(nonatomic, copy)returnAmount  amountBlock;

@property(nonatomic, assign)BOOL needCaculate;
@property(nonatomic, assign)BOOL reset;
@property(nonatomic, copy)NSString * oldAmountString;

@end
