//
//  HMJPickerView.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-10.
//
//

#import "HMJPickerView.h"
#import "ipad_TranscactionQuickEditViewController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#define HMJDatePickerHigh 260
#define HMJDatePickerOriginY 44

@implementation HMJPickerView
@synthesize hmjPicker, addNewBtn,delegate;


- (id)init
{
    self = [super init];
    if (self) {
        if (isPad) {
            self.backgroundColor = [UIColor whiteColor];
            CGFloat screenHeight = 620;
            CGFloat screenWith = 540;
            CGFloat pickerHigh = 216;
            self.frame = CGRectMake(0, screenHeight-HMJDatePickerHigh, screenWith, 260);
            
            
            hmjPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, HMJDatePickerOriginY, screenWith, pickerHigh)];
            [self addSubview:hmjPicker];
            
            UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWith, 44)];
            headerImage.image = [UIImage imageNamed:@"keyboard_background.png"];
            [self addSubview:headerImage];
            
            addNewBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWith-70, 5,73, 30)];
            addNewBtn.backgroundColor = [UIColor clearColor];
            [addNewBtn setImage:[UIImage imageNamed:@"none.png"] forState:UIControlStateNormal];
            [addNewBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:addNewBtn];
            self.clipsToBounds = YES;
        }
        else
        {
            self.backgroundColor = [UIColor whiteColor];
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height-20;
            CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
            CGFloat pickerHigh = 216;

            self.frame = CGRectMake(0, screenHeight-HMJDatePickerHigh, screenWith, pickerHigh);
            
            
            hmjPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, HMJDatePickerOriginY, screenWith, pickerHigh)];
            hmjPicker.backgroundColor = [UIColor whiteColor];
            [self addSubview:hmjPicker];
            
            UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWith, 44)];
            headerImage.image = [UIImage imageNamed:@"keyboard_background.png"];
            [self addSubview:headerImage];
            
            addNewBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWith-48, 5,48, 30)];
            addNewBtn.backgroundColor = [UIColor clearColor];
            [addNewBtn setImage:[UIImage imageNamed:@"none.png"] forState:UIControlStateNormal];
            
            [addNewBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:addNewBtn];
            
            
            self.backgroundColor = [UIColor clearColor];
            self.clipsToBounds = YES;
        }
        
    }
    return self;
}

-(void)addBtnPressed:(id)sender{
    [self.delegate toolBtnPressed];
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
