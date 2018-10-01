//
//  ColorLabelView.h
//  Check Buddy
//
//  Created by BHI_H03 on 2/22/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorLabelView : UIView 
{
	UILabel *colorLabel;
}
@property (nonatomic, strong) UILabel *colorLabel;

+ (CGFloat)viewWidth;
+ (CGFloat)viewHeight;

@end
