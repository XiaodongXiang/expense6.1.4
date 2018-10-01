//
//  XDFirstPromptViewController.h
//  PocketExpense
//
//  Created by 下大雨 on 2018/7/9.
//

#import <UIKit/UIKit.h>

@interface XDFirstPromptViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

-(void)compltionSync;

-(void)failSync;

@end
