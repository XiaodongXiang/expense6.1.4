//
//  XDChristmasShareSuccessdPlanAPopViewController.h
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDChristmasShareSuccessdPlanAPopViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *useItBtn;

-(void)show;
-(void)dismiss;

@end

NS_ASSUME_NONNULL_END