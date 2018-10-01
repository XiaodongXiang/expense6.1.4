//
//  XDBillCalDayBtn.m
//  PocketExpense
//
//  Created by 晓东 on 2018/4/9.
//

#import "XDBillCalDayBtn.h"
#import "XDCalendarClass.h"
#import "EP_BillRule.h"
#import "Transaction.h"
#import "EP_BillItem.h"
@interface XDBillCalDayBtn()
{
    UILabel* _dayLbl;
}
@property(nonatomic, strong)UIImageView * selectImageView;

@end
@implementation XDBillCalDayBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dayLbl= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 32)];
        _dayLbl.textAlignment = NSTextAlignmentCenter;
        _dayLbl.font = [UIFont systemFontOfSize:15];
        _dayLbl.backgroundColor = [UIColor clearColor];
        [self addSubview:_dayLbl];
        
       
        
    }
    return self;
}

-(UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"di-1"]];
        _selectImageView.frame = CGRectMake((self.width - 40)/2, 0, 40, 40);
        [self addSubview:_selectImageView];
        [self bringSubviewToFront:_dayLbl];
    }
    return _selectImageView;
}

-(void)setLightColor:(BOOL)lightColor{
    _lightColor = lightColor;
    [self setNeedsDisplay];
}

-(void)setDate:(NSDate *)date{
    _date = date;
    
    _dayLbl.text = [self stringForDate:_date];

}

-(void)setPointColor:(NSString *)pointColor{
    _pointColor = pointColor;
    [self setNeedsDisplay];

}

-(void)drawRect:(CGRect)rect{
    if (self.selected) {
//        UIBezierPath* bezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.width - (self.height - 26))/2, 3, self.height - 26, self.height - 26)];
//
//        [[UIColor colorWithRed:113/255. green:163/255. blue:245/255. alpha:1] set];
//        [bezier fill];
//        [bezier stroke];
        
        _dayLbl.textColor = [UIColor whiteColor];
        self.selectImageView.hidden = NO;
        
    }else{
        self.selectImageView.hidden = YES;
        
        if ([self.date compare:[[XDCalendarClass shareCalendarClass] getCurrentDayInitDay]] == NSOrderedSame) {
            _dayLbl.textColor = [UIColor colorWithRed:113/255. green:163/255. blue:245/255. alpha:1];
        }else{
            if (_lightColor) {
                _dayLbl.textColor = [UIColor lightGrayColor];
            }else{
                _dayLbl.textColor = [UIColor blackColor];
            }
        }
    }
    
    if (_pointColor) {
        UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(SCREEN_WIDTH/7/2-3,35,6,6)];

        if ([_pointColor isEqualToString:@"red"]) {
            [RGBColor(240, 106, 68) set];
        }else if([_pointColor isEqualToString:@"green"]){
            [RGBColor(19, 200, 48) set];
        }else{
            [RGBColor(200, 200, 200) set];
        }
        [path fill];

    }
}

-(void)setHighlighted:(BOOL)highlighted{};

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];

//    [self setNeedsDisplay];
}

-(void)checkExitData{
//    NSArray* array = [[XDDataManager shareManager]getObjectsFromTable:@"EP_BillRule" predicate:[NSPredicate predicateWithFormat:@"state = %@",@"1"] sortDescriptors:nil];
    
    
    
}


-(NSString*)stringForDate:(NSDate*)date{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"d"];
    return [dateFormatter stringFromDate:date];
}

@end
