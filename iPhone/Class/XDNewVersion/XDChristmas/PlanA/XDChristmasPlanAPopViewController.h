//
//  XDChristmasPlanAPopViewController.h
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDChristmasPlanAPopViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *getNowBtn;

-(void)show;
-(void)dismiss;

@end

NS_ASSUME_NONNULL_END
