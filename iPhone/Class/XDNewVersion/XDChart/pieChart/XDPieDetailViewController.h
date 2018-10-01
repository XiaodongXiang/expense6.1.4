//
//  XDPieDetailViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/22.
//

#import <UIKit/UIKit.h>

#import "XDDateSelectedModel.h"
#import "Accounts.h"
@interface XDPieDetailViewController : UIViewController

@property(nonatomic, strong)NSArray * dataArray;

@property(nonatomic, strong)NSArray * dateArray;

@property(nonatomic, assign)NSInteger index;

@property(nonatomic, assign)DateSelectedType type;

@property(nonatomic, copy)NSString * pieType;

@property(nonatomic, strong)Accounts * account;

@end
