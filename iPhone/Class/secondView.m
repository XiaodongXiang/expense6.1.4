//
//  secondView.m
//  SignDEMO
//
//  Created by APPXY_DEV005 on 15/12/14.
//  Copyright © 2015年 APPXY_DEV005. All rights reserved.
//

#import "secondView.h"
#import "NSStringAdditions.h"

@interface secondView ()
{
    UILabel *topLabel;
    UILabel *firstLabel;
    UILabel *secondLabel;
    UILabel *thirdLabel;
    
    UIImageView *gear1;
    UIImageView *gear2;
    UIImageView *gear3;
    
    UIImageView *parse;
    UIImageView *sub;
    UIImageView *sync;
}
@end

@implementation secondView

-(void)drawRect:(CGRect)rect
{
    [self createViews];
    [self startAnimation];
}
-(void)createViews
{
    float gearBgToLeft;
    float gearBgToTop;
    float gear1ToTop;
    float gear1ToLeft;
    float gear2ToTop;
    float gear2ToLeft;
    float gear3ToRight;
    float gear3ToTop;
    float topLabelTo;
    float firstLabelTo;
    float secondLabelTo;
    float thirdLabelTo;
    float parseToTop;
    float parseToLeft;
    float subsToTop;
    float subsToLeft;
    float syncToTop;
    float syncToRight;
    if (IS_IPHONE_5)
    {
        gearBgToLeft=40.5;
        gearBgToTop=82;
        gear1ToLeft=90;
        gear1ToTop=137;
        gear2ToLeft=37;
        gear2ToTop=112;
        gear3ToRight=30;
        gear3ToTop=182;
        topLabelTo=155;
        firstLabelTo=108;
        secondLabelTo=80;
        thirdLabelTo=52;
        parseToTop=157;
        parseToLeft=110;
        subsToTop=128;
        subsToLeft=53;
        syncToTop=195;
        syncToRight=43;
    }
    else if (IS_IPHONE_4)
    {
        gearBgToLeft=40.5;
        gearBgToTop=68;
        gear1ToLeft=90;
        gear1ToTop=123;
        gear2ToLeft=37;
        gear2ToTop=98;
        gear3ToRight=30;
        gear3ToTop=168;
        topLabelTo=129;
        firstLabelTo=87;
        secondLabelTo=59;
        thirdLabelTo=31;
        parseToTop=143;
        parseToLeft=110;
        subsToTop=114;
        subsToLeft=53;
        syncToTop=181;
        syncToRight=43;
    }
    else if(IS_IPHONE_6)
    {
        gearBgToLeft=68;
        gearBgToTop=131;
        gear1ToLeft=117.5;
        gear1ToTop=186;
        gear3ToRight=58;
        gear3ToTop=231;
        topLabelTo=166;
        firstLabelTo=124;
        secondLabelTo=96;
        thirdLabelTo=68;
        parseToTop=206;
        parseToLeft=137.5;
        subsToTop=177;
        subsToLeft=81;
        syncToTop=244;
        syncToRight=71;
    }
    else if (IS_IPHONE_6PLUS)
    {
        gearBgToLeft=75.33;
        gearBgToTop=144;
        gear1ToLeft=130;
        gear1ToTop=205;
        gear2ToLeft=72;
        gear2ToTop=177;
        gear3ToRight=66;
        gear3ToTop=254;
        topLabelTo=155;
        firstLabelTo=124;
        secondLabelTo=96;
        thirdLabelTo=68;
        parseToTop=227;
        parseToLeft=152;
        subsToTop=195;
        subsToLeft=90;
        syncToTop=268;
        syncToRight=80;
    }
    
    UIImage *gearBgImage=[UIImage imageNamed: @"gear_bg"];
    UIImageView *gearBg=[[UIImageView alloc]initWithFrame:CGRectMake(gearBgToLeft, gearBgToTop, gearBgImage.size.width, gearBgImage.size.height)];
    gearBg.image=gearBgImage;
    [self addSubview:gearBg];
    
    
    //三个齿轮
    UIImage *gearImage1=[UIImage imageNamed:@"gear1"];
    gear1=[[UIImageView alloc]initWithFrame:CGRectMake(gear1ToLeft, gear1ToTop, gearImage1.size.width, gearImage1.size.height)];
    gear1.image=gearImage1;
    [self addSubview:gear1];
    
    UIImage *gearImage2=[UIImage imageNamed:@"gear2"];
    gear2=[[UIImageView alloc]initWithFrame:CGRectMake(gear2ToLeft, gear2ToTop, gearImage2.size.width, gearImage2.size.height)];
    gear2.image=gearImage2;
    [self addSubview:gear2];
    
    UIImage *gearImage3=[UIImage imageNamed:@"gear3"];
    gear3=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gearImage3.size.width-gear3ToRight, gear3ToTop, gearImage3.size.width, gearImage3.size.height)];
    gear3.image=gearImage3;
    [self addSubview:gear3];
    

    //圆形图片
    
    UIImage *parseImage=[UIImage imageNamed:@"Parse"];
    parse=[[UIImageView alloc]initWithFrame:CGRectMake(parseToLeft, parseToTop, parseImage.size.width, parseImage.size.height)];
    parse.image=parseImage;
    [self addSubview:parse];
    parse.alpha=0;
    
    UIImage *subImage=[UIImage imageNamed:@"subscription"];
    sub=[[UIImageView alloc]initWithFrame:CGRectMake(subsToLeft, subsToTop, subImage.size.width, subImage.size.height)];
    sub.image=subImage;
    [self addSubview:sub];
    sub.alpha=0;
    
    UIImage *syncImage=[UIImage imageNamed:@"Syncdata"];
    sync=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-syncImage.size.width-syncToRight, syncToTop, syncImage.size.width, syncImage.size.height)];
    sync.image=syncImage;
    [self addSubview:sync];
    sync.alpha=0;
    
    //黄色背景
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (IS_IPHONE_4)
    {
        bgView.image=[UIImage imageNamed:[NSString customImageName:@"pilot_2_bg_iphone4"]];
    }
    else
    {
        bgView.image=[UIImage imageNamed:[NSString customImageName:@"pilot_2_bg"]];
    }
    [self addSubview:bgView];
    
    
    //文字
    topLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2, SCREEN_HEIGHT-33-topLabelTo, 300, 33)];
    topLabel.text=@"Join in Parse,enjoy more";
    topLabel.font=[UIFont fontWithName:@"UniversLTStd-LightCn" size:30];
    topLabel.textAlignment=NSTextAlignmentCenter;
    topLabel.textColor=[UIColor whiteColor];
    [self addSubview:topLabel];
    topLabel.alpha=0;
    
    firstLabel=[[UILabel alloc]initWithFrame:CGRectMake(180, SCREEN_HEIGHT-23-firstLabelTo, 156, 23)];
    firstLabel.text=@"Monthly subscription";
    firstLabel.font=[UIFont fontWithName:@"UniversLTStd-LightCn" size:20];
    firstLabel.textAlignment=NSTextAlignmentCenter;
    firstLabel.textColor=[UIColor whiteColor];
    [self addSubview:firstLabel];
    firstLabel.alpha=0;
    
    secondLabel=[[UILabel alloc]initWithFrame:CGRectMake(268, SCREEN_HEIGHT-23-secondLabelTo, 139, 23)];
    secondLabel.text=@"Sync data anytime";
    secondLabel.font=[UIFont fontWithName:@"UniversLTStd-LightCn" size:20];
    secondLabel.textAlignment=NSTextAlignmentCenter;
    secondLabel.textColor=[UIColor whiteColor];
    [self addSubview:secondLabel];
    secondLabel.alpha=0;
    
    thirdLabel=[[UILabel alloc]initWithFrame:CGRectMake(357, SCREEN_HEIGHT-23-thirdLabelTo, 216, 23)];
    thirdLabel.text=@"And other upcoming features";
    thirdLabel.font=[UIFont fontWithName:@"UniversLTStd-LightCn" size:20];
    thirdLabel.textAlignment=NSTextAlignmentCenter;
    thirdLabel.textColor=[UIColor whiteColor];
    [self addSubview:thirdLabel];
    thirdLabel.alpha=0;
    
}
-(void)startAnimation
{
    CABasicAnimation *rotate1=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate1.toValue=[NSNumber numberWithFloat:M_PI*2.0];
    rotate1.duration=1.6*3;
    rotate1.cumulative=YES;
    rotate1.repeatCount=NSIntegerMax;
    [gear1.layer addAnimation:rotate1 forKey:@"rotationAnimation"];
    
    CABasicAnimation *rotate2=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate2.toValue=[NSNumber numberWithFloat:-M_PI*2.0];
    rotate2.duration=1.6*3*148/280;
    rotate2.cumulative=YES;
    rotate2.repeatCount=NSIntegerMax;
    [gear2.layer addAnimation:rotate2 forKey:@"rotationAnimation"];
    
    CABasicAnimation *rotate3=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate3.toValue=[NSNumber numberWithFloat:-M_PI*2.0];
    rotate3.duration=1.6*3*122/280;
    rotate3.cumulative=YES;
    rotate3.repeatCount=NSIntegerMax;
    [gear3.layer addAnimation:rotate2 forKey:@"rotationAnimation"];
}
-(void)iconAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        parse.alpha=1;
        sync.alpha=1;
        sub.alpha=1;
    }];
}
-(void)labelStartAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        topLabel.alpha=1;
    }];

}
-(void)labelEndAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        firstLabel.alpha=1;
        firstLabel.frame=CGRectMake((SCREEN_WIDTH-firstLabel.frame.size.width)/2, firstLabel.frame.origin.y, firstLabel.frame.size.width, firstLabel.frame.size.height);

    }];
    [UIView animateWithDuration:0.5 animations:^{
        secondLabel.alpha=1;
        secondLabel.frame=CGRectMake((SCREEN_WIDTH-secondLabel.frame.size.width)/2, secondLabel.frame.origin.y, secondLabel.frame.size.width, secondLabel.frame.size.height);

    }];
    [UIView animateWithDuration:0.6 animations:^{
        thirdLabel.alpha=1;
        thirdLabel.frame=CGRectMake((SCREEN_WIDTH-thirdLabel.frame.size.width)/2, thirdLabel.frame.origin.y, thirdLabel.frame.size.width, thirdLabel.frame.size.height);
    }];
}

@end
