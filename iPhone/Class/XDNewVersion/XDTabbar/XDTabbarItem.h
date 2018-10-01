//
//  XDTabbarItem.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/1.
//

#import <UIKit/UIKit.h>

@interface XDTabbarItem : UIButton

@property(nonatomic, copy)NSString * titleStr;
@property(nonatomic, copy)NSString * imageStr;
@property(nonatomic, copy)NSString * selectImageStr;
@property(nonatomic, assign)BOOL itemSelected;

@end
