//
//  XDBillCalCollectionViewCell.m
//  PocketExpense
//
//  Created by 晓东 on 2018/4/9.
//

#import "XDBillCalCollectionViewCell.h"
#import "XDBillCalDayBtn.h"
#import "XDCalendarClass.h"
#import "AppDelegate_iPhone.h"
#import "BillFather.h"
#import "EP_BillRule.h"
#import "EP_BillItem.h"

@interface XDBillCalCollectionViewCell()
{
    NSDate* _nextMonth;
    NSMutableDictionary* _muDic;
    
}

@end

@implementation XDBillCalCollectionViewCell

-(void)setDataMuArr:(NSMutableArray *)dataMuArr{
    _dataMuArr = dataMuArr;
    AppDelegate_iPhone *appdelegateiphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    for (int i = 0; i < _muDic.count; i++) {
        NSDate* date = _model.allDaysInMonthArr[i];
        XDBillCalDayBtn* btn = _muDic[[NSString stringWithFormat:@"%d",i]];
        btn.date = date;
        
        for (int j = 0; j < dataMuArr.count; j++) {
            BillFather *billfather = [dataMuArr objectAtIndex:j];
            
            if ([appdelegateiphone.epnc dateCompare:[date initDate] withDate:billfather.bf_billDueDate]==0){

                btn.pointColor = [self getDataSource:billfather date:date];
                
                break;
            }else{
                btn.pointColor = nil;
            }
        }
    }
}


-(NSString*)getDataSource:(BillFather*)billFather date:(NSDate*)date{
    
    NSMutableArray* dataMuArr = [NSMutableArray array];
    double paymentAmount = 0.00;
    NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
    if ([billFather.bf_billRecurringType isEqualToString:@"Never"]) {
        [paymentArray setArray:[billFather.bf_billRule.billRuleHasTransaction allObjects]];
    }else{
        [paymentArray setArray:[billFather.bf_billItem.billItemHasTransaction allObjects]];
    }
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"dateTime" ascending:NO];
    
    NSArray *sortedArray = [paymentArray sortedArrayUsingDescriptors:[[NSArray alloc]initWithObjects:sort, nil]];
    
    
    [paymentArray setArray:sortedArray];
    if ([paymentArray count]>0) {
        for (int i=0; i<[paymentArray count]; i++) {
            Transaction *oneTrans = [paymentArray objectAtIndex:i];
            if ([oneTrans.state isEqualToString:@"1"]) {
                [dataMuArr addObject:oneTrans];
            }
        }
    }
    for (int i=0; i<[dataMuArr count]; i++) {
        Transaction *payment = [dataMuArr objectAtIndex:i];
        paymentAmount += [payment.amount doubleValue];
    }
    double unpaidAmount = 0;
    if (billFather.bf_billAmount > paymentAmount) {
        unpaidAmount = billFather.bf_billAmount - paymentAmount;
    }
    
    if ([[date initDate] compare:[[NSDate date]initDate]] == NSOrderedAscending) {
        
        if (unpaidAmount == 0) {
            return @"green";
        }else{
            return @"red";
        }
    }else{
        return @"light";
    }
    
   
    return nil;
    
}

-(void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    
    [self setupSelectedBtnWithDate];
}

- (void)setModel:(XDCalendarModel *)model{
    _model = model;
    
    [self setupCalendarModel];
 
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _muDic = [NSMutableDictionary dictionary];
        
        [self initWithCalendarDay];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


-(void)initWithCalendarDay{
    
    for (UIView* view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/7;
    CGFloat height = 53;
    
    for (int i = 0; i < 42; i++) {
        
        CGFloat x = i % 7;
        CGFloat y = i / 7;
        
        XDBillCalDayBtn* btn = [[XDBillCalDayBtn alloc]initWithFrame:CGRectMake(x * width, y*height, width, height)];
        btn.tag = i;
        [_muDic setObject:btn forKey:[NSString stringWithFormat:@"%d",i]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:btn];
    }
}

-(void)setupSelectedBtnWithDate{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    for (XDBillCalDayBtn* btn in self.contentView.subviews) {
        
        btn.selected = NO;
        
        if ([_selectedDate compare:btn.date] == NSOrderedSame && _selectedDate) {
            
            btn.selected = YES;
           
        }
    }
}


-(void)setupCalendarModel{
    
    NSDate* currentMonth = _model.calendarMonth;
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [GMTCalendar() components:dayInfoUnits fromDate:currentMonth];
    components.month += 1;
    NSDate* nextMonthDate = [GMTCalendar() dateFromComponents:components];
    _nextMonth = nextMonthDate;
    
    for (int i = 0; i < _muDic.count; i++) {
        NSDate* date = _model.allDaysInMonthArr[i];
        
        XDBillCalDayBtn* btn = _muDic[[NSString stringWithFormat:@"%d",i]];
        
        btn.date = date;
        
        if ([date compare:currentMonth] == NSOrderedAscending || [date compare:nextMonthDate] == NSOrderedDescending || [date compare:nextMonthDate] == NSOrderedSame) {
            btn.lightColor = YES;
        }else{
            btn.lightColor = NO;
        }
    }
}



-(void)btnClick:(XDBillCalDayBtn*)btn{

    for (UIButton* button in self.contentView.subviews) {
        button.selected = NO;
    }
    
    btn.selected = YES;
    
   
    if ([btn.date compare:_model.calendarMonth] == NSOrderedAscending || [btn.date compare:_nextMonth] == NSOrderedDescending || [btn.date compare:_nextMonth] == NSOrderedSame) {
        
        if ([self.xxdDelegate respondsToSelector:@selector(returnOtherMonth:)]) {
            [self.xxdDelegate returnOtherMonth:btn.date];
        }
    }
    
    if ([self.xxdDelegate respondsToSelector:@selector(returnSelectDate:)]) {
        [self.xxdDelegate returnSelectDate:btn.date];
    }
    
}

@end
