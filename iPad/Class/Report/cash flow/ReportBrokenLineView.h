//
//  ReportBrokenLineView.h
//  PocketExpense
//
//  Created by humingjing on 14-5-23.
//
//

#import <UIKit/UIKit.h>


@interface ReportBrokenLineView : UIView
{
    double          hightestAmount;
    double          lowestAmount;
    NSMutableArray *brokenLineDataArray;
    double          isIncome;
}

@property(nonatomic,assign) double hightestAmount;
@property(nonatomic,assign)double lowestAmount;
@property(nonatomic,strong)NSMutableArray  *brokenLineDataArray;
@property(nonatomic,assign) double          isIncome;

-(void)setArray;
@end
