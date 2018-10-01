//
//  CalDateView.m
//  MSCal
//
//  Created by wangdong on 3/6/14.
//  Copyright (c) 2014 dongdong.wang. All rights reserved.
//

#import "CalDateView.h"
#import "MonthCal2ViewController.h"
#import "HelpClass.h"
#import "PlannerClass.h"
#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"
#import "KalViewController_week.h"
#import "KalLogic_week.h"
#import "NSDateAdditions.h"
#import "KalDate_week.h"
#import "UIViewAdditions.h"
#import "OverViewWeekCalenderViewController.h"
//#import "Define_iPhone.h"

@interface CalDateView ()
{
    BOOL        selected;
    NSInteger selectIndex;
}
@end

@implementation CalDateView
@synthesize dateArray;

-(void)dealloc
{
    dateArray  = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    //右对齐文字
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentRight];
    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    
    double tileWidth_WD = SCREEN_WIDTH/7.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);

//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:(random()%255)/255.f green:(random()%255)/255.f blue:(random()%255)/255.f alpha:1.0].CGColor);
//    CGContextFillRect(context, rect);
    
    
//    CGContextSetLineWidth(context, 0.5);
    //月日历背景灰色
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:248/255.f green:248/255.f blue:248/255.f alpha:1].CGColor);
    CGContextFillRect(context, rect);
    
    NSDate *todayDate = [[NSDate date] getStartTimeInDay:NSCalendarTypeTimezone];
    NSDateComponents * dc = [todayDate dateComponentsYMDcalType:NSCalendarTypeTimezone];
    
    NSInteger preNum = 0;
    NSInteger i = 0;
    NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
    
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//    UIColor *textColorToday = [UIColor colorWithRed:3.f/255.f green:128.f/255.f blue:255.f/255.f alpha:1];
//    UIFont *dayfontToday = [appDelegate_iphone.epnc getDateFont_inClaendar_WithSize:17];
//    UIColor *backgroundColorToday = [UIColor colorWithRed:206.0/255.0 green:223.0/255.0 blue:249.0/255.0 alpha:1.0];

    for (NSDate *date in dateArray)
    {
        UIColor *textColor = [UIColor colorWithRed:94.0/255.0 green:99.0/255.0 blue:117.0/255.0 alpha:1.0];
        UIFont *dayfont =[UIFont fontWithName:@"HelveticaNeue-Light" size:17];
//        UIColor *backgroundColor = [UIColor colorWithRed:244.f/255.f green:244.f/255.f blue:244.f/255.f alpha:1];

        
        BOOL isToday = NO;
        NSDateComponents * d1 = [date dateComponentsYMDcalType:NSCalendarTypeTimezone];
        //判断该日期是不是今天
        if ((dc.year == d1.year && dc.month == d1.month) && dc.day == d1.day)
        {
            isToday = YES;
        }
        NSUInteger n = d1.day;
        NSString *day = [NSString stringWithFormat:@"%lu",(unsigned long)n];
        
        //如果某个月的第一天 && 是某一行的第一个
        if (d1.day == 1 && preNum == 0)
        {
            //第一个日期从这周的第几天开始
            preNum = 7 - dateArray.count;
            UIColor *monthColor = textColor;
            
            //如果是几天，显示这种字体
            if (isToday)
            {
                dayfont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
                textColor = [UIColor colorWithRed:61/255.f green:190/255.f blue:255/255.f alpha:1];
                CGContextSetFillColorWithColor(context, [UIColor colorWithRed:203/255.f green:234/255.f blue:250/255.f alpha:1].CGColor);
                CGContextFillRect(context, CGRectMake((i+preNum)*SCREEN_WIDTH/7.0 , 0, SCREEN_WIDTH/7.0, self.frame.size.height));
//                CGContextFillRect(context, rect);
//                monthColor = [UIColor colorWithRed:244.0/255.0 green:131.0/255.0 blue:11.0/255.0 alpha:1.0];
            }
            //？？？
            if (selected && selectIndex == i+preNum)
            {
                CGContextSetFillColorWithColor(context, [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0].CGColor);
                CGContextFillRect(context, CGRectMake((i+preNum)*SCREEN_WIDTH/7.0 , 0, SCREEN_WIDTH/7.0, self.frame.size.height));
            }
            
            //设置这个日期的月份文字

            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

            [dateFormatter setDateFormat:@"MMM"];
            NSString *monthStr = [dateFormatter stringFromDate:date];
            
            //写日期
            CGSize size = [day sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:dayfont,NSFontAttributeName, nil]];
            CGFloat x = (i+preNum)*tileWidth_WD-5;

            CGRect r = CGRectIntegral(CGRectMake(x, 5, tileWidth_WD, size.height));
            [day drawInRect:r withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:dayfont,NSFontAttributeName,textColor,NSForegroundColorAttributeName,ps,NSParagraphStyleAttributeName,nil]];
            
            
            
            //写月份
            UIFont *monthFont = [appDelegate_iphone.epnc GETdateFont_Regular_withSize:10];
            CGSize monthSize = [monthStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:monthFont,NSFontAttributeName, nil]];
            CGPoint monthPoint = CGPointMake((i+preNum)*tileWidth_WD + (tileWidth_WD- monthSize.width)/2.0, 1);
            [monthStr drawAtPoint:monthPoint
                   withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:monthFont,NSFontAttributeName,
                                   monthColor,NSForegroundColorAttributeName,nil]];
        }
        else
            
        {
            if (selected && selectIndex == (i+preNum))
            {
                CGContextSetFillColorWithColor(context, [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0].CGColor);
                CGContextFillRect(context, CGRectMake((i+preNum)*tileWidth_WD, 0, tileWidth_WD, self.frame.size.height));
            }
            
            //当天  黄色
            if (isToday)
            {
                textColor = [UIColor colorWithRed:61/255.f green:190/255.f blue:255/255.f alpha:1];
                dayfont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
                CGContextSetFillColorWithColor(context, [UIColor colorWithRed:203/255.f green:234/255.f blue:250/255.f alpha:1].CGColor);
                CGContextFillRect(context, CGRectMake((i+preNum)*SCREEN_WIDTH/7.0 , 0, SCREEN_WIDTH/7.0, self.frame.size.height));


            }
            
            CGSize size = [day sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:dayfont,NSFontAttributeName, nil]];
            CGFloat x = (i+preNum)*tileWidth_WD;
            CGRect drawRect = CGRectMake(x, 5, tileWidth_WD-8, size.height);
            
            [day drawInRect:drawRect
             withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:dayfont,NSFontAttributeName,textColor,NSForegroundColorAttributeName,ps,NSParagraphStyleAttributeName,nil]];
        }
        
        
        BOOL showWeek = [[NSUserDefaults standardUserDefaults] boolForKey:ShowWeekNumber];
        NSInteger firstWeekDay = [[NSCalendar timezoneCalendar] firstWeekday];
        NSInteger mondayColumn =(14-2*(firstWeekDay-1) + firstWeekDay)%7;
        if (showWeek && preNum + i == mondayColumn)
        {
            [weekFormatter setDateFormat:@"w"];
            NSString *week = [weekFormatter stringFromDate:date];
            CGPoint drawPoint = CGPointMake((preNum + i)*tileWidth_WD,  14);
            UIFont *weekFont = [UIFont fontWithName:@"AvenirNext-Regular" size:9];
            if (mondayColumn !=0 ) {
                CGSize weekSize = [day sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:weekFont,NSFontAttributeName, nil]];
                drawPoint = CGPointMake((preNum + i)*tileWidth_WD - weekSize.width/2.0 , 14);
            }
            
            [week drawAtPoint:drawPoint
               withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:weekFont,NSFontAttributeName,
                               [UIColor colorWithRed:176.0/255.0 green:173.0/255.0 blue:169.0/255.0 alpha:1.0],NSForegroundColorAttributeName,nil]];
        }
        
        i++;
    }
    
    //画线
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetLineWidth(context, EXPENSE_SCALE);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0].CGColor);
    CGContextMoveToPoint(context, preNum * tileWidth_WD, 0.25);
    CGContextAddLineToPoint(context, (preNum+dateArray.count) * tileWidth_WD, 0.25);
    CGContextStrokePath(context);
    
    CGContextSetAllowsAntialiasing(context, true);
    

}

