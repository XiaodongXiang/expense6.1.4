//
//  UULineChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UULineChart.h"
#import "UUColor.h"
#import "UUChartLabel.h"
#import "PokcetExpenseAppDelegate.h"

@implementation UULineChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    double max = 0;
    double min = 1000000000;

    for (NSArray * ary in yLabels)
    {
        for (NSString *valueString in ary)
        {
            NSLog(@"%@",valueString);
            double value = [valueString doubleValue];
            if (value<[valueString doubleValue])
            {
                value++;
            }
            if (value > max)
            {
                max = value;
            }
            if (value < min)
            {
                min = value;
            }
        }
    }
    if (max < 5)
    {
        max = 5;
    }
    if (self.showRange)
    {
        _yValueMin = min;
    }
    else
    {
        _yValueMin = 0;
    }
    _yValueMax = (double)max;
    
    if (_chooseRange.max!=_chooseRange.min)
    {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    //添加Y轴数字
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    if ([super respondsToSelector:@selector(setMarkRange:)])
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+UULabelHeight, self.frame.size.width, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
        view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
        [self addSubview:view];
    }


}

-(void)setXLabels:(NSArray *)xLabels
{
    if (ISPAD)
    {
        _toLeft=77;
    }
    else
    {
        _toLeft=40;
    }
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    
    _xLabels = xLabels;
    CGFloat num = 0;
    if (xLabels.count>=20) {
        num=20.0;
    }else if (xLabels.count<=1){
        num=1.0;
    }else{
        num = xLabels.count;
    }
    
    if (ISPAD)
    {
        _xLabelWidth=71;
    }
    else
    {
        _xLabelWidth=(self.frame.size.width-45)/12;
    }
    float labelHeight;
    if (ISPAD)
    {
        labelHeight=35;
    }
    else
    {
        labelHeight=13;
    }
    
    for (int i=0; i<xLabels.count; i++)
    {
        NSString *labelText = xLabels[i];
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(_toLeft+i * _xLabelWidth, self.frame.size.height - labelHeight+1, _xLabelWidth, labelHeight)];
        label.text = labelText;
        if (ISPAD)
        {
            [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            label.textColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
        }
        else
        {
            [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
            label.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        }
        
        [self addSubview:label];
        
        [_chartLabelsForX addObject:label];
        
        
        //画竖线
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:self.bounds];
        [shapeLayer setPosition:self.center];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        
        // 设置虚线颜色为blackColor
        [shapeLayer setStrokeColor:[[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1] CGColor]];
        
        // 3.0f设置虚线的宽度
        [shapeLayer setLineWidth:EXPENSE_SCALE];
        [shapeLayer setLineJoin:kCALineJoinRound];
        
        // 3=线的宽度 1=每条线的间距
        [shapeLayer setLineDashPattern:
         [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
          [NSNumber numberWithInt:1],nil]];
        
        // Setup the path
        CGMutablePathRef path = CGPathCreateMutable();
        CGFloat labelHeight;
        if (ISPAD)
        {
            labelHeight=35;
        }
        else
        {
            labelHeight=13;
        }
        CGPathMoveToPoint(path, NULL, _toLeft+i * _xLabelWidth+0.5*_xLabelWidth, self.frame.size.height-labelHeight);
        CGPathAddLineToPoint(path, NULL, _toLeft+i*_xLabelWidth+0.5*_xLabelWidth,UULabelHeight);
        
        [shapeLayer setPath:path];
        CGPathRelease(path);
        
        // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
        [[self layer] addSublayer:shapeLayer];
        
    }
    //横线
    UIView *bottomLine=[[UIView alloc]initWithFrame:CGRectMake(_toLeft, self.frame.size.height-labelHeight-EXPENSE_SCALE, self.frame.size.width-_toLeft-15, EXPENSE_SCALE)];
    bottomLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [self addSubview:bottomLine];
    
    //竖线
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(_toLeft, UULabelHeight, EXPENSE_SCALE, self.frame.size.height-UULabelHeight-labelHeight)];
    line.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218 /255.0 alpha:1];
    [self addSubview:line];
    
    //纵坐标
    for (int i=0; i<6; i++)
    {
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:self.bounds];
        [shapeLayer setPosition:self.center];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        
        // 设置虚线颜色为blackColor
        [shapeLayer setStrokeColor:[[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1] CGColor]];
        
        // 3.0f设置虚线的宽度
        [shapeLayer setLineWidth:EXPENSE_SCALE];
        [shapeLayer setLineJoin:kCALineJoinRound];
        
        // 3=线的宽度 1=每条线的间距
        [shapeLayer setLineDashPattern:
         [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
          [NSNumber numberWithInt:1],nil]];
        
        // Setup the path
        CGMutablePathRef path = CGPathCreateMutable();
        CGFloat labelHeight;
        if (ISPAD)
        {
            labelHeight=35;
        }
        else
        {
            labelHeight=13;
        }
        CGPathMoveToPoint(path, NULL, self.frame.size.width-15, self.frame.size.height-labelHeight-UULabelHeight-i*(self.frame.size.height-labelHeight-2*UULabelHeight)/5);
        CGPathAddLineToPoint(path, NULL, _toLeft,self.frame.size.height-labelHeight-UULabelHeight-i*(self.frame.size.height-labelHeight-2*UULabelHeight)/5);
        
        [shapeLayer setPath:path];
        CGPathRelease(path);
        
        // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
        [[self layer] addSublayer:shapeLayer];

    }
    
    PokcetExpenseAppDelegate *appdelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    
    long long yMax=(long long)_yValueMax;
    if (yMax%5 == 0)
    {
        _yValueMax=(double)yMax;
    }
    else
    {
        _yValueMax=(double)(yMax/5+1)*5;
    }
    //创建左侧Label
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###,##0.00;"];
    
    if (ISPAD)
    {
        UILabel *firstLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 7,65 , 15)];
        firstLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
        firstLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        firstLabel.text=[formatter stringFromNumber:[NSNumber numberWithDouble:_yValueMax]] ;
        firstLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:firstLabel];
        
        UILabel *secondLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 50,65 , 15)];
        secondLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
        secondLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        secondLabel.text=[formatter stringFromNumber:[NSNumber numberWithDouble:_yValueMax/5*4]];
        secondLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:secondLabel];
        
        UILabel *thirdLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 98,65 , 15)];
        thirdLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
        thirdLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        thirdLabel.text=[formatter stringFromNumber:[NSNumber numberWithDouble:_yValueMax/5*3]];
        thirdLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:thirdLabel];
        
        UILabel *forthLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 147,65 , 15)];
        forthLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
        forthLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        forthLabel.text=[formatter stringFromNumber:[NSNumber numberWithDouble:_yValueMax/5*2]];
        forthLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:forthLabel];
        
        UILabel *fifthLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 198,65 , 15)];
        fifthLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
        fifthLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        fifthLabel.text=[formatter stringFromNumber:[NSNumber numberWithDouble:_yValueMax/5*1]] ;
        fifthLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:fifthLabel];
        
        UILabel *sixthLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 245,65 , 15)];
        sixthLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
        sixthLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        sixthLabel.text=[formatter stringFromNumber:[NSNumber numberWithDouble:0]];
        sixthLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:sixthLabel];

    }
    else
    {
        UILabel *firstLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 8,35 , 13)];
        firstLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
        firstLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        firstLabel.text=[self getAmountWith:_yValueMax inLabelTag:0];
        firstLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:firstLabel];
        
        UILabel *secondLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 23,35 , 13)];
        secondLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
        secondLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        secondLabel.text=[self getAmountWith:_yValueMax inLabelTag:1];
        secondLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:secondLabel];
        
        UILabel *thirdLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 40,35 , 13)];
        thirdLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
        thirdLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        thirdLabel.text=[self getAmountWith:_yValueMax inLabelTag:2];
        thirdLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:thirdLabel];
        
        UILabel *forthLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 58,35 , 13)];
        forthLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
        forthLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        forthLabel.text=[self getAmountWith:_yValueMax inLabelTag:3];
        forthLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:forthLabel];
        
        UILabel *fifthLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 76,35 , 13)];
        fifthLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
        fifthLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        fifthLabel.text=[self getAmountWith:_yValueMax inLabelTag:4] ;
        fifthLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:fifthLabel];
        
        UILabel *sixthLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 95,35 , 13)];
        sixthLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
        sixthLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        sixthLabel.text=[self getAmountWith:_yValueMax inLabelTag:5];
        sixthLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:sixthLabel];

    }
}
-(NSString *)getAmountWith:(double)max inLabelTag:(NSInteger )tag
{
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
    switch (tag)
    {
        case 0:
            max=max;
            break;
        case 1:
            max=max/5*4;
            break;
        case 2:
            max=max/5*3;
            break;
        case 3:
            max=max/5*2;
            break;
        case 4:
            max=max/5*1;
            break;
        default:
            max=0;
            break;
    }
    if (max<1000 )
    {
        amount=[formatter stringFromNumber:[NSNumber numberWithDouble:max]];
    }
    else if(max<1000000)
    {
        max=max/1000;
        amount=[NSString stringWithFormat:@"%@k",[formatter stringFromNumber:[NSNumber numberWithDouble:max]]];
    }
    else if(max<1000000000)
    {
        max=max/1000000;
        amount=[NSString stringWithFormat:@"%@m",[formatter stringFromNumber:[NSNumber numberWithDouble:max]]];
    }
    else
    {
        max=max/1000000000;
        amount=[NSString stringWithFormat:@"%@b",[formatter stringFromNumber:[NSNumber numberWithDouble:max]]];
    }
    return amount;
}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}

- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}


-(void)strokeChart
{
    if (ISPAD)
    {
        _toLeft=77;
    }
    else
    {
        _toLeft=40;
    }
    for (int i=0; i<_yValues.count; i++)
    {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0)
        {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i;
        NSInteger min_i;
        
        for (int j=0; j<childAry.count; j++)
        {
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        CGFloat labelHeight;
        if (ISPAD)
        {
            labelHeight=35;
        }
        else
        {
            labelHeight=13;
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 2.0;
        _chartLine.strokeEnd   = 0.0;
        [self.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition =  _xLabelWidth/2.0+_toLeft;
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*2-labelHeight;
        
        double grade = ((double)firstValue-_yValueMin) / ((double)_yValueMax-_yValueMin);
       
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.ShowMaxMinArray)
        {
            if ([self.ShowMaxMinArray[i] intValue]>0)
            {
                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
            }
            else
            {
                isShowMaxAndMinPoint = YES;
            }
        }
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)
                 index:i
                isShow:isShowMaxAndMinPoint
                 value:firstValue];
        
       
        
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in childAry)
        {
            
            double grade =([valueString doubleValue]-_yValueMin) / ((double)_yValueMax-_yValueMin);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                if (self.ShowMaxMinArray)
                {
                    if ([self.ShowMaxMinArray[i] intValue]>0)
                    {
                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                    }
                    else
                    {
                        isShowMaxAndMinPoint = YES;
                    }
                }
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:isShowMaxAndMinPoint
                         value:[valueString floatValue]];
                
            }
            index += 1;
            
            if ([valueString doubleValue]==_yValueMax)
            {
                
            }
        }
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor])
        {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }
        else
        {
            _chartLine.strokeColor = [UUGreen CGColor];
        }
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*0.15;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
    }
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    CGFloat bigPointW;
    CGFloat smallPintW;
    if (ISPAD)
    {
        bigPointW=16;
        smallPintW=10;
    }
    else
    {
        bigPointW=8;
        smallPintW=4;
    }
    if (!isHollow)
    {
        UIView *bigPoint=[[UIView alloc]initWithFrame:CGRectMake(5, 5, bigPointW, bigPointW)];
        if (index==0)
        {
            bigPoint.backgroundColor=[UIColor colorWithRed:130/255.0 green:233/255.0 blue:154/255.0 alpha:1];
        }
        else
        {
            bigPoint.backgroundColor=[UIColor colorWithRed:255/255.0 green:162/255.0 blue:170/255.0 alpha:1];
        }
        bigPoint.center=point;
        bigPoint.layer.cornerRadius = bigPointW/2;
        [self addSubview:bigPoint];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, smallPintW, smallPintW)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = smallPintW/2;
    view.layer.borderWidth = smallPintW/2;

    
    if (index==0)
    {
        view.layer.borderColor=[UIColor colorWithRed:46/255.0 green:218/255.0 blue:87/255.0 alpha:1].CGColor;
        view.backgroundColor=[UIColor colorWithRed:46/255.0 green:218/255.0 blue:87/255.0 alpha:1];
    }
    else
    {
        view.layer.borderColor=[[UIColor colorWithRed:255/255.0 green:110/255.0 blue:121/255.0 alpha:1] CGColor];
        view.backgroundColor=[UIColor colorWithRed: 255/255.0 green:110/255.0 blue:121/255.0 alpha:1];
    }
    
    [self addSubview:view];
    

}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end
