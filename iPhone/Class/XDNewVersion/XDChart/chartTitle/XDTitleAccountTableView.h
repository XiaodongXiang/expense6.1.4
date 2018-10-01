//
//  XDTitleAccountTableView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/22.
//

#import <UIKit/UIKit.h>

@class Accounts;
@protocol XDTitleAccountTableViewDelegate <NSObject>
-(void)returnSelectedAccount:(Accounts*)account;
@end

@interface XDTitleAccountTableView : UITableView

+(instancetype)view;

@property(nonatomic, weak)id<XDTitleAccountTableViewDelegate> selectedDelegate;

-(void)refreshUI;

@end
