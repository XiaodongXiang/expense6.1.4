//
//  XDDayButton.m
//  calendar
//
//  Created by 晓东 on 2018/1/2.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import "XDDayButton.h"
#import "XDCalendarClass.h"
#import "Transaction.h"
#import "Category.h"
@interface XDDayButton()
{
    double incomeAmount;
    double expenseAmount;
    NSArray* _array;
}
@property(nonatomic, strong)UIView * coverView;
@property(nonatomic, assign)BOOL select;
@property(nonatomic, strong)UIImageView * selectImageView;



@end
@implementation XDDayButton

-(void)setDate:(NSDate *)date{
        _date = date;
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"d"];
        self.dayLbl.text = [dateFormatter stringFromDate:date];
        
        if (self.select) {
            self.dayLbl.textColor = [UIColor whiteColor];
        }else{
            if ([date compare:[[XDCalendarClass shareCalendarClass] getCurrentDayInitDay]] == NSOrderedSame) {
                self.dayLbl.textColor = [UIColor colorWithRed:113/255. green:163/255. blue:245/255. alpha:1];
            }else{
                self.dayLbl.textColor = [UIColor blackColor];
            }
        }
    
        incomeAmount = 0;
        expenseAmount = 0;
        
        NSArray* array = [[XDDataManager shareManager] getTransactionDate:date withAccount:nil];
        _array = array;
    
        if (array.count > 0) {
            
            for (int i = 0; i<array.count; i++) {
                Transaction* transaction = array[i];
                
                if (transaction.parTransaction == nil) {
                    if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
                        
                        if (transaction.expenseAccount && transaction.incomeAccount && [transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                            expenseAmount += [transaction.amount doubleValue];
                        }else{
                            incomeAmount += [transaction.amount doubleValue];
                        }
                        
                    }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
                        expenseAmount += [transaction.amount doubleValue];
                    }
                }
            }
            
            if (incomeAmount > 0) {
                self.incomeLbl.text = [NSString stringWithFormat:@"%.0f",incomeAmount];
                self.incomeLbl.hidden = NO;
            }else{
                self.incomeLbl.hidden = YES;
                self.incomeLbl.text = @"";
            }
            
            if (expenseAmount > 0) {
                self.expenseLbl.text = [NSString stringWithFormat:@"%.0f",expenseAmount];
                self.expenseLbl.hidden = NO;
            }else{
                self.expenseLbl.hidden = YES;
                self.expenseLbl.text = @"";
            }
        }else{
            self.expenseLbl.hidden = YES;
            self.incomeLbl.hidden = YES;
            self.expenseLbl.text = @"";
            self.incomeLbl.text = @"";
        }
    
    
    
}

-(UIView *)coverView{
    if (!_coverView) {
        
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _coverView.backgroundColor = [UIColor whiteColor];
        _coverView.alpha = 0.7;
        _coverView.userInteractionEnabled = YES;
        [self addSubview:_coverView];
        _coverView.hidden = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverClick)];
        [_coverView addGestureRecognizer:tap];
        
    }
    return _coverView;
}

-(void)setShowCover:(BOOL)showCover{
    if (showCover) {
        self.coverView.hidden = NO;
    }else{
        self.coverView.hidden = YES;
    }
}


-(void)setHighlighted:(BOOL)highlighted{}

-(UILabel *)dayLbl{
    if (!_dayLbl) {
        _dayLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 32)];
        _dayLbl.textAlignment = NSTextAlignmentCenter;
        _dayLbl.font = [UIFont fontWithName:FontSFUITextRegular size:15];
        _dayLbl.backgroundColor = [UIColor clearColor];
    }
    
    return _dayLbl;
}

-(UILabel *)expenseLbl{
    if (!_expenseLbl) {
        _expenseLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 29, self.bounds.size.width, 11)];
        _expenseLbl.textAlignment = NSTextAlignmentCenter;
        _expenseLbl.textColor = RGBColor(240, 106, 68);
        _expenseLbl.font = [UIFont fontWithName:FontSFUITextRegular size:9];
    }
    return _expenseLbl;
}

-(UILabel *)incomeLbl{
    if (!_incomeLbl) {
        
        _incomeLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.bounds.size.width, 11)];
        _incomeLbl.textAlignment = NSTextAlignmentCenter;
        _incomeLbl.textColor = RGBColor(19, 200, 48);
        _incomeLbl.font = [UIFont fontWithName:FontSFUITextRegular size:9];
    }
    return _incomeLbl;
}

-(UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"di-1"]];
        _selectImageView.frame = CGRectMake((self.width - 40)/2, 0, 40, 40);
        [self addSubview:_selectImageView];
        [self bringSubviewToFront:self.dayLbl];
        [self bringSubviewToFront:self.coverView];
    }
    return _selectImageView;
}

-(void)setSelected:(BOOL)selected{
    if (selected) {
        self.select = YES;
        self.incomeLbl.hidden = YES;
        self.expenseLbl.hidden = YES;
    }else{
        self.select = NO;
        self.incomeLbl.hidden = NO;
        self.expenseLbl.hidden = NO;
      
    }
    [self setNeedsDisplay];

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.expenseLbl];
        [self addSubview:self.incomeLbl];
        [self addSubview:self.dayLbl];
        
       [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)btnClick:(XDDayButton*)btn{
    if ([self.delegate respondsToSelector:@selector(returnButtonSelected:)]) {
        [self.delegate returnButtonSelected:btn];
    }
    if (expenseAmount > 0 || incomeAmount > 0 || _array.count > 0){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectedDateHasData" object:@YES];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectedDateHasData" object:@NO];
    }
}

-(void)coverClick{
    if ([self.delegate respondsToSelector:@selector(returnButtonSelected:)]) {
        [self.delegate returnButtonSelected:self];
    }
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);  //图片尺寸
    UIGraphicsBeginImageContext(rect.size); //填充画笔
    CGContextRef context = UIGraphicsGetCurrentContext(); //根据所传颜色绘制
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect); //联系显示区域
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext(); // 得到图片信息
    UIGraphicsEndImageContext(); //消除画笔
    return image;
}


-(void)drawRect:(CGRect)rect{
    if (self.select) {
        self.dayLbl.textColor = [UIColor whiteColor];
        self.selectImageView.hidden = NO;
        
    }else{
        self.selectImageView.hidden = YES;
        if ([self.date compare:[[XDCalendarClass shareCalendarClass] getCurrentDayInitDay]] == NSOrderedSame) {
            self.dayLbl.textColor = [UIColor colorWithRed:113/255. green:163/255. blue:245/255. alpha:1];
        }else{
            self.dayLbl.textColor = RGBColor(85, 85, 85);
        }
    }
}


@end
