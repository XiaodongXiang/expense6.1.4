//
//  XDAccountCategoryView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/7.
//

#import <UIKit/UIKit.h>

@class AccountType;
@protocol XDAccountCategoryDelegate <NSObject>
-(void)returnSelectedAccountCategory:(AccountType*)accountType;
-(void)editBtnClick;
@end
@interface XDAccountCategoryView : UIView
@property(nonatomic, weak)id<XDAccountCategoryDelegate> delegate;
@property(nonatomic, strong)AccountType * selectAccountType;

@end
