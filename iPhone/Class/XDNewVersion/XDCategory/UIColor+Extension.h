//
//  UIColor+Extension.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/5.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;
+ (CAGradientLayer *)setGradualSecondChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;
+(UIColor*)mostColor:(UIImage*)image;


+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
