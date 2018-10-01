//
//  HMJCustomButtonView.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-12.
//
//

#import <UIKit/UIKit.h>

@interface HMJCustomButtonView : UIView
{
    UIButton *iconBtn;
    UIImageView *iconSelectedBg;
}
@property(nonatomic,strong)UIButton *iconBtn;
@property(nonatomic,strong)UIImageView *iconSelectedBg;
@end
