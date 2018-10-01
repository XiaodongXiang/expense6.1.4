//
//  menuViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/10/14.
//
//

#import <UIKit/UIKit.h>
#import "footerView.h"

@interface menuViewController : UIViewController
@property(nonatomic,strong)UIViewController *selectedViewController;
@property (nonatomic,strong)NSMutableArray *navigationControllerArray;
-(void)setAvatarImage:(UIImage *)image;
-(void)reloadView;
-(void)startAnimation;
-(void)syncAnimationStop;

@end
