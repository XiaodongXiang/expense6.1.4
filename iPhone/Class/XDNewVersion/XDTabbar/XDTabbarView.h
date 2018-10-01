//
//  XDTabbarView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/1.
//

#import <UIKit/UIKit.h>

typedef void(^returnSelectedItem)(NSInteger index);

@interface XDTabbarView : UIView
@property(nonatomic, copy)returnSelectedItem block;

@end
