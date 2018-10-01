//
//  UINavigationBar+Custom.m
//  PocketExpense
//
//  Created by humingjing on 14/12/16.
//
//

#import "UINavigationBar+Custom.h"
#import "PokcetExpenseAppDelegate.h"

@implementation UINavigationBar(Custom)


-(void)doSetNavigationBar
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //设置背景
    UIImage *image1 = [UIImage imageNamed:@"calendar_nav.png"];
    [self setBackgroundImage:image1 forBarMetrics:UIBarMetricsDefault];
//    UIImage *image = [[UIImage alloc]init];
//    self.shadowImage = image;
    
    //设置title字体颜色
    UIColor *navColor_iPad = [appDelegate.epnc getiPadNavigationBarTiltleTeextColor];
    if (ISPAD)
        [self setTitleTextAttributes: @{
                                        NSForegroundColorAttributeName: navColor_iPad,
                                        NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:17]
                                        }];
    else
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1],
                                                                          NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17
                                                                                               ]}];

    
    //设置返回按钮的颜色
    UIColor *tintColor = [UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    UIColor *tintColor_iPad = [appDelegate.epnc getiPadNavigationBarTiltleTeextColor];
    if (ISPAD)
        [self setTintColor:tintColor_iPad];
    else
        [self setTintColor:tintColor];
}
@end
