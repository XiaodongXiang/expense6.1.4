//
//  UIHMJDatePicker.m
//  UIDatePickerTest
//
//  Created by APPXY_DEV on 13-8-7.
//  Copyright (c) 2013年 APPXY_DEV. All rights reserved.
//

#import "UIHMJDatePicker.h"
#import "ipad_BillEditViewController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define HMJDatePickerHigh 260
#define HMJDatePickerOriginY 44

@implementation UIHMJDatePicker
@synthesize hmjDatePicker,foreverBtn,delegate;

//默认的hidden是yes的
- (id)init
{
    self = [super init];
    if (self) {
        
        //iPad
        if ([UIScreen mainScreen].bounds.size.width>320) {
            CGFloat screenHeigh = 620;
            CGFloat screenWith = 540;
            
            self.frame = CGRectMake(0, screenHeigh-44-HMJDatePickerHigh, screenWith, HMJDatePickerHigh);
            hmjDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, HMJDatePickerOriginY, screenWith, 216)];

        }
        else
        {
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height-20;
            CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
            
            self.frame = CGRectMake(0, screenHeight-44-HMJDatePickerHigh, screenWith, HMJDatePickerHigh);
            hmjDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, HMJDatePickerOriginY, screenWith, 216)];

        }
            
        
        CGFloat screenWith = 540;

        hmjDatePicker.backgroundColor = [UIColor whiteColor];
        hmjDatePicker.datePickerMode = UIDatePickerModeDate;
        [hmjDatePicker addTarget:self action:@selector(hmjDatePickerChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:hmjDatePicker];
        
        UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWith, 44)];
        headerImage.image = [UIImage imageNamed:@"keyboard_background.png"];
        [self addSubview:headerImage];
        
        foreverBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 7,self.frame.size.width-30, 29)];
        foreverBtn.backgroundColor = [UIColor clearColor];
        [foreverBtn setTitle:NSLocalizedString(@"VC_Forever", nil) forState:UIControlStateNormal];
        [foreverBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [foreverBtn setTitleColor:[UIColor colorWithRed:90.f/255.f green:121.f/255.f blue:169.f/255.f alpha:1] forState:UIControlStateNormal];
        [foreverBtn addTarget:self action:@selector(forverBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:foreverBtn];
        
    }
    return self;
}

-(void)hmjDatePickerChanged{
    [self.delegate didDateValueChanged];
}

-(void)forverBtnPressed{
    [self.delegate didForverBtnPressed];
}
-(void)sethmjDatePickerHidden:(BOOL)hidden{
    self.hidden = YES;
//    if (hidden && !isHidden) {
//        [self hideHMJDatePicker];
//        isHidden = YES;
//    }
//    else if (!hidden && isHidden){
//        [self showhmjDatePicker];
//        isHidden = NO;
//    }
}
-(void)hideHMJDatePicker{

    self.hidden = YES;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
//    [UIView commitAnimations];

}

- (void)showhmjDatePicker {
    
    self.hidden = NO;
//    if (self.billEditViewControllere.bevc_duedate != nil) {
//        [hmjDatePicker setDate:self.billEditViewControllere.bevc_duedate animated:YES];
//
//    }
//    else
//        [hmjDatePicker setDate:[NSDate date] animated:YES];
//
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.3];
//         self.frame = CGRectMake(0, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
//        [UIView commitAnimations];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
