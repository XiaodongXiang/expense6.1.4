//
//  SubCateRect.m
//  PocketExpense
//
//  Created by MV on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SubCateRect.h"
@implementation SubCateRect
@synthesize nameLabel,selectedBtn,selectedImg,perLabel,percentView;
@synthesize currentCCIndex;
@synthesize colorLabel;
- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
    {
        
//        UIImageView *iconbgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subcategory_sel_bg_18_18.png"]];
//        [iconbgView setFrame:CGRectMake(132, 1, 18, 18)];
//        [self addSubview:iconbgView];
//        [iconbgView release];
        
        selectedImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subcategory_sel_OK_bg_18_18.png"]];
        [selectedImg setFrame:CGRectMake(132, 1, 18, 18)];
        //[self addSubview:selectedImg];
  
        colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(2,2, 12, 12)];
		[colorLabel setTextColor:[UIColor clearColor]];
		[colorLabel setTextAlignment:NSTextAlignmentRight];
		[colorLabel setBackgroundColor:[UIColor clearColor]];
		[self  addSubview:colorLabel];

        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0, 60, 20)];
		[nameLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        nameLabel.textAlignment = NSTextAlignmentLeft;
		[nameLabel setTextColor:[UIColor colorWithRed:122.0/255.f green:122.0/255.f  blue:122.0/255.f  alpha:1.f]];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
		[self addSubview:nameLabel];
		
        perLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 60,20)];
		[perLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        perLabel.textAlignment = NSTextAlignmentRight;
		[perLabel setTextColor:[UIColor colorWithRed:204.0/255.f green:204.0/255.f  blue:204.0/255.f  alpha:1.f]];
		[perLabel setBackgroundColor:[UIColor clearColor]];
		[self addSubview:perLabel];
        
	 	selectedBtn =[UIButton buttonWithType:UIButtonTypeCustom] ;
        [selectedBtn setFrame:CGRectMake(0, 0, 150, 20)];
  		[self addSubview:selectedBtn];
        selectedBtn.hidden = YES;
		//[selectedBtn addTarget:self action:@selector(selectedBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0.0, 0.0, 18.0, 18.0)];
		imageView.image = [UIImage imageNamed:@"color_cover.png"];
		[self addSubview:imageView];

        self.backgroundColor = [UIColor clearColor];
        
 	}
	return self;
}

-(void)setPercenViewByValue:(double)percent withColor:(UIColor *)percentColor;
{

}

-(void)selectedBtnAction
{
    selectedImg.hidden = !selectedImg.hidden;
 //	[self.delegate SubCateRectDelegate:self.tag withSelected: !selectedImg.hidden withCCIndex:currentCCIndex];
    
}





@end

