//
//  XDPieChartView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/22.
//

#import "XDPieChartView.h"
#import "XDPieChartModel.h"
#import "Category.h"
#import "PokcetExpenseAppDelegate.h"
@interface XDPieChartView()
{
    UILabel* _label;
    UILabel* _amountLabel;
}

@end
@implementation XDPieChartView

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.width = SCREEN_WIDTH/2;
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(15, self.width/2+30, self.width-30, 20)];
        label.font = [UIFont fontWithName:FontSFUITextRegular size:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBColor(172, 172, 172);

        [self addSubview:label];
        _label = label;
        
        UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame), self.width-30, 30)];
        if (IS_IPHONE_5) {
            label1.font = [UIFont fontWithName:FontHelveticaNeueMedium size:18];
        }else{
            label1.font = [UIFont fontWithName:FontHelveticaNeueMedium size:26];
        }
        label1.textAlignment = NSTextAlignmentCenter;
        label1.adjustsFontSizeToFitWidth=YES;

        label1.textColor = RGBColor(85, 85, 85);
        [self addSubview:label1];
        _amountLabel = label1;
        
        if (IS_IPHONE_5) {
            _label.frame = CGRectMake(0, self.width/2+23, self.width, 16);
            _amountLabel.frame = CGRectMake(0, CGRectGetMaxY(label.frame), self.width, 21);
        }
        
        UIImageView* image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jin"]];
        image.frame = CGRectMake(0, 0, 40, 40);
        image.contentMode = UIViewContentModeCenter;
        image.centerX = self.width/2;
        image.centerY = self.width/2 - 30;
        
        if (IS_IPHONE_5) {
            image.centerY = self.width/2 - 28;
        }else if(IS_IPHONE_X){
            image.centerY = self.width/2 - 15;
            _label.y = self.width/2+45;
            _amountLabel.y = CGRectGetMaxY(_label.frame);
        }else{
            image.centerY = self.width/2 - 30;
        }
        
        [self addSubview:image];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    CGFloat pointX = self.width/2;
    CGFloat pointY;
    CGFloat radius;
    if (IS_IPHONE_5) {
        radius = 43;
        pointY = self.width/2-28;
    }else if(IS_IPHONE_X){
        radius = 50;
        pointY = self.width/2 - 15;
    }else{
        radius = 50;
        pointY = self.width/2-30;

    }
    
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(pointX, pointY) radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    path.lineWidth = 15;
    [[UIColor lightGrayColor] set];
    [path stroke];
    
    if (_dataArray.count > 1) {
        CGFloat start = 0;
        CGFloat margin = 2*M_PI*0.002;
        CGFloat allRatio = (1 - 0.002 * _dataArray.count)/1;
        double allAmount = 0;
        for (int i = 0; i < _dataArray.count; i++) {
            XDPieChartModel* model = _dataArray[i];
            allAmount += model.amount;
        }
        _amountLabel.text = [self formatterString:allAmount];
        
        for (int i = 0; i < _dataArray.count; i++) {
            XDPieChartModel* model = _dataArray[i];
            CGFloat angle = (model.amount / allAmount) * 2 * M_PI * allRatio;
            
            if ([model.type isEqualToString:@"EXPENSE"]) {
                _label.text = NSLocalizedString(@"VC_Expense", nil);
            }else{
                _label.text = NSLocalizedString(@"VC_Income", nil);
            }

            UIColor * color = [UIColor mostColor:[UIImage imageNamed:model.category.iconName]];
            UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(pointX, pointY) radius:radius startAngle:start endAngle:start+angle clockwise:YES];
            path.lineWidth = 15;
            [color set];
            [path stroke];
            start += angle;
            
            UIBezierPath* marginPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(pointX, pointY) radius:radius startAngle:start endAngle:start+margin clockwise:YES];
            marginPath.lineWidth = 15;
            [[UIColor whiteColor] set];
            [marginPath stroke];
            start += margin;
            
        }
    }else if (_dataArray.count == 1){
        XDPieChartModel* model = _dataArray.firstObject;
        _amountLabel.text = [self formatterString:model.amount];

        if ([model.type isEqualToString:@"EXPENSE"]) {
            _label.text = NSLocalizedString(@"VC_Expense", nil);
        }else{
            _label.text = NSLocalizedString(@"VC_Income", nil);
        }
        if (model.category) {
            UIColor * color = [UIColor mostColor:[UIImage imageNamed:model.category.iconName]];
            
            UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(pointX, pointY) radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
            path.lineWidth = 15;
            [color set];
            [path stroke];
        }

    }
}

//-------给金额double类型转换成 NSString类型
- (NSString *)formatterString:(double)doubleContext
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *string = @"";
    if(doubleContext >= 0)
        string = [NSString stringWithFormat:@"%.2f",doubleContext];
    else
        string = [NSString stringWithFormat:@"%.2f",-doubleContext];
    
    NSArray *tmp = [string componentsSeparatedByString:@"."];
    NSNumberFormatter *numberStyle = [[NSNumberFormatter alloc] init];
    [numberStyle setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *tmpStr = [numberStyle stringFromNumber:[NSNumber numberWithDouble:[[tmp objectAtIndex:0] doubleValue]]];
    if([tmp count]<2)
    {
        string = tmpStr;
    }
    else
    {
        
        string = [[tmpStr stringByAppendingString:@"."] stringByAppendingString:[tmp objectAtIndex:1]];
    }
    
    
    NSString *typeOfDollar = appDelegate.settings.currency;
    NSArray *dollorArray = [typeOfDollar componentsSeparatedByString:@"-"];
    NSString *dollorStr = [[dollorArray objectAtIndex:0] substringToIndex:[[dollorArray objectAtIndex:0] length]-1];
    
    if (doubleContext<0) {
        dollorStr = [NSString stringWithFormat:@"-%@",dollorStr];
    }
    
    string = [dollorStr stringByAppendingString:string];
    
    if(doubleContext < 0)
        string = [NSString stringWithFormat:@"%@",string];
    
    
    
    return string;
    
}

@end
