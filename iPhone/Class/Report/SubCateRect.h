//
//  SubCateRect.h
//  PocketExpense
//
//  Created by MV on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubCateRectDelegate;
 @interface SubCateRect : UIView {
     UILabel *nameLabel;
     UILabel *perLabel;
    
	 UIButton *selectedBtn;
     UIView    *percentView;
     UIImageView *selectedImg;
	// id <SubCateRectDelegate> delegate;
     UILabel                                 *colorLabel;

     NSInteger currentCCIndex;
}

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *perLabel;

@property (nonatomic, strong) UIButton *selectedBtn;
//@property (nonatomic, assign) id <SubCateRectDelegate> delegate;
@property (nonatomic, strong) UIImageView *selectedImg;
@property (nonatomic, strong) UIView    *percentView;
@property (nonatomic, assign)  NSInteger currentCCIndex;;
@property (nonatomic, strong) UILabel       *colorLabel;

-(void)selectedBtnAction;
-(void)setPercenViewByValue:(double)percent withColor:(UIColor *)percentColor ;
@end

@protocol SubCateRectDelegate

- (void)SubCateRectDelegate:(NSInteger)i withSelected:(BOOL)isSel withCCIndex:(NSInteger)index; 
@end