#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    


    
    UITouch *touch =  [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGFloat tileWidth = [UIScreen mainScreen].bounds.size.width/7.0f;
    NSInteger column = (NSInteger)(point.x/tileWidth);
    NSDate *firstDate = [dateArray objectAtIndex:0];
    
    NSInteger unusefulIndex = 0;
    NSDateComponents * d1 = [firstDate dateComponentsYMDcalType:NSCalendarTypeTimezone];
    if (d1.day == 1) {
        unusefulIndex = 7 - [dateArray count];
    }
    if (column - unusefulIndex < dateArray.count)
    {
        selectIndex =column;
        selected = YES;
        [self setNeedsDisplay];
    }
    
}

//点击事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    double tileWidth_WD = SCREEN_WIDTH/7.0;
    double MonthRowHeight = 0;
    if (IS_IPHONE_6PLUS)
    {
        MonthRowHeight = 69;
    }
    else if (IS_IPHONE_6)
        MonthRowHeight = 62;
    else
        MonthRowHeight = 53;
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        selected = NO;
        selectIndex = -1;
        [self setNeedsDisplay];
    });
    UITouch *touch =  [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGFloat tileWidth = [UIScreen mainScreen].bounds.size.width/7.0f;
    NSInteger column = (NSInteger)(point.x/tileWidth);
    NSDate *firstDate = [dateArray objectAtIndex:0];
    
    NSInteger unusefulIndex = 0;
    NSDateComponents * d1 = [firstDate dateComponentsYMDcalType:NSCalendarTypeTimezone];
    if (d1.day == 1)
    {
        unusefulIndex = 7 - [dateArray count];
    }
    if (column - unusefulIndex < dateArray.count)
    {
        //do selected
        NSDate *selectedDate  = [dateArray objectAtIndex:column - unusefulIndex];
        
        AppDelegate_iPhone  *appDelegate = (AppDelegate_iPhone  *)[UIApplication sharedApplication].delegate;
        CGPoint p = [touch locationInView:appDelegate.overViewController.calViewController._tableView];
        CGRect fromRect = CGRectMake(column * tileWidth_WD, (NSInteger)(p.y/MonthRowHeight)*MonthRowHeight, tileWidth_WD, MonthRowHeight);
        
        delayInSeconds = 0.001;
        popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            //这只week日历baseDate,将日历跳转到哪一天
            appDelegate.overViewController.kalViewController.logic.baseDate = [selectedDate cc_dateByMovingToFirstDayOfTheWeek];
            //先把界面中的周显示出来，然后设置选中的那一天，然后跳到那个页面开始刷新数据
            [appDelegate.overViewController.kalViewController showCurrentMonth];
            [appDelegate.overViewController.kalViewController.kalView selectDate:[KalDate_week dateFromNSDate:selectedDate]];
            
            [self monthCalendartoWeekCalendarAnimationfromRect:fromRect];
            appDelegate.overViewController.isShowMonthCalendar = NO;

        });

    }
    

    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    selected = NO;
    [self setNeedsDisplay];
}

