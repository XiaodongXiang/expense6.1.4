//
//  XDChartView.m
//  chart
//
//  Created by 晓东 on 2018/1/22.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import "XDChartView.h"
#import "XDChartModel.h"

static CGFloat marginX = 10;
static NSInteger XCount = 4;

@interface XDChartView()
{
    UIColor *_redLineColor ;
    UIColor *_redShadowColor;
    UIColor *_greenLineColor;
    UIColor *_greenShadowColor;
    UIColor *_blueIndicateColor;
    UIColor *_lightLineColor;
    
    UIView* _XLabelView;
    UIView* _YLabelView;
    
    CGFloat marginY;
    
    NSMutableArray* _dateMuArr;
}
@property(nonatomic,strong)UIColor* lineColor;
@property(nonatomic,strong)UIColor* labelColor;
@property(nonatomic, strong)UIColor * shadowColor;
@property(nonatomic, strong)UIColor * chartLineColor;
@property(nonatomic, strong)UIColor * indicateColor;


@property(nonatomic, assign)CGFloat topMargin;
@property(nonatomic, assign)CGFloat yEndMargin;
@property(nonatomic, assign)CGFloat lineHeight;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, assign)CGFloat width;


@property(nonatomic, strong)UIView * verticalLine;
@property(nonatomic, strong)UIView * indicatePoint;
@property(nonatomic, strong)UIView * titleView;
@property(nonatomic, strong)UILabel * moneyLbl;
@property(nonatomic, strong)UILabel * dateLbl;

@property(nonatomic, assign)CGFloat balanceCenterY;

@property(nonatomic, strong)NSMutableArray * yMuArr;
@property(nonatomic, strong)NSMutableArray * xMuArr;
@property(nonatomic, strong)NSMutableArray * dataMuArr;


@end
@implementation XDChartView
@synthesize date,dateStr;
-(void)setDateArray:(NSArray *)dateArray{
    _dateArray = dateArray;
    if (!dateArray) {
        return;
    }
    _dateMuArr = [NSMutableArray array];
   
    
    NSDateComponents *dayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:dateArray.firstObject toDate:dateArray.lastObject options:0];
    NSInteger days = dayComponents.day;
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitMonth;

    if (days <= 31) {

        for (int i = 0; i <= days; i++) {
            NSDateComponents* comp = [[NSCalendar currentCalendar] components:unit fromDate:dateArray.firstObject];
            comp.day += i;
            
            NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
            [_dateMuArr addObject:newDate];
        }
    }else if (days>31 && days <= 210){
        NSInteger weeks = days/7;
        if (days%7>0) {
            weeks +=1;
        }
        
        for (int i = 0; i <= weeks; i++) {
            NSDateComponents* comp = [[NSCalendar currentCalendar] components:unit fromDate:dateArray.firstObject];
            comp.day += i * 7;
            NSDate* weekDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
            [_dateMuArr addObject:weekDate];
        }
    }else if (days>210 && days <= 900){
        NSInteger months = days/30;
        if (days % 30 > 0) {
            months += 1;
        }
        
        for (int i = 0; i <= months; i++) {
            NSDateComponents* dateComp = [[NSCalendar currentCalendar] components:unit fromDate:dateArray.firstObject];
            dateComp.month += i;
            NSDate * sDate = [[NSCalendar currentCalendar] dateFromComponents:dateComp];
            [_dateMuArr addObject:sDate];

        }
    }else{
        NSDateComponents* startComp = [[NSCalendar currentCalendar] components:unit fromDate:dateArray.firstObject];
        NSDateComponents* endComp = [[NSCalendar currentCalendar] components:unit fromDate:dateArray.lastObject];
        
        NSMutableArray* dateMuArr = [NSMutableArray array];
        for (NSInteger i = startComp.year; i <= endComp.year; i++) {
            startComp.year = i;
            NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:startComp];
            [dateMuArr addObject:date];
        }
        
        for (int i = 0 ; i < dateMuArr.count ; i++) {
            NSDate* date = dateMuArr[i];
            NSDateComponents* dateComp = [[NSCalendar currentCalendar]components:unit fromDate:date];
            dateComp.day = 1;
            dateComp.month = 1;
            NSDate* startDate = [[NSCalendar currentCalendar] dateFromComponents:dateComp];
            [_dateMuArr addObject:startDate];

        }
    }
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (IS_IPHONE_5) {
            marginY = 40;
            self.topMargin = 45;

        }else{
            marginY = 55;
            self.topMargin = 50;

        }
//        self.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:0.95 alpha:0.9];
        self.backgroundColor = [UIColor whiteColor];
        self.lineColor = [UIColor colorWithRed:.08 green:.08 blue:.08 alpha:.1];
        self.labelColor = [UIColor lightGrayColor];
        
        self.yEndMargin = 20;
        self.lineHeight = (frame.size.height - marginY - self.topMargin)/XCount;
        self.height = frame.size.height;
        self.width = frame.size.width;
        self.indicatePoint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
        self.balanceCenterY = self.topMargin + 2 * self.lineHeight;
        
        _redLineColor =  [UIColor colorWithRed:255/255.0f green:175/255.0f blue:152/255.0f alpha:1.f];
        _redShadowColor = [UIColor colorWithRed:255/255.0f green:80/255.0f blue:30/255.0f alpha:0.1f];
        _greenLineColor = [UIColor colorWithRed:63/255.0f green:223/255.0f blue:145/255.0f alpha:0.8f];
        _greenShadowColor = [UIColor colorWithRed:63/255.0f green:223/255.0f blue:145/255.0f alpha:0.1f];
        _blueIndicateColor = [UIColor colorWithRed:113/255. green:163/255. blue:245/255. alpha:0.8];
        _lightLineColor = RGBColor(113, 165, 245);
        
        _YLabelView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, self.height)];
        _XLabelView  = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - marginY , self.width, 20)];
        
        _XLabelView.backgroundColor = _YLabelView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_XLabelView];
        [self addSubview:_YLabelView];

        UILongPressGestureRecognizer* longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGestureRecognizerHandle:)];
        longGes.minimumPressDuration = 0.1f;
        [self addGestureRecognizer:longGes];
        
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
        [self addGestureRecognizer:tapGes];
       
        
    }
    return self;
}


