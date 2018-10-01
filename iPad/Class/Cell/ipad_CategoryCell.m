//
//  CategoryCell.m
//  Expense 5
//
//  Created by BHI_James on 4/19/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "ipad_CategoryCell.h"
 
@implementation ipad_CategoryCell
@synthesize nameLabel;
@synthesize bgImageView;
@synthesize headImageView;
@synthesize subShadowImageView;

@synthesize thisCellisEdit;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		self.backgroundView = bgImageView;
//        self.backgroundColor = [UIColor clearColor];

		headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9.0, 8.0, 28.0, 28.0)];
        [headImageView setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:headImageView];
 
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(46.0, 0.0, 200.0, 44.0)];
		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
		[nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
 		[self.contentView addSubview:nameLabel];
        
        
        //设置一个没有图片的imageView,这样底下就没有阴影了，之前的版本是有阴影的
 		subShadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,320, 12)];
		subShadowImageView.image =[UIImage imageNamed:@"111.png"];
		[self addSubview:subShadowImageView];
        
        self.thisCellisEdit = NO;
		
	}
    return self;
}

 
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    [self.contentView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    self.backgroundView.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
//    
//    if(self.thisCellisEdit){
//        headImageView.frame = CGRectMake(40, 6.0, 32.0, 32.0);
//        nameLabel.frame = CGRectMake(80.0, 0.0, 200.0, 44.0);
//    }
//    else
//    {
//        headImageView.frame = CGRectMake(10, 6.0, 32.0, 32.0);
//        nameLabel.frame = CGRectMake(50.0, 0.0, 200.0, 44.0);
//    }
//    
//
//}



@end
