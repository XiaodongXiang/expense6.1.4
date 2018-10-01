//
//  UINavigationItem+Shan.m
//  PocketSchedule
//
//  Created by Shan on 14/11/18.
//  Copyright (c) 2014年 Shan. All rights reserved.
//

#import "UINavigationItem+Custom.h"

@implementation UINavigationItem (Custom)

//重写backBarButtonItem，直接放在这里，系统会调用的
- (UIBarButtonItem *)backBarButtonItem
{
    //返回按钮+图片
//    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back_30_30.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
//    backBar.width = 30;
    
    //返回箭头+上一层的文字
//    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:nil action:nil];
//    backBar.width = 30;
    
    //返回箭头
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@".png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //这个是backbotton 所以设置一般的bar背景没用，需要用下面的方法
//    [backBar setBackButtonBackgroundImage:[UIImage imageNamed:@"icon_add_30_30_iPhone.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //为什么这样会被压缩呢
//    backBar.width = 42;

    
    //为什么这样不行呢？
//    [backBar setBackButtonBackgroundImage:[UIImage imageNamed:@"icon_add_30_30_iPhone.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //设置文字的偏移
//    UIOffset offset1 = UIOffsetMake(-5, 0);
//    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:offset1 forBarMetrics:UIBarMetricsDefault];
    
    return backBar;

    
//    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back_30_30.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
//    backBar.width = 30;
//    return backBar;
    

//    UIButton    *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
//    [btn setImage:[UIImage imageNamed:@"icon_back_30_30.png"] forState:UIControlStateNormal];
//    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:<#(UIBarButtonSystemItem)#> target:<#(id)#> action:<#(SEL)#>
    
}

@end
