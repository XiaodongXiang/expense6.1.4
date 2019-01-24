//
//  XDDateSelectedView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/22.
//

#import "XDDateSelectedView.h"

@interface XDDateSelectedView()<UIScrollViewDelegate>
@end
@implementation XDDateSelectedView
@synthesize type;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 24)];
        self.scrollView.delegate = self;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.scrollEnabled = NO;
        
        [self addSubview:self.scrollView];
        
        CAShapeLayer* layer = [CAShapeLayer layer];
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 24)];
        [path addLineToPoint:CGPointMake(self.width/2 - 5, 24)];
        [path addLineToPoint:CGPointMake(self.width/2, 20)];
        [path addLineToPoint:CGPointMake(self.width/2 + 5, 24)];
        [path addLineToPoint:CGPointMake(SCREEN_WIDTH, 24)];
        
        layer.path = path.CGPath;
        layer.borderColor = RGBColor(229, 229, 229).CGColor;
        layer.borderWidth = 0.5;
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.strokeColor = RGBColor(229, 229, 229).CGColor;

        [self.layer addSublayer:layer];
        
    }
    return self;
}


-(void)setDateArr:(NSArray *)dateArr{
    _dateArr = dateArr;
    
    if (type == DateSelectedCustom) {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH / 3, 0);
    }else{
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH / 3 * dateArr.count, 0);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupDateLabel];
    });
}

-(void)setupDateLabel{
    for (UIView* view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat width = SCREEN_WIDTH / 3;

    
    if (type == DateSelectedCustom) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(-width/2, 0, width*2, 20)];

        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithFormat:@"%@ - %@",[self timeFormatter:self.dateArr.firstObject],[self timeFormatter:self.dateArr.lastObject]];
        
        label.font = [UIFont fontWithName:FontSFUITextMedium size:12];
        label.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:label];
    }else{
        for (int i = 0; i < self.dateArr.count; i++) {
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(width * i, 0, width, 20)];
            label.tag = i;

            if (type == DateSelectedWeek) {
                label.text = [self coverDateToString:self.dateArr[i]];
            }else if(type == DateSelectedMonth){
                label.text = [NSString stringWithFormat:@"%@",[self monthFormatter:self.dateArr[i]]];
            }else if(type == DateSelectedYear){
                label.text = [NSString stringWithFormat:@"%@",[self yearFormatter:self.dateArr[i]]];
            }
            
            label.textColor = [UIColor grayColor];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            label.textAlignment = NSTextAlignmentCenter;
            [self.scrollView addSubview:label];

        }
    }

}

-(NSString*)coverDateToString:(NSMutableArray*)muArr{
    NSDate* firstDate = [muArr firstObject];
    NSDate* lastDate = [muArr lastObject];
    
    NSString* string = [NSString stringWithFormat:@"%@-%@",[self dateformatter:firstDate],[self dateformatter:lastDate]];
    return string;
}

-(NSString*)dateformatter:(NSDate*)date{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"LLL d"];
    return [format stringFromDate:date];
}

-(NSString*)monthFormatter:(NSDate*)date{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"LLL yyyy"];
    return [format stringFromDate:date];
}

-(NSString*)yearFormatter:(NSDate*)date{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy"];
    return [format stringFromDate:date];
}

-(NSString*)timeFormatter:(NSDate*)date{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"LLL d, yyyy"];
    return [format stringFromDate:date];
}

#pragma mark---修改hitTest方法
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *view = [super hitTest:point withEvent:event];
//    if ([view isEqual:self]){
//        for (UIView *subview in self.scrollView.subviews){
//            CGPoint offset = CGPointMake(point.x - self.scrollView.frame.origin.x + self.scrollView.contentOffset.x - subview.frame.origin.x, point.y - self.scrollView.frame.origin.y + self.scrollView.contentOffset.y - subview.frame.origin.y);
//            
//            if ((view = [subview hitTest:offset withEvent:event])){
//                return view;
//            }
//        }
//        return self.scrollView;
//    }
//    return view;
//}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH * 3;
//    if ([self.dateDelegate respondsToSelector:@selector(returnSelectedDate:index:)]) {
//        [self.dateDelegate returnSelectedDate:self.dateArr[index] index:index];
//    }
//}

//-(void)drawRect:(CGRect)rect{
//    
//    UIBezierPath* path =[UIBezierPath bezierPath];
//    path.lineWidth = [UIScreen mainScreen].scale/1;
//    [path moveToPoint:CGPointMake(0, self.height)];
//    [path addLineToPoint:CGPointMake(self.width/2-5, self.height)];
//    [path addLineToPoint:CGPointMake(self.width/2, self.height-3)];
//    [path addLineToPoint:CGPointMake(self.width/2+5, self.height)];
//    [path addLineToPoint:CGPointMake(self.width, self.height)];
//    [path stroke];
//
//
//    
//}



@end
