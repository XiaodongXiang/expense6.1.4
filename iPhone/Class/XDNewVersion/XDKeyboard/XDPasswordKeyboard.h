//
//  XDPasswordKeyboard.h
//  PocketExpense
//
//  Created by 晓东项 on 2019/1/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XDPasswordKeyBboardDelegate <NSObject>

-(void)returnPassword:(NSString*)string;

@end
@interface XDPasswordKeyboard : UIView

@property(nonatomic, weak)id<XDPasswordKeyBboardDelegate> xxdDelegate;

-(void)reset;
@end

NS_ASSUME_NONNULL_END
