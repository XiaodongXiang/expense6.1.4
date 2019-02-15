//
//  numberKeyboardView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/5.
//

#import "numberKeyboardView.h"

typedef enum : NSUInteger {
    btnWithEqual = 16,
    btnWithUnable = 18,
    btnWithComplete = 19,
} btnType;


@interface numberKeyboardView()
@property (weak, nonatomic) IBOutlet UIButton *equalBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@property(nonatomic, copy)NSString* amount;
@property(nonatomic, assign)BOOL hasPoint;
@property(nonatomic, assign)BOOL zeroStart;

@property(nonatomic, assign)BOOL stopInput;
@property(nonatomic, assign)double allAmount;

@property(nonatomic, assign)NSInteger lastOperator;
@property(nonatomic, assign)BOOL isMinus;



@end
@implementation numberKeyboardView

-(void)setNeedCaculate:(BOOL)needCaculate{
    if (needCaculate) {
        [self btnClick:self.equalBtn];
    }
}

-(void)setReset:(BOOL)reset{
    if (reset) {
        [self btnClick: self.resetBtn];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.amount = @"";
        [self addObserver:self forKeyPath:@"amount" options:NSKeyValueObservingOptionNew context:nil];
       
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, self.height+0.5, SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
    }
    return self;
}

-(void)setOldAmountString:(NSString *)oldAmountString{
    _oldAmountString = oldAmountString;
    
    self.equalBtn.tag = 19;
    [self.equalBtn setBackgroundImage:[UIImage imageNamed:@"duigou"] forState:UIControlStateNormal];
    if ([oldAmountString containsString:@"."]) {
        self.hasPoint = YES;
    }
    self.amount = oldAmountString;
    [self.amount stringByAppendingString:oldAmountString];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"amount"]) {
        NSString* str = change[@"new"];
        
//        NSLog(@"allAmount = %@",str);
        if (str && [str hasSuffix:@"0"] && str.length < 2) {
//            self.zeroStart = YES;
        }else{
//            self.zeroStart = NO;
        }
        if ([str containsString:@"."]) {
            self.hasPoint = YES;
        }else{
            self.hasPoint = NO;
        }
        if (str.length < 14) {
            NSInteger index = [[[str componentsSeparatedByString:@"."]lastObject] length];
            if (self.hasPoint && index>=2) {
                self.stopInput = YES;
            }else{
                self.stopInput = NO;
            }
        }else{
            self.stopInput = YES;
        }
    }
}

- (IBAction)btnClick:(id)sender {
    UIButton* btn = (id)sender;
    
    switch (btn.tag) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
            if (self.stopInput || self.zeroStart) {
                return;
            }
            
            if (self.lastOperator == 0) {
                self.equalBtn.tag = 19;
                [self.equalBtn setBackgroundImage:[UIImage imageNamed:@"duigou"] forState:UIControlStateNormal];

            }
            
            if (self.lastOperator == 16) {
                self.amount = @"";
                self.hasPoint = NO;
                self.stopInput = NO;
                self.allAmount = 0.0;
                self.lastOperator = 0;
                self.isMinus = NO;
                self.zeroStart = NO;                
            }
            
            if (self.amount == nil && self.isMinus != YES) {
                self.amount = [NSString stringWithFormat:@"%ld",(long)btn.tag];
            }else{
                self.amount = [self.amount stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
            }
            self.amountBlock([NSString stringWithFormat:@"%@",self.amount]);
            break;
        case 10:
            if (self.lastOperator == 16) {
                self.amount = @"";
                self.hasPoint = NO;
                self.stopInput = NO;
                self.allAmount = 0.0;
                self.lastOperator = 0;
                self.isMinus = NO;
                self.zeroStart = NO;
            }
            
            if (!self.hasPoint) {
                self.amount = [self.amount stringByAppendingString:@"."];
                self.amountBlock([NSString stringWithFormat:@"%@",self.amount]);
            }
            self.hasPoint = YES;
            break;
        case 11:
            self.amount = @"";
            self.hasPoint = NO;
            self.stopInput = NO;
            self.allAmount = 0.0;
            self.amountBlock([NSString stringWithFormat:@""]);
            self.lastOperator = 0;
            self.isMinus = NO;
            self.zeroStart = NO;
            self.equalBtn.tag = 18;
            [self.equalBtn setBackgroundImage:[UIImage imageNamed:@"duigou_press"] forState:UIControlStateNormal];
            break;
        case 12:
        {
            [self func:12];
        }
            break;
        case 13:
        {
            [self func:13];
        }
            break;
        case 14:
        {
            if (([self.amount isEqualToString:@""] || [self.amount isEqualToString:@"0.00"]) && self.allAmount == 0) {
                self.isMinus = !self.isMinus;
                self.amount = @"-";
                self.amountBlock(self.amount);
            }else{
                [self func:14];
            }
        }
            break;
        case 15:
        {
            [self func:15];
        }
            break;
        case 16:
        {
            if (self.lastOperator != 0 && self.allAmount != 0) {
                [self func:self.lastOperator];
                self.lastOperator = 16;
                
                self.equalBtn.tag = 19;
                [self.equalBtn setBackgroundImage:[UIImage imageNamed:@"duigou"] forState:UIControlStateNormal];
            }
        }
            break;
        case 17:
        {
            if (self.amount.length >= 1) {
                if ([[self.amount substringFromIndex:self.amount.length - 1]isEqualToString:@"."]) {
                    self.hasPoint = NO;
                }
                self.amount = [self.amount substringToIndex:self.amount.length - 1];
                self.amountBlock(self.amount);
            }else{
                if (self.allAmount == 0) {
                    return;
                }
                NSString* string = [NSString stringWithFormat:@"%.2f",self.allAmount];
                string = [string substringToIndex:string.length - 1];
                self.amount = string;
                self.allAmount = 0;
                self.amountBlock(string);
                self.lastOperator = 0;

            }
            
        }
            break;
        case 18:
            
            break;
        case 19:
            self.completed();
            
            break;
        default:
            break;
    }
    
}

-(void)func:(NSInteger)intger{
    if ([self.amount isEqualToString: @""] && (self.lastOperator == intger || self.lastOperator == 0)) {
        return;
    }
    self.equalBtn.tag = 16;
    [self.equalBtn setBackgroundImage:[UIImage imageNamed:@"="] forState:UIControlStateNormal];
    double num =[self.amount doubleValue];
 
    if (self.allAmount == 0) {
        self.allAmount = num;
    }else{
        if (self.lastOperator == 12) {
            if (![self.amount isEqualToString:@""]) {
                self.allAmount /= num;
            }
        }else if (self.lastOperator == 13){
            if (![self.amount isEqualToString:@""]) {
                self.allAmount *= num;
            }
        }else if (self.lastOperator == 14){
            self.allAmount -= num;
        }else if (self.lastOperator == 15){
            self.allAmount += num;
        }
    }
    self.lastOperator = intger;
    
    self.amountBlock([NSString stringWithFormat:@"%.2f",self.allAmount]);
    self.hasPoint = NO;
    self.stopInput = NO;
    self.amount = @"";
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"amount"];

}

@end
