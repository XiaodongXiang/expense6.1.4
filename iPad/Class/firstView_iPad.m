//
//  firstView_iPad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/18.
//
//

#import "firstView_iPad.h"

@interface firstView_iPad ()
{
    UIImageView *savemoneyIcon;
    UIImageView *billIcon;
    UIImageView *chartIcon;
    UIImageView *phoneImge;
    UILabel *topLabel;
    UILabel *firstLabel;
    UILabel *secondLabel;
    UILabel *thirdLabel;
}
@end

@implementation firstView_iPad


-(void)drawRect:(CGRect)rect
{
    self.backgroundColor=[UIColor whiteColor];
    UIImageView *bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImage.image=[UIImage imageNamed:@"ipad_pilot_1_bg"];
    [self addSubview:bgImage];
    [self createViews];
    [self startAnimation];
}
-(void)createViews
{
    float phoneHeight;
    float phoneWidth;
    float phoneToTop;
    float phoneToLeft;
    
    float iconWidth;
    float iconToTop;
    
    float topLabelTo;
    float firstLabelTo;
    float secondLabelTo;
    float thirdLabelTo;
 
    phoneHeight=157;
    phoneWidth=110;
    iconWidth=67;
    iconToTop=284;
    phoneToTop=230;
    phoneToLeft=452;
    topLabelTo=214;
    firstLabelTo=153;
    secondLabelTo=116;
    thirdLabelTo=82;

    
    //icon
    savemoneyIcon=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-iconWidth)/2, iconToTop, iconWidth, iconWidth)];
    savemoneyIcon.image=[UIImage imageNamed:[NSString customImageName:@"pilot_1_savemoney"]];
    [self addSubview:savemoneyIcon];
    savemoneyIcon.alpha=0;
    
    billIcon=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-iconWidth)/2, iconToTop, iconWidth, iconWidth)];
    billIcon.image=[UIImage imageNamed:[NSString customImageName:@"pilot_1_bill"]];
    [self addSubview:billIcon];
    billIcon.alpha=0;
    
    chartIcon=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-iconWidth)/2, iconToTop, iconWidth, iconWidth)];
    chartIcon.image=[UIImage imageNamed:[NSString customImageName:@"pilot_1_chart"]];
    [self addSubview:chartIcon];
    chartIcon.alpha=0;
    
    //phone
    phoneImge=[[UIImageView alloc]initWithFrame:CGRectMake(phoneToLeft, phoneToTop, phoneWidth, phoneHeight)];
    phoneImge.image=[UIImage imageNamed:[NSString customImageName:@"pilot_1_phone"]];
    [self addSubview:phoneImge];
    
    topLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, SCREEN_HEIGHT-33-topLabelTo+75, 200, 33)];
    topLabel.text=@"Efficient assitant";
    topLabel.font=[UIFont fontWithName:@"UniversLTStd-LightCn" size:30];
    topLabel.textAlignment=NSTextAlignmentCenter;
    topLabel.textColor=[UIColor whiteColor];
    [self addSubview:topLabel];
    topLabel.alpha=0;
    
    firstLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, SCREEN_HEIGHT-23-firstLabelTo+75, 150, 23)];
    firstLabel.text=@"Save money";
    firstLabel.font=[UIFont fontWithName:@"UniversLTStd-LightCn" size:20];
    firstLabel.textAlignment=NSTextAlignmentCenter;
    firstLabel.textColor=[UIColor whiteColor];
    [self addSubview:firstLabel];
    firstLabel.alpha=0;
    
    secondLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, SCREEN_HEIGHT-23-secondLabelTo+75, 150, 23)];
    secondLabel.text=@"Power analysis";
    secondLabel.font=[UIFont fontWithName:@"UniversLTStd-LightCn" size:20];
    secondLabel.textAlignment=NSTextAlignmentCenter;
    secondLabel.textColor=[UIColor whiteColor];
    [self addSubview:secondLabel];
    secondLabel.alpha=0;
    
    thirdLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, SCREEN_HEIGHT-23-thirdLabelTo+75, 150, 23)];
    thirdLabel.text=@"Bill Reminder";
    thirdLabel.font=[UIFont fontWithName:@"UniversLTStd-LightCn" size:20];
    thirdLabel.textAlignment=NSTextAlignmentCenter;
    thirdLabel.textColor=[UIColor whiteColor];
    [self addSubview:thirdLabel];
    thirdLabel.alpha=0;

}
-(void)startAnimation
{
    [self performSelector:@selector(iconAnimation) withObject:self afterDelay:0.5];
    
    [self performSelector:@selector(labelAnimation:) withObject:topLabel afterDelay:1];
    [self performSelector:@selector(labelAnimation:) withObject:firstLabel afterDelay:1.1];
    [self performSelector:@selector(labelAnimation:) withObject:secondLabel afterDelay:1.2];
    [self performSelector:@selector(labelAnimation:) withObject:thirdLabel afterDelay:1.3];
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.duration = 1; // 持续时间
    animation1.repeatCount = 1; // 重复次数
    animation1.fromValue = [NSNumber numberWithFloat:0];
    animation1.toValue = [NSNumber numberWithFloat:1];
    [phoneImge.layer addAnimation:animation1 forKey:@"scale-layer"];
    
    CABasicAnimation *animation2=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.duration=0.5;
    animation2.fromValue=[NSNumber numberWithFloat:0];
    animation2.toValue=[NSNumber numberWithFloat:1];
    [phoneImge.layer addAnimation:animation2 forKey:@"opacity-layer"];

}
-(void)iconAnimation
{
    float toLeft;
    float toTop;
    float billIconToTop;

    toLeft=366;
    toTop=284;
    billIconToTop=152;
    
    [self iconAnimationWithView:savemoneyIcon andPosition:CGRectMake(toLeft, toTop, savemoneyIcon.frame.size.width, savemoneyIcon.frame.size.width)];
    [self iconAnimationWithView:chartIcon andPosition:CGRectMake(SCREEN_WIDTH-chartIcon.frame.size.width-toLeft,toTop , chartIcon.frame.size.width, chartIcon.frame.size.height)];
    [self iconAnimationWithView:billIcon andPosition:CGRectMake(billIcon.frame.origin.x,billIconToTop , billIcon.frame.size.width, billIcon.frame.size.height)];
}
-(void)iconAnimationWithView:(UIView *)view andPosition:(CGRect )position
{
    
    
    view.alpha=0.4;
    
    CABasicAnimation *animation2=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue=[NSNumber numberWithFloat:0.4];
    animation2.toValue=[NSNumber numberWithFloat:1];
    animation2.duration=1;
    [view.layer addAnimation:animation2 forKey:@"scale-layer"];
    
    [UIView animateWithDuration:1 animations:^{
        view.frame=position;
        view.alpha=1;
        
    }];
}
-(void)labelAnimation:(UILabel *)label
{
    [UIView animateWithDuration:0.5 animations:^{
        label.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y-75, label.frame.size.width, label.frame.size.height);
        label.alpha=1;
    }];
}

@end
