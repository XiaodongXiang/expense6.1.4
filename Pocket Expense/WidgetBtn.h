//
//  WidgetBtn.h
//  widget
//
//  Created by 晓东项 on 2018/8/10.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "Payee.h"
@interface WidgetBtn : UIButton

@property(nonatomic, strong)Category* category;
@property(nonatomic, strong)Payee* payee;

@property(nonatomic, strong)UIImageView* categoryImageView;
@property(nonatomic, strong)UILabel* categoryLabel;

@end