-(void)setChartType:(ChartType)chartType{
    _chartType = chartType;
    if (chartType == ExpenseChart) {
        self.chartLineColor = _redLineColor;
        self.shadowColor = _redShadowColor;
        self.indicateColor = [UIColor redColor];
    }else if(chartType == IncomeChart){
        self.chartLineColor = _greenLineColor;
        self.shadowColor = _greenShadowColor;
        self.indicateColor = [UIColor greenColor];
    }else{
        self.indicateColor = _blueIndicateColor;
    }
    [self setNeedsDisplay];
    
    self.verticalLine.hidden = YES;
    self.indicatePoint.hidden = YES;
    self.titleView.hidden = YES;
    
    [self setupIndicatePoint];
}



-(UILabel *)moneyLbl{
    if (!_moneyLbl) {
        
        _moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, 96, 20)];
        _moneyLbl.textColor = [UIColor whiteColor];
        _moneyLbl.font = [UIFont fontWithName:FontSFUITextMedium size:12];
        _moneyLbl.textAlignment = NSTextAlignmentCenter;
        _moneyLbl.minimumScaleFactor = 0.5;
        _moneyLbl.adjustsFontSizeToFitWidth = YES;
        _moneyLbl.backgroundColor = [UIColor clearColor];
    }
    return _moneyLbl;
}

-(UILabel *)dateLbl{
    if (!_dateLbl) {
        
        _dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 17, 96, 14)];
        _dateLbl.textColor = [UIColor whiteColor];
        _dateLbl.font = [UIFont fontWithName:FontSFUITextRegular size:10];
        _dateLbl.textAlignment = NSTextAlignmentCenter;
        _dateLbl.backgroundColor = [UIColor clearColor];
    }
    return  _dateLbl;
}

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 96, 34)];
        _titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
        _titleView.layer.cornerRadius = 5;
        _titleView.layer.masksToBounds = YES;
        [_titleView addSubview:self.moneyLbl];
        [_titleView addSubview:self.dateLbl];
        
        [self addSubview:_titleView];
    }
    return _titleView;
}


-(UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc]init];
        _verticalLine.backgroundColor = RGBColor(85, 85, 85);
        _verticalLine.frame = CGRectMake(0, self.topMargin - 5, 1, self.height - marginY - self.topMargin+5);
        _verticalLine.hidden = YES;
        
        UIImageView* arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sanjiao"]];
        if (IS_IPHONE_5) {
            arrow.frame = CGRectMake(-6, -3, 12, 7);
        }else{
            arrow.frame = CGRectMake(-6, -8, 12, 7);
        }
        
        [_verticalLine addSubview:arrow];
        [self addSubview:_verticalLine];
        [self bringSubviewToFront:_indicatePoint];

    }
    return _verticalLine;
}



-(void)setupIndicatePoint{
        self.indicatePoint.hidden = YES;
        self.indicatePoint.backgroundColor = [UIColor clearColor];
        CAShapeLayer *indicatePointBackLayer = [CAShapeLayer layer];
        indicatePointBackLayer.frame = CGRectMake(0.0f, 0.0f, 12.0f, 12.0f);
        indicatePointBackLayer.fillColor= self.indicateColor.CGColor;
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(6.0f, 6.0f) radius:6.0f startAngle:0.0f endAngle:M_PI *2.0f clockwise:YES];
        indicatePointBackLayer.path = path1.CGPath;
        [self.indicatePoint.layer addSublayer:indicatePointBackLayer];
        
        CAShapeLayer *indicatePointLayer = [CAShapeLayer layer];
        indicatePointLayer.frame = CGRectMake(0.0f, 0.0f, 6.0f, 6.0f);
        indicatePointLayer.fillColor= [UIColor whiteColor].CGColor;
        UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(6.0f, 6.0f) radius:3.0f startAngle:0.0f endAngle:M_PI *2.0f clockwise:YES];
        indicatePointLayer.path = path2.CGPath;
        [self.indicatePoint.layer addSublayer:indicatePointLayer];
        [self addSubview:self.indicatePoint];
}

-(void)setModel:(XDChartModel *)model{
    _model = model;
    
    double value = 0;
    for (NSNumber* number in model.dataMuArr) {
        if ([number doubleValue] != 0) {
            value = [number doubleValue];
        }
    }

    self.dataMuArr = model.dataMuArr;
    self.xMuArr = model.xMuArr;
    self.yMuArr = model.yMuArr;
    
    
    [self drawXLalels];
    [self drawYLabels];
    
    self.verticalLine.hidden = YES;
    self.indicatePoint.hidden = YES;
    self.titleView.hidden = YES;
    
    [self setNeedsDisplay];

    

}

