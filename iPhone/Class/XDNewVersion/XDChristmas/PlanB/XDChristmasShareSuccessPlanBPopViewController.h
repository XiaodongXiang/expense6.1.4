//
//  XDChristmasShareSuccessPlanBPopViewController.h
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDChristmasShareSuccessPlanBPopViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *useItBtn;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;


-(void)show;
-(void)dismiss;
@end

NS_ASSUME_NONNULL_END
