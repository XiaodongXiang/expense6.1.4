//
//  PiChartView.h
//  Bill Buddy
//
//  Created by Tommy on 1/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


//----------------------------------Transaction 模块 的圆圈图标------------------------------------------------------
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class Category;
@interface PiChartViewItem : NSObject{
	NSString *cName;
	UIColor *cColor;
	double cData;
	double cPercent;
    UIImage *cImage;
    NSInteger indexOfMemArr;
    Category *category;
    NSMutableArray  *transactionArray;
}
@property (nonatomic, copy) NSString *cName;
@property (nonatomic, strong) UIColor *cColor;
@property (nonatomic, assign) double cData;
@property (nonatomic, assign) double cPercent;
@property (nonatomic, strong) UIImage *cImage;
@property (nonatomic, assign) NSInteger indexOfMemArr;
@property (nonatomic, strong)Category *category;
@property (nonatomic, strong)NSMutableArray  *transactionArray;


-(id)initWithName:(NSString *)n color:(UIColor *)c data:(double)d  ;
@end

@protocol PiChartViewDelegate;

@class ipad_ReportCategotyViewController;
@class ExpenseViewController;
@class CategoryViewController_iPad;

@interface PiChartView : UIView {
    NSMutableArray *catdataArray;
    NSMutableArray *catdataArray1;
    
    
    NSInteger clickIndex ;
    NSInteger delX;
    NSInteger delY;
    id <PiChartViewDelegate> delegate;
    BOOL canBetouch;
    
    ipad_ReportCategotyViewController *iReportCategotyViewController;
}

@property (nonatomic, strong) NSMutableArray *catdataArray;
@property (nonatomic, strong) NSMutableArray *catdataArray1;

@property (nonatomic, assign) NSInteger clickIndex;
@property (nonatomic, assign) NSInteger delX;
@property (nonatomic, assign) NSInteger delY;
@property (nonatomic, strong) id <PiChartViewDelegate> delegate;
@property (nonatomic, assign) BOOL canBetouch;
@property (nonatomic, assign) double    whiteCycleR;
@property (nonatomic, strong)ipad_ReportCategotyViewController *iReportCategotyViewController;
@property (nonatomic, strong)ExpenseViewController              *expenseViewController;
@property (nonatomic, strong)CategoryViewController_iPad       *categoryViewController;

- (void)setCateData:(NSMutableArray *)data;
- (void)setCateData1:(NSMutableArray *)data;

- (void)allocArray;
-(void)setOneCateArcByIndex:(NSInteger)i;

@end

@protocol PiChartViewDelegate

- (void)PiChartViewDelegateByIndex:(NSInteger) i;
@end