-(void)monthCalendartoWeekCalendarAnimationfromRect:(CGRect) fromRect
{


    AppDelegate_iPhone *app = (AppDelegate_iPhone *)[UIApplication sharedApplication].delegate;
    fromRect = CGRectMake(fromRect.origin.x,
                          fromRect.origin.y - app.overViewController.calViewController._tableView.contentOffset.y  + app.overViewController.calViewController._tableView.top,
                          fromRect.size.width,
                          fromRect.size.height);
    
    double BottomHeight = 49;

    app.window.userInteractionEnabled = NO;
    
    //获取month calendar 的Image
    UIImage *oldImage = [PlannerClass getImageFromView:app.overViewController.scrollView size:app.overViewController.scrollView.frame.size];
    
    //获取上半部分的图片
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    topImgView.image = oldImage;
    topImgView.clipsToBounds = YES;
    topImgView.alpha = 1.0;
    topImgView.contentMode = UIViewContentModeTop;
    topImgView.frame = CGRectMake(0, 0, oldImage.size.width, fromRect.origin.y + fromRect.size.height);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(oldImage, 1.f)];
    [imageData writeToFile:[NSString stringWithFormat:@"%@topImage.jpg", [paths objectAtIndex:0]] atomically:YES];
    
    //获取下半部分的图片
    UIImageView *bottomImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    bottomImgView.image = oldImage;
    bottomImgView.clipsToBounds = YES;
    bottomImgView.contentMode = UIViewContentModeBottom;
    bottomImgView.alpha = 1.0;
    bottomImgView.frame = CGRectMake(0, topImgView.height, oldImage.size.width, oldImage.size.height - topImgView.height);
    
    
    //month->week
   [app.overViewController.view insertSubview:app.overViewController.overViewWeekView aboveSubview:app.overViewController.scrollView];
    UIView *superView = app.overViewController.overViewWeekView;
    
    
    //新页面
    UIImage *newImage = [PlannerClass getImageFromView:superView size:superView.frame.size];
    UIImageView *_topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _topImgView.image = newImage;
    _topImgView.clipsToBounds = YES;
    _topImgView.contentMode = UIViewContentModeTop;
    _topImgView.alpha = 1.0;
    _topImgView.frame = CGRectMake(0, topImgView.top + topImgView.height,
                                   newImage.size.width,
                                   [UIScreen mainScreen].bounds.size.height - 64 - BottomHeight);
    
    UIImageView *_bottomImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _bottomImgView.image = newImage;
    _bottomImgView.clipsToBounds = YES;
    _bottomImgView.contentMode = UIViewContentModeBottom;
    _bottomImgView.alpha = 1.0;
    _bottomImgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64 - BottomHeight,
                                      newImage.size.width, BottomHeight);
    
//    for (UIView *subView in superView.subviews) {
//        subView.hidden = YES;
//    }
    [superView addSubview:_topImgView];
    [superView addSubview:topImgView];
    [superView addSubview:bottomImgView];
    [superView addSubview:_bottomImgView];
    [app.overViewController.view bringSubviewToFront:app.overViewController.headerView];
    

    
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         bottomImgView.alpha = 0.0;
                         _topImgView.top = 0;
                         topImgView.top = -topImgView.height;
                         bottomImgView.top = oldImage.size.height;
//                         app.overViewController.monthLabel.text =
                     }
                     completion:^(BOOL finished){
                         [_topImgView removeFromSuperview];
                         [topImgView removeFromSuperview];
                         [bottomImgView removeFromSuperview];
                         [_bottomImgView removeFromSuperview];
                         app.window.userInteractionEnabled = YES;
//                         for (UIView *subView in superView.subviews) {
//                             subView.hidden = NO;
//                         }
                     }];
    
    [UIView animateWithDuration:0.1 animations:^{
        app.overViewController.headerView.frame=CGRectMake(0, -49, SCREEN_WIDTH, 44);
    }];
    
}

-(void)seeWeekCalendar
{
    
}
@end
