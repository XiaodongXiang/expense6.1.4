//
//  avatorImageView.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/10/23.
//
//

#import <UIKit/UIKit.h>

@interface avatorImageView : UIImageView
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *pathColor;
@property float pathWidth;
@end