-(void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGest{
    CGPoint point = [tapGest locationInView:self];

    CGFloat margin = (self.width - 2 * marginX) / self.xMuArr.count / 2;
    
    if (self.chartType != BalanceChart) {
        for (int i = 0; i < self.xMuArr.count; i++) {
            NSString* dateStr =[NSString stringWithFormat:@"%@", self.xMuArr[i]];
            double value = [self.dataMuArr[i] doubleValue];
            CGFloat yPoint = [self coverPoint:value];
            UILabel* label = [self viewWithTag:1000+i];
            
            if (point.x >= label.center.x - margin && point.x <= label.center.x + margin) {
                self.verticalLine.hidden = NO;
                self.verticalLine.centerX= label.center.x;
                if (point.x < marginX) {
                    self.verticalLine.centerX= marginX;
                }else if(point.x > self.width - marginX){
                    self.verticalLine.centerX=self.width - marginX;
                }
                
                self.indicatePoint.hidden = NO;
                self.indicatePoint.center = CGPointMake(label.center.x, yPoint);
                
                self.titleView.center = CGPointMake(label.center.x, 20);
                self.titleView.hidden = NO;
                
                if (self.titleView.frame.origin.x <= 3) {
                    self.titleView.center = CGPointMake(51, 20);
                }
                
                if (self.titleView.frame.origin.x +96 >= self.width - 3) {
                    self.titleView.center = CGPointMake(self.width - 51, 20);
                }
                
                self.moneyLbl.text = [XDDataManager moneyFormatter:value];
                if (_dateArray.count>0 && _dateArray) {
                    self.dateLbl.text = [self dateArrayString:_dateMuArr[i]];
                }else{
                    self.dateLbl.text = [self dateString:dateStr];
                }
                
                if (value == 0) {
                    self.verticalLine.hidden = YES;
                    self.indicatePoint.hidden = YES;
                    self.titleView.hidden = YES;
                }
            }
        }
    }else{
        for (int i = 0; i < self.xMuArr.count; i++) {
            NSString* dateStr = [NSString stringWithFormat:@"%@", self.xMuArr[i]];
            double value = [self.dataMuArr[i] doubleValue];
            CGFloat yPoint = [self coverBalancePoint:value];
            UILabel* label = [self viewWithTag:1000+i];
            
            if (point.x >= label.center.x - margin && point.x <= label.center.x + margin) {
                self.verticalLine.hidden = NO;
                self.verticalLine.centerX= label.center.x;
                if (point.x < marginX) {
                    self.verticalLine.centerX = marginX;
                }else if(point.x > self.width - marginX){
                    self.verticalLine.centerX = self.width - marginX;
                }
                
                self.indicatePoint.hidden = NO;
                self.indicatePoint.center = CGPointMake(label.center.x, yPoint);
                
                self.titleView.center = CGPointMake(label.center.x, 20);
                self.titleView.hidden = NO;
                
                if (self.titleView.frame.origin.x <= 3) {
                    self.titleView.center = CGPointMake(51, 20);
                }
                
                if (self.titleView.frame.origin.x +96 >= self.width - 3) {
                    self.titleView.center = CGPointMake(self.width - 51, 20);
                }
                
                self.moneyLbl.text = [XDDataManager moneyFormatter:value];
                if (_dateArray.count>0 && _dateArray) {
                    self.dateLbl.text = [self dateArrayString:_dateMuArr[i]];
                }else{
                    self.dateLbl.text = [self dateString:dateStr];
                }
                if (value == 0) {
                    self.verticalLine.hidden = YES;
                    self.indicatePoint.hidden = YES;
                    self.titleView.hidden = YES;
                }
            }
        }
    }
}

-(void)longGestureRecognizerHandle:(UILongPressGestureRecognizer*)longResture{
    
    CGPoint point = [longResture locationInView:self];
    if (longResture.state == UIGestureRecognizerStateChanged) {
    
        CGFloat margin = (self.width - 2 * marginX) / self.xMuArr.count / 2;
        UILabel* fLabel = [self viewWithTag:1000];
        UILabel* lLabel = [self viewWithTag:1000 + self.xMuArr.count - 1];
        
        if (self.chartType != BalanceChart) {
            for (int i = 0; i < self.xMuArr.count; i++) {
                NSString* dateStr =[NSString stringWithFormat:@"%@", self.xMuArr[i]];
                double value = [self.dataMuArr[i] doubleValue];
                CGFloat yPoint = [self coverPoint:value];
                UILabel* label = [self viewWithTag:1000+i];
                
                if (point.x >= label.center.x - margin && point.x <= label.center.x + margin) {
                    self.verticalLine.hidden = NO;
                    self.verticalLine.centerX= label.center.x;
                    if (point.x < marginX) {
                        self.verticalLine.centerX= fLabel.centerX;
                    }else if(point.x > self.width - marginX){
                        self.verticalLine.centerX=lLabel.centerX;
                    }
                    
                    self.indicatePoint.hidden = NO;
                    self.indicatePoint.center = CGPointMake(label.center.x, yPoint);
                    
                    self.titleView.center = CGPointMake(label.center.x, 20);
                    self.titleView.hidden = NO;
                    
                    if (self.titleView.frame.origin.x <= 3) {
                        self.titleView.center = CGPointMake(51, 20);
                    }
                    
                    if (self.titleView.frame.origin.x +96 >= self.width - 3) {
                        self.titleView.center = CGPointMake(self.width - 51, 20);
                    }
                    
                    self.moneyLbl.text = [XDDataManager moneyFormatter:value];
                    if (_dateArray.count>0 && _dateArray) {
                        self.dateLbl.text = [self dateArrayString:_dateMuArr[i]];
                    }else{
                        self.dateLbl.text = [self dateString:dateStr];
                    }
                }
            }
        }else{
            for (int i = 0; i < self.xMuArr.count; i++) {
                NSString* dateStr = [NSString stringWithFormat:@"%@", self.xMuArr[i]];
                double value = [self.dataMuArr[i] doubleValue];
                CGFloat yPoint = [self coverBalancePoint:value];
                UILabel* label = [self viewWithTag:1000+i];
                
                if (point.x >= label.center.x - margin && point.x <= label.center.x + margin) {
                    self.verticalLine.hidden = NO;
                    self.verticalLine.centerX= label.center.x;
                    if (point.x < marginX) {
                        self.verticalLine.centerX = fLabel.centerX;
                    }else if(point.x > self.width - marginX){
                        self.verticalLine.centerX = lLabel.centerX;
                    }
                    
                    self.indicatePoint.hidden = NO;
                    self.indicatePoint.center = CGPointMake(label.center.x, yPoint);
                    
                    self.titleView.center = CGPointMake(label.center.x, 20);
                    self.titleView.hidden = NO;
                    
                    if (self.titleView.frame.origin.x <= 3) {
                        self.titleView.center = CGPointMake(51, 20);
                    }
                    
                    if (self.titleView.frame.origin.x +96 >= self.width - 3) {
                        self.titleView.center = CGPointMake(self.width - 51, 20);
                    }
                    
                    self.moneyLbl.text = [XDDataManager moneyFormatter:value];
                    if (_dateArray.count>0 && _dateArray) {
                        self.dateLbl.text = [self dateArrayString:_dateMuArr[i]];
                    }else{
                        self.dateLbl.text = [self dateString:dateStr];
                    }
                }
            }
        }
    }else if (UIGestureRecognizerStateEnded){
//        self.verticalLine.hidden = YES;
//        self.indicatePoint.hidden = YES;
//        self.titleView.hidden = YES;
    }
}

-(void)drawXLalels{
    
    for (UIView * view in _XLabelView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat pointX;
    if (self.xMuArr.count > 1) {
       pointX  = (self.width - self.yEndMargin - marginX) / (self.xMuArr.count - 1);
    }
    for (int i = 0; i < self.xMuArr.count; i++) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:10];

        label.tag = i + 1000;
        if (self.xMuArr.count >1) {
            label.center = CGPointMake(marginX + i * pointX, 10);
        }else{
            label.center = CGPointMake((self.width - self.yEndMargin - marginX)/2, 10);
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.labelColor;
        label.text = [NSString stringWithFormat:@"%@",self.xMuArr[i]];
        [label sizeToFit];

        [_XLabelView addSubview:label];
        
        if (self.xMuArr.count > 28) {
            if (i%2 == 0) {
                label.hidden = YES;
            }
        }
    }
}

-(void)drawYLabels{
    for (UIView * view in _YLabelView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < self.yMuArr.count; i++) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 15)];
        label.font = [UIFont systemFontOfSize:10];
        label.center = CGPointMake(20, self.topMargin + i * self.lineHeight);
        label.textColor = self.labelColor;
        label.text = [self getAmountStringWith:[self.yMuArr[i] doubleValue]];
        [label sizeToFit];
        [_YLabelView addSubview:label];
    }
}

