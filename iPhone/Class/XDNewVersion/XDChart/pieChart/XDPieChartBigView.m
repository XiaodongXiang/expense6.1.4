//
//  XDPieChartBigView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/23.
//

#import "XDPieChartBigView.h"
#import "XDPieChartModel.h"
#import "Category.h"
#import "AppDelegate_iPhone.h"

@interface XDPieChartBigView()
{
    UILabel* _label;
    UILabel* _amountLabel;
}

@end
@implementation XDPieChartBigView

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self setNeedsDisplay];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.width = SCREEN_WIDTH/2;
        self.backgroundColor = [UIColor whiteColor];
//
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, self.width/2-30, self.width-40, 20)];
        label.font = [UIFont fontWithName:FontSFUITextRegular size:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBColor(172, 172, 172);
        [self addSubview:label];
        _label = label;

        UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, self.width/2-10, self.width-40, 30)];
        label1.font = [UIFont fontWithName:FontHelveticaNeueMedium size:30];
        label1.adjustsFontSizeToFitWidth=YES;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = RGBColor(85, 85, 85);
        [self addSubview:label1];
        _amountLabel = label1;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    
    CGFloat radius = self.width/2 - 15;
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.width/2) radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    path.lineWidth = 20;
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

        _amountLabel.text = [appDelegate_iPhone.epnc formatterString:allAmount];
        
        for (int i = 0; i < _dataArray.count; i++) {
            XDPieChartModel* model = _dataArray[i];
            CGFloat angle = (model.amount / allAmount) * 2 * M_PI * allRatio;
            
            if ([model.type isEqualToString:@"EXPENSE"]) {
                _label.text = NSLocalizedString(@"VC_Expense", nil);
            }else{
                _label.text = NSLocalizedString(@"VC_Income", nil);
            }
            
            UIColor * color = [UIColor mostColor:[UIImage imageNamed:model.category.iconName]];
            UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.width/2) radius:radius startAngle:start endAngle: start+angle clockwise:YES];
            path.lineWidth = 20;
            [color set];
            [path stroke];
            start += angle;
            
            UIBezierPath* marginPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.width/2) radius:radius startAngle:start endAngle: start+margin clockwise:YES];
            marginPath.lineWidth = 20;
            [[UIColor whiteColor] set];
            [marginPath stroke];
            start += margin;
            
        }
    }else if (_dataArray.count == 1){
        XDPieChartModel* model = _dataArray.firstObject;
        _amountLabel.text = [appDelegate_iPhone.epnc formatterString:model.amount];
        
        if ([model.type isEqualToString:@"EXPENSE"]) {
            _label.text = NSLocalizedString(@"VC_Expense", nil);
        }else{
            _label.text = NSLocalizedString(@"VC_Income", nil);
        }
        if (model.category) {
            UIColor * color = [UIColor mostColor:[UIImage imageNamed:model.category.iconName]];
            
            UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.width/2) radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
            path.lineWidth = 20;
            [color set];
            [path stroke];
        }
        
    }
}


@end
