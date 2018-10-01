//
//  HMJPickerView.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-10.
//
//

#import <UIKit/UIKit.h>

@protocol HMJPickerViewDelegate <NSObject>

-(void)toolBtnPressed;

@end

@interface HMJPickerView : UIView{
    UIPickerView *hmjPicker;
    UIButton    *addNewBtn;
    id<HMJPickerViewDelegate> delegate;
}

@property(nonatomic,strong)UIPickerView *hmjPicker;
@property(nonatomic,strong)UIButton    *addNewBtn;
@property(nonatomic,strong)id<HMJPickerViewDelegate> delegate;


@end