-(void)drawDataLine{
    if (self.chartType != BalanceChart) {
        if (self.dataMuArr.count == 1) {
            UIBezierPath * path = [[UIBezierPath alloc]init];
            path.lineWidth = 2;
            path.lineJoinStyle = kCGLineJoinRound;
            
            double value = [self.dataMuArr[0] doubleValue];
            CGFloat yPoint = [self coverPoint:value];
            UILabel* label = [self viewWithTag:1000];
            CGFloat xPoint = label.center.x;
            
            UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(xPoint, yPoint) radius:2 startAngle:0 endAngle:2*M_PI clockwise:YES];
            bezier.lineWidth = 1.5;
            [self.chartLineColor set];
            [bezier stroke];
            [bezier fill];
            
            [path moveToPoint:CGPointMake(marginX, yPoint)];
            [path addLineToPoint:CGPointMake(self.width - 10, yPoint)];
            [path stroke];
            
            UIBezierPath * fillPath = [UIBezierPath bezierPathWithCGPath:path.CGPath];
            
            [fillPath addLineToPoint:CGPointMake(self.width - 10, self.height-marginY)];
            [fillPath addLineToPoint:CGPointMake(marginX, self.height-marginY)];
            [fillPath addLineToPoint:CGPointMake(marginX, [self coverPoint:[self.dataMuArr.firstObject doubleValue]])];
            [self.shadowColor set];
            [fillPath fill];
            
            
        }else{
            UIBezierPath * path = [[UIBezierPath alloc]init];
            path.lineWidth = 2;
            path.lineJoinStyle = kCGLineJoinRound;
            
            for (int i = 0; i < self.dataMuArr.count; i++) {
                double value = [self.dataMuArr[i] doubleValue];
                CGFloat yPoint = [self coverPoint:value];
                UILabel* label = [self viewWithTag:1000+i];
                CGFloat xPoint = label.center.x;
                
                UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(xPoint, yPoint) radius:2 startAngle:0 endAngle:2*M_PI clockwise:YES];
                bezier.lineWidth = 1;
                [self.chartLineColor set];
                [bezier stroke];
                [bezier fill];
                
                
                if (i == 0) {
                    [path moveToPoint:CGPointMake(xPoint, yPoint)];
                }else{
                    [path addLineToPoint:CGPointMake(xPoint, yPoint)];
                }
            }
            [path stroke];
            
            
            UIBezierPath * fillPath = [UIBezierPath bezierPathWithCGPath:path.CGPath];
            
            [fillPath addLineToPoint:CGPointMake(self.width - 10, self.height-marginY)];
            [fillPath addLineToPoint:CGPointMake(marginX, self.height-marginY)];
            [fillPath addLineToPoint:CGPointMake(marginX, [self coverPoint:[self.dataMuArr.firstObject doubleValue]])];
            [self.shadowColor set];
            [fillPath fill];
        }
    }else{
        
        if (self.dataMuArr.count == 1) {
            UIBezierPath * path = [[UIBezierPath alloc]init];
            path.lineWidth = 2;
            path.lineJoinStyle = kCGLineJoinRound;
            
            double value = [self.dataMuArr[0] doubleValue];
            CGFloat yPoint = [self coverBalancePoint:value];
            UILabel* label = [self viewWithTag:1000];
            CGFloat xPoint = label.center.x;
            
            UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(xPoint, yPoint) radius:2 startAngle:0 endAngle:2*M_PI clockwise:YES];
            bezier.lineWidth = 1;
            [self.chartLineColor set];
            [bezier stroke];
            [bezier fill];
            
            if (value > 0) {
                [_greenLineColor set];
                [_greenShadowColor setFill];
            }else if(value < 0){
                [_redLineColor set];
                [_redShadowColor setFill];
            }else{
                [_lightLineColor set];
            }
            
            [path moveToPoint:CGPointMake(marginX, yPoint)];
            [path addLineToPoint:CGPointMake(self.width - 10, yPoint)];
            [path stroke];
            
            UIBezierPath * fillPath = [UIBezierPath bezierPathWithCGPath:path.CGPath];
            CGFloat height = self.height - self.topMargin - marginY -self.lineHeight;

            [fillPath addLineToPoint:CGPointMake(self.width - 10, height)];
            [fillPath addLineToPoint:CGPointMake(marginX,height)];
            [fillPath addLineToPoint:CGPointMake(marginX, [self coverBalancePoint:[self.dataMuArr.firstObject doubleValue]])];
            [fillPath closePath];
            [fillPath fill];
            
            
        }else{
            UIBezierPath * path = [[UIBezierPath alloc]init];
            path.lineWidth = 2;
            path.lineJoinStyle = kCGLineJoinRound;
            NSMutableDictionary* pointMuDic = [NSMutableDictionary dictionary];
            
            for (int i = 0; i < self.dataMuArr.count; i++) {
                double value = [self.dataMuArr[i] doubleValue];
                CGFloat yPoint = [self coverBalancePoint:value];
                UILabel* label = [self viewWithTag:1000+i];
                CGFloat xPoint = label.center.x;
                
                
                if (value == 0 && i == 0) {
                    [pointMuDic setObject:@"zero" forKey:[NSNumber numberWithInt:i]];
                }
                
                if (i >= 1) {
                    
                    double svalue = [self.dataMuArr[i-1] doubleValue];
                    CGFloat syPoint = [self coverBalancePoint:svalue];
                    UILabel* slabel = [self viewWithTag:1000+i-1];
                    CGFloat sxPoint = slabel.center.x;
                    
                    if (value * svalue < 0) {
                        if (value>0) {
                            [pointMuDic setObject:@"up" forKey:[NSNumber numberWithInt:i]];
                        }else{
                            [pointMuDic setObject:@"down" forKey:[NSNumber numberWithInt:i]];
                        }
                    }
                    if (value == 0) {
                        [pointMuDic setObject:@"zero" forKey:[NSNumber numberWithInt:i]];
                    }
                    
                    
                    NSString* dicValue = pointMuDic[[NSNumber numberWithInt:i]];
                    
//                    NSLog(@"%f -- %f -- %f -- %@ ",value,yPoint,xPoint,dicValue);

                    if (i == self.dataMuArr.count - 1){
                        
                        UIBezierPath* linePath = [UIBezierPath bezierPath];
                        UIBezierPath* shadowPath = [UIBezierPath bezierPath];
                        linePath.lineJoinStyle = kCGLineJoinRound;
                        linePath.lineWidth = 2;
                        [linePath moveToPoint:CGPointMake(xPoint, yPoint)];
                        [shadowPath moveToPoint:CGPointMake(xPoint, self.balanceCenterY)];
                        [shadowPath addLineToPoint:CGPointMake(xPoint, yPoint)];
                        
                        
                        if (value > 0) {
                            [_greenLineColor set];
                            [_greenShadowColor setFill];
                        }else if(value < 0){
                            [_redLineColor set];
                            [_redShadowColor setFill];
                        }else{
                            [_lightLineColor set];
                        }
                        
                        for (int j = i; j >= 0 ; j--) {
                            
                            double ssvalue = [self.dataMuArr[j] doubleValue];
                            CGFloat ssyPoint = [self coverBalancePoint:ssvalue];
                            UILabel* sslabel = [self viewWithTag:1000+j];
                            CGFloat ssxPoint = sslabel.center.x;
                            
                            if (j == 0) {
                                double zerovalue = [self.dataMuArr[j] doubleValue];
                                CGFloat zeroyPoint = [self coverBalancePoint:zerovalue];
                                UILabel* zerolabel = [self viewWithTag:1000+j];
                                CGFloat zeroxPoint = zerolabel.center.x;
                                [linePath addLineToPoint:CGPointMake(zeroxPoint, zeroyPoint)];
                                [linePath stroke];
                                [shadowPath addLineToPoint:CGPointMake(zeroxPoint, zeroyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(zeroxPoint, self.balanceCenterY)];
                                [shadowPath closePath];
                                
                                [shadowPath fill];
                                break;
                            }
                            
                            NSString* sDic = pointMuDic[[NSNumber numberWithInt:j]];
                            
                            if (sDic == nil) {
                                
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                
                            }else if ([sDic isEqualToString:@"zero"]){
                                
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [linePath stroke];
                                
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [shadowPath closePath];
                                
                                [shadowPath fill];
                                break;
                            }else if ([sDic isEqualToString:@"down"]){
                                
                                
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                
                                if (j-1>=0) {
                                    NSInteger sssvalue = [self.dataMuArr[j-1] integerValue];
                                    CGFloat sssyPoint = [self coverBalancePoint:sssvalue];
                                    UILabel* ssslabel = [self viewWithTag:1000+j-1];
                                    CGFloat sssxPoint = ssslabel.center.x;
                                    
                                    CGFloat snewX = fabs(self.balanceCenterY - ssyPoint) * fabs(ssxPoint - sssxPoint) / fabs(ssyPoint - sssyPoint);
                                    
                                    CGPoint scrossPoint = CGPointMake(ssxPoint-snewX, self.balanceCenterY);
                                    [linePath addLineToPoint:scrossPoint];
                                    [shadowPath addLineToPoint:scrossPoint];
                                }
                                [_redShadowColor setFill];
                                [shadowPath closePath];
                                [linePath stroke];
                                [shadowPath fill];
                                
                                break;
                            }else if ([sDic isEqualToString:@"up"]){
                                
                                
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                
                                if (j-1>=0) {
                                    double sssvalue = [self.dataMuArr[j-1] doubleValue];
                                    CGFloat sssyPoint = [self coverBalancePoint:sssvalue];
                                    UILabel* ssslabel = [self viewWithTag:1000+j-1];
                                    CGFloat sssxPoint = ssslabel.center.x;
                                    
                                    CGFloat snewX = fabs(self.balanceCenterY - ssyPoint) * fabs(ssxPoint - sssxPoint) / fabs(sssyPoint - ssyPoint);
                                    CGPoint scrossPoint = CGPointMake(ssxPoint-snewX, self.balanceCenterY);
                                    [linePath addLineToPoint:scrossPoint];
                                    
                                    [shadowPath addLineToPoint:scrossPoint];
                                    
                                }
                                [_greenShadowColor setFill];
                                [linePath stroke];
                                [shadowPath closePath];
                                [shadowPath fill];
                                
                                break;
                                
                            }
                        }
                    }
                    if ([dicValue isEqualToString:@"down"]) {
                        CGFloat newX = abs((int)self.balanceCenterY - (int)syPoint) * (xPoint - sxPoint) / abs((int)yPoint - (int)syPoint);
                        CGPoint crossPoint = CGPointMake(newX+sxPoint, self.balanceCenterY);
                        
                        UIBezierPath* linePath = [UIBezierPath bezierPath];
                        UIBezierPath* shadowPath = [UIBezierPath bezierPath];
                        linePath.lineWidth = 2;
                        [linePath moveToPoint:crossPoint];
                        [shadowPath moveToPoint:crossPoint];
                        linePath.lineJoinStyle = kCGLineJoinRound;
                        
                        [_greenLineColor set];
                        
                        for (int j = i-1; j >= 0 ; j--) {
                            if (j == 0) {
                                double zerovalue = [self.dataMuArr[j] doubleValue];
                                CGFloat zeroyPoint = [self coverBalancePoint:zerovalue];
                                UILabel* zerolabel = [self viewWithTag:1000+j];
                                CGFloat zeroxPoint = zerolabel.center.x;
                                
                                [linePath addLineToPoint:CGPointMake(zeroxPoint, zeroyPoint)];
                                [linePath stroke];
                                [shadowPath addLineToPoint:CGPointMake(zeroxPoint, zeroyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(zeroxPoint, self.balanceCenterY)];
                                [_greenShadowColor setFill];
                                [shadowPath closePath];
                                
                                [shadowPath fill];
                                break;
                            }
                            
                            double ssvalue = [self.dataMuArr[j] doubleValue];
                            CGFloat ssyPoint = [self coverBalancePoint:ssvalue];
                            UILabel* sslabel = [self viewWithTag:1000+j];
                            CGFloat ssxPoint = sslabel.center.x;
                            NSString* sdicValue =  pointMuDic[[NSNumber numberWithInt:j]];
                            
                            if (sdicValue == nil) {
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                
                                [linePath stroke];
                                
                            }else if ([sdicValue isEqualToString:@"zero"]){
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [linePath stroke];
                                
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [_greenShadowColor setFill];
                                [shadowPath closePath];
                                
                                [shadowPath fill];
                                break;
                            }else if ([sdicValue isEqualToString:@"up"]){
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                
                                if (j-1>=0) {
                                    double sssvalue = [self.dataMuArr[j-1] doubleValue];
                                    CGFloat sssyPoint = [self coverBalancePoint:sssvalue];
                                    CGFloat snewX = abs((int)self.balanceCenterY - (int)ssyPoint) * (xPoint - sxPoint) / abs((int)sssyPoint - (int)ssyPoint);
                                    CGPoint scrossPoint = CGPointMake(ssxPoint-snewX, self.balanceCenterY);
                                    [linePath addLineToPoint:scrossPoint];
                                    [linePath stroke];
                                    
                                    [shadowPath addLineToPoint:scrossPoint];
                                    [_greenShadowColor setFill];
                                    [shadowPath closePath];
                                    
                                    [shadowPath fill];
                                    
                                }
                                break;
                                
                            }
                        }
                    }else if ([dicValue isEqualToString:@"up"]){
                        CGFloat newX = abs((int)self.balanceCenterY - (int)yPoint) * (xPoint - sxPoint) / abs((int)yPoint - (int)syPoint);
                        CGPoint crossPoint = CGPointMake(xPoint-newX, self.balanceCenterY);
                        
                        UIBezierPath* linePath = [UIBezierPath bezierPath];
                        UIBezierPath* shadowPath = [UIBezierPath bezierPath];
                        linePath.lineWidth = 2;
                        linePath.lineJoinStyle = kCGLineJoinRound;
                        
                        [linePath moveToPoint:crossPoint];
                        [shadowPath moveToPoint:crossPoint];
                        [_redLineColor set];
                        for (int j = i-1; j >= 0 ; j--) {
                            if (j == 0) {
                                double zerovalue = [self.dataMuArr[j] doubleValue];
                                CGFloat zeroyPoint = [self coverBalancePoint:zerovalue];
                                UILabel* zerolabel = [self viewWithTag:1000+j];
                                CGFloat zeroxPoint = zerolabel.center.x;
                                
                                [linePath addLineToPoint:CGPointMake(zeroxPoint, zeroyPoint)];
                                [linePath stroke];
                                [shadowPath addLineToPoint:CGPointMake(zeroxPoint, zeroyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(zeroxPoint, self.balanceCenterY)];
                                [_redLineColor setFill];
                                [_redShadowColor setFill];

                                [shadowPath closePath];
                                
                                [shadowPath fill];
                                break;
                            }
                            double ssvalue = [self.dataMuArr[j] doubleValue];
                            CGFloat ssyPoint = [self coverBalancePoint:ssvalue];
                            UILabel* sslabel = [self viewWithTag:1000+j];
                            CGFloat ssxPoint = sslabel.center.x;
                            
                            NSString* sdicValue =  pointMuDic[[NSNumber numberWithInt:j]];
                            
                            if (sdicValue == nil) {
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                
                                [linePath stroke];
                            }else if ([sdicValue isEqualToString:@"zero"]){
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [linePath stroke];
                                
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [_redShadowColor setFill];
                                [shadowPath closePath];
                                
                                [shadowPath fill];
                                break;
                            }else if ([sdicValue isEqualToString:@"down"]){
                                
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                if (j-1>=0) {
                                    double sssvalue = [self.dataMuArr[j-1] doubleValue];
                                    CGFloat sssyPoint = [self coverBalancePoint:sssvalue];
                                    CGFloat snewX = abs((int)self.balanceCenterY - (int)ssyPoint) * (xPoint - sxPoint) / abs((int)sssyPoint - (int)ssyPoint);
                                    CGPoint scrossPoint = CGPointMake(ssxPoint-snewX, self.balanceCenterY);
                                    [linePath addLineToPoint:scrossPoint];
                                    [linePath stroke];
                                    
                                    [shadowPath addLineToPoint:scrossPoint];
                                    [_redShadowColor setFill];
                                    [shadowPath closePath];
                                    
                                    [shadowPath fill];
                                    
                                }
                                break;
                            }
                        }
                    }else if ([dicValue isEqualToString:@"zero"]){
                        
                        UIBezierPath* linePath = [UIBezierPath bezierPath];
                        UIBezierPath* shadowPath = [UIBezierPath bezierPath];
                        linePath.lineWidth = 2;
                        [linePath moveToPoint:CGPointMake(xPoint, yPoint)];
                        [shadowPath moveToPoint:CGPointMake(xPoint, yPoint)];
                        linePath.lineJoinStyle = kCGLineJoinRound;
                        
                        
                        for (int j = i-1; j >= 0 ; j--) {
                            //                            if (j == 0) {
                            //                                NSInteger zerovalue = [self.dataMuArr[j] integerValue];
                            //                                CGFloat zeroyPoint = [self coverBalancePoint:zerovalue];
                            //                                UILabel* zerolabel = [self viewWithTag:1000+j];
                            //                                CGFloat zeroxPoint = zerolabel.center.x;
                            //                                if (zerovalue > 0) {
                            //                                    [_greenLineColor set];
                            //                                    [_greenShadowColor setFill];
                            //                                }else if(zerovalue < 0){
                            //                                    [_redLineColor set];
                            //                                    [_redShadowColor setFill];
                            //                                }else{
                            //                                    [_lightLineColor set];
                            //                                }
                            //                                [linePath addLineToPoint:CGPointMake(zeroxPoint, zeroyPoint)];
                            //                                [linePath stroke];
                            //                                [shadowPath addLineToPoint:CGPointMake(zeroxPoint, zeroyPoint)];
                            //                                [shadowPath addLineToPoint:CGPointMake(zeroxPoint, self.balanceCenterY)];
                            //                                [shadowPath closePath];
                            //
                            //                                [shadowPath fill];
                            //                                break;
                            //                            }
                            double ssvalue = [self.dataMuArr[j] doubleValue];
                            CGFloat ssyPoint = [self coverBalancePoint:ssvalue];
                            UILabel* sslabel = [self viewWithTag:1000+j];
                            CGFloat ssxPoint = sslabel.center.x;
                            
                            NSString* sdicValue =  pointMuDic[[NSNumber numberWithInt:j]];
                            
                            
                            if (sdicValue == nil) {
                                if (ssvalue > 0) {
                                    [_greenLineColor set];
                                    [_greenShadowColor setFill];
                                    
                                }else if(ssvalue < 0){
                                    [_redLineColor set];
                                    [_redShadowColor setFill];
                                }else{
                                    [_lightLineColor set];
                                }
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                
                                if (j == 0) {
                                    double zerovalue = [self.dataMuArr[j] doubleValue];
                                    CGFloat zeroyPoint = [self coverBalancePoint:zerovalue];
                                    UILabel* zerolabel = [self viewWithTag:1000+j];
                                    CGFloat zeroxPoint = zerolabel.center.x;
                                    
                                    [shadowPath addLineToPoint:CGPointMake(zeroxPoint, zeroyPoint)];
                                    [shadowPath addLineToPoint:CGPointMake(zeroxPoint, self.balanceCenterY)];
                                    [shadowPath closePath];
                                    
                                    [shadowPath fill];
                                }
                                
                                [linePath stroke];
                                
                            }else if ([sdicValue isEqualToString:@"zero"]){
                                double sssvalue = [self.dataMuArr[j+1] doubleValue];
                                
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                if (sssvalue > 0) {
                                    [_greenLineColor set];
                                    [_greenShadowColor setFill];
                                    
                                }else if(sssvalue < 0){
                                    [_redLineColor set];
                                    [_redShadowColor setFill];
                                }else{
                                    [_lightLineColor set];
                                }
                                [linePath stroke];
                                
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                //                                [[UIColor colorWithRed:220/255.0f green:20/255.0f blue:60/255.0f alpha:0.1f] setFill];
                                [shadowPath closePath];
                                
                                [shadowPath fill];
                                break;
                            }else if ([sdicValue isEqualToString:@"down"]){
                                if (ssvalue > 0) {
                                    [_greenLineColor set];
                                }else if(ssvalue < 0){
                                    [_redLineColor set];
                                }else{
                                    [_lightLineColor set];
                                }
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                if (j-1>=0) {
                                    double sssvalue = [self.dataMuArr[j-1] doubleValue];
                                    CGFloat sssyPoint = [self coverBalancePoint:sssvalue];
                                    CGFloat snewX = abs((int)self.balanceCenterY - (int)ssyPoint) * (xPoint - sxPoint) / abs((int)sssyPoint - (int)ssyPoint);
                                    CGPoint scrossPoint = CGPointMake(ssxPoint-snewX, self.balanceCenterY);
                                    [linePath addLineToPoint:scrossPoint];
                                    [linePath stroke];
                                    
                                    [shadowPath addLineToPoint:scrossPoint];
                                    [[UIColor colorWithRed:220/255.0f green:20/255.0f blue:60/255.0f alpha:0.1f] setFill];
                                    [shadowPath closePath];
                                    
                                    [shadowPath fill];
                                    
                                }
                                break;
                            }else if ([sdicValue isEqualToString:@"up"]){
                                [linePath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                [shadowPath addLineToPoint:CGPointMake(ssxPoint, ssyPoint)];
                                if (ssvalue > 0) {
                                    [_greenLineColor set];
                                }else if(ssvalue < 0){
                                    [_redLineColor set];
                                }else{
                                    [_lightLineColor set];
                                }
                                if (j-1>=0) {
                                    double sssvalue = [self.dataMuArr[j-1] doubleValue];
                                    CGFloat sssyPoint = [self coverBalancePoint:sssvalue];
                                    CGFloat snewX = abs((int)self.balanceCenterY - (int)ssyPoint) * (xPoint - sxPoint) / abs((int)sssyPoint - (int)ssyPoint);
                                    CGPoint scrossPoint = CGPointMake(ssxPoint-snewX, self.balanceCenterY);
                                    [linePath addLineToPoint:scrossPoint];
                                    [linePath stroke];
                                    
                                    [shadowPath addLineToPoint:scrossPoint];
                                    [_greenShadowColor setFill];
                                    [shadowPath closePath];
                                    
                                    [shadowPath fill];
                                    
                                }
                                break;
                                
                            }
                        }
                    }
                    
                }
            }
        }

                
               
        
        for (int i = 0; i < self.dataMuArr.count; i++) {
            double value = [self.dataMuArr[i] doubleValue];
            CGFloat yPoint = [self coverBalancePoint:value];
            UILabel* label = [self viewWithTag:1000+i];
            CGFloat xPoint = label.center.x;
            
            
            UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(xPoint, yPoint) radius:2 startAngle:0 endAngle:2*M_PI clockwise:YES];
            bezier.lineWidth = 1;
            if (value > 0) {
                [_greenLineColor set];
            }else if(value < 0){
                [_redLineColor set];
            }else{
                [_lightLineColor set];
            }
            [bezier stroke];
            [bezier fill];
        }
    }
}



-(void)drawRect:(CGRect)rect{
    
    [self drawDataLine];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextMoveToPoint(context, marginX, self.height - marginY);
    CGContextAddLineToPoint(context, self.width - self.yEndMargin, self.height - marginY);
    CGContextStrokePath(context);
    
    for (int i = 0; i < XCount; i++) {
        CGFloat length[] = {2,2};
        CGContextSetLineDash(context, 0, length, 2);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextMoveToPoint(context, marginX+34.5, self.topMargin + i * self.lineHeight);
        CGContextAddLineToPoint(context, self.width - self.yEndMargin, self.topMargin + i * self.lineHeight);
        CGContextStrokePath(context);
    }
}

-(CGFloat)coverPoint:(double)number{
    
    CGFloat height = self.height - self.topMargin - marginY;
    double highNum = [self.yMuArr.firstObject doubleValue];
    CGFloat ratio = height / highNum ;
    CGFloat value = ratio * number;
    CGFloat pointY = self.height - marginY - value;
    
    return pointY;
}

-(CGFloat)coverBalancePoint:(double)number{
    CGFloat height = self.height - self.topMargin - marginY -self.lineHeight;
    double highNum = [self.yMuArr.firstObject doubleValue];
    double lowNum = [self.yMuArr.lastObject doubleValue];
    double allNum = fabs(highNum) + fabs(lowNum);
    CGFloat ratio = height / allNum;
    
    CGFloat value = fabs((int)number - highNum) * ratio;
    CGFloat pointY = self.topMargin + value;

    
    return pointY;
}

-(NSString*)dateString:(NSString*)integer{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    if ([dateStr isEqualToString:@"Week"]) {
        [dateFormatter setDateFormat:@"MMM"];
        NSString* string = [dateFormatter stringFromDate:date];
        return [NSString stringWithFormat:@"%@ %@",string,integer];
    }else if ([dateStr isEqualToString:@"Day"]){
        [dateFormatter setDateFormat:@"MMM"];
        NSString* string = [dateFormatter stringFromDate:date];
        return [NSString stringWithFormat:@"%@ %@",string,integer];
    }else if([dateStr isEqualToString:@"Month"]){
        [dateFormatter setDateFormat:@"yyyy"];
        NSString* string = [dateFormatter stringFromDate:date];
        NSString* str = nil;
        if ([integer isEqualToString:@"1"]) {
            str = @"Jan";
        }else if([integer isEqualToString:@"2"]){
            str = @"Feb";
        }else if([integer isEqualToString:@"3"]){
            str = @"Mar";
        }else if([integer isEqualToString:@"4"]){
            str = @"Apr";
        }else if([integer isEqualToString:@"5"]){
            str = @"May";
        }else if([integer isEqualToString:@"6"]){
            str = @"Jun";
        }else if([integer isEqualToString:@"7"]){
            str = @"Jul";
        }else if([integer isEqualToString:@"8"]){
            str = @"Aug";
        }else if([integer isEqualToString:@"9"]){
            str = @"Sep";
        }else if([integer isEqualToString:@"10"]){
            str = @"Oct";
        }else if([integer isEqualToString:@"11"]){
            str = @"Nov";
        }else if([integer isEqualToString:@"12"]){
            str = @"Dec";
        }
        return [NSString stringWithFormat:@"%@ %@",string,str];
    }else{
        [dateFormatter setDateFormat:@"yyyy"];
        NSString* string = [dateFormatter stringFromDate:date];
        return string;
        
    }
    
    return nil;
}

-(NSString*)dateArrayString:(NSDate*)date{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    if ([dateStr isEqualToString:@"Week"]) {
        [dateFormatter setDateFormat:@"MMM dd"];
        
        NSDate* startWeekDate ;
        BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSWeekOfYearCalendarUnit startDate:&startWeekDate interval:nil forDate:date];
        
        NSString* string = [dateFormatter stringFromDate:startWeekDate];

        
        NSDate* sdate = [startWeekDate dateByAddingTimeInterval:6 * 24* 3600];
        
        
        return [NSString stringWithFormat:@"%@ - %@",string,[dateFormatter stringFromDate:sdate]];
    }else if ([dateStr isEqualToString:@"Day"]){
        [dateFormatter setDateFormat:@"MMM dd"];
        NSString* string = [dateFormatter stringFromDate:date];
        return string;
    }else if([dateStr isEqualToString:@"Month"]){
        [dateFormatter setDateFormat:@"yyyy MMM"];
        NSString* string = [dateFormatter stringFromDate:date];
        return string;
    }else{
        [dateFormatter setDateFormat:@"yyyy"];
        NSString* string = [dateFormatter stringFromDate:date];
        return string;
    }
    return nil;
}


-(NSString* )getAmountStringWith:(double)max{
    
    NSString *amount;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    if (max<1000)
    {
        [formatter setPositiveFormat:@"###,##0.00;"];
    }
    else
    {
        [formatter setPositiveFormat:@"###,##0.0;"];
        
    }
    
    if (max<1000 && max>-1000)
    {
        amount=[formatter stringFromNumber:[NSNumber numberWithFloat:max]];
    }
    else if(max<1000000 && max>-1000000)
    {
        max=max/1000;
        amount=[NSString stringWithFormat:@"%@k",[formatter stringFromNumber:[NSNumber numberWithFloat:max]]];
    }
    else if(max<1000000000 && max>-1000000000)
    {
        max=max/1000000;
        amount=[NSString stringWithFormat:@"%@m",[formatter stringFromNumber:[NSNumber numberWithFloat:max]]];
    }
    else
    {
        max=max/1000000000;
        amount=[NSString stringWithFormat:@"%@b",[formatter stringFromNumber:[NSNumber numberWithFloat:max]]];
    }
    
    return amount;
}


@end
