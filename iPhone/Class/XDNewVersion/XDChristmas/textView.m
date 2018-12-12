//
//  textView.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/12.
//

#import "textView.h"
#import "XDPlanControlClass.h"

@interface textView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pick1;
@property (weak, nonatomic) IBOutlet UIPickerView *pick2;
@property (weak, nonatomic) IBOutlet UIPickerView *pick3;

@end
@implementation textView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.pick1.delegate = self;
    self.pick1.dataSource = self;
    
    self.pick2.delegate = self;
    self.pick2.dataSource = self;
    
    self.pick3.delegate = self;
    self.pick3.dataSource = self;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.pick1) {
        return 2;
    }else if(pickerView ==self .pick2){
        return 2;
    }else{
        return 4;
    }
    return 2;
}


//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.pick1) {
        if (row == 0) {
            return @"A";
        }else{
            return @"a";
        }
    }else if(pickerView == self.pick2){
        if (row == 0) {
            return @"B";
        }else{
            return @"b";
        }
    }else{
        if (row == 0) {
            return @"1";
        }else if(row == 1){
            return @"2";
        }else if(row == 2){
            return @"3";
        }else if(row == 3){
            return @"4";
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.pick1) {
        [XDPlanControlClass shareControlClass].planType = row;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshChristmas" object:nil];
    }
    if (pickerView == self.pick2) {
        [XDPlanControlClass shareControlClass].planSubType = row;
    }
    if (pickerView == self.pick3) {
        [XDPlanControlClass shareControlClass].planCategory = row;
    }
    
    
}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    //可以通过自定义label达到自定义pickerview展示数据的方式
//    UILabel* pickerLabel = (UILabel*)view;
//    
//    if (!pickerLabel)
//    {
//        pickerLabel = [[UILabel alloc] init];
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
//        pickerLabel.textAlignment = NSTextAlignmentCenter;
//        [pickerLabel setBackgroundColor:[UIColor blackColor]];
//        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
//    }
//    
//    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];//调用上一个委托方法，获得要展示的title
//    return pickerLabel;
//}


@end
