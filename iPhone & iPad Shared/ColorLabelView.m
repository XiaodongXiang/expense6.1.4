//
//  ColorLabelView.m
//  Check Buddy
//
//  Created by BHI_H03 on 2/22/10.
//  Copyright 2010 BHI. All rights reserved.
//

//-------------------------------this is maybe Trans模块中 cell前面的颜色label----------------------------------------
#import "ColorLabelView.h"

#define MAIN_FONT_SIZE 18
#define MIN_MAIN_FONT_SIZE 16

@implementation ColorLabelView
@synthesize colorLabel;

const CGFloat kViewWidth = 280;
const CGFloat kViewHeight = 44;

+ (CGFloat)viewWidth
{
    return kViewWidth;
}

+ (CGFloat)viewHeight 
{
    return kViewHeight;
}

- (id)initWithFrame:(CGRect)frame
{
	// use predetermined frame size
	if (self = [super initWithFrame:CGRectMake(0.0, 0.0, kViewWidth, kViewHeight)])
	{
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor clearColor];	// make the background transparent
		colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kViewWidth, kViewHeight)];
		[colorLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]];

 		[colorLabel setFont:[UIFont fontWithName:@"Arial" size:17.0]];
		[colorLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
		[colorLabel setTextColor:[UIColor colorWithRed:46.f/255 green:46.f/255 blue:46.f/255 alpha:1.f]];
		[colorLabel setBackgroundColor:[UIColor clearColor]];
		[colorLabel setTextAlignment:NSTextAlignmentLeft];
		[self addSubview:colorLabel];
	}
	return self;
}



@end
