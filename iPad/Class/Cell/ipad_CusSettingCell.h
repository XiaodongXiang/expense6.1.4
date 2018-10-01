//
//  ipad_CusSettingCell.h
//  PocketExpense
//
//  Created by MV on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ipad_CusSettingCell : UITableViewCell
{
    UILabel								*stringLabel;
    UIView *line1;
    UIView *line2;
    UIView *line3;
}

@property (nonatomic,strong) UILabel		 *stringLabel;
@property (nonatomic,strong)    UIView *line1;
@property (nonatomic,strong)  UIView *line2;
@property (nonatomic,strong)  UIView *line3;


@end
