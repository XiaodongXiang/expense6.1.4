//
//  OverViewBudgetPiCharView.h
//  PocketExpense
//
//  Created by humingjing on 14-3-25.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface OverViewBudgetPiCharView : UIView
{
    double availableAmount;
    double spent;
}
@property (nonatomic, assign) double availableAmount;
@property (nonatomic, assign)double spent;

@end
