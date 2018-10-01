//
//  budgetBar_iPad.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/27.
//
//

#import <UIKit/UIKit.h>

@interface budgetBar_iPad : UIView

@property(nonatomic,strong) UIImageView *top;
-(id)initWithFrame:(CGRect)frame type:(NSString *)barType ratio:(float)ratio color:(UIColor *)color;

@end
