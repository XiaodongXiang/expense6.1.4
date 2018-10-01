//
//  UIHMJDatePicker.h
//  UIDatePickerTest
//
//  Created by APPXY_DEV on 13-8-7.
//  Copyright (c) 2013年 APPXY_DEV. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UIHMJDatePickerDelegate <NSObject>
-(void)didDateValueChanged;
-(void)didForverBtnPressed;
@end


@interface UIHMJDatePicker : UIView{
    UIDatePicker *hmjDatePicker;
    UIButton    *foreverBtn;
    
    id<UIHMJDatePickerDelegate> delegate;
}

@property(nonatomic,strong)UIDatePicker *hmjDatePicker;
@property(nonatomic,strong)UIButton    *foreverBtn;

@property(nonatomic,strong)id<UIHMJDatePickerDelegate> delegate;

@end
