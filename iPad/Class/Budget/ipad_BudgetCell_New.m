//
//  ipad_BudgetCell_New.m
//  PocketExpense
//
//  Created by Tommy on 11-4-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ipad_BudgetCell_New.h"
#import "PokcetExpenseAppDelegate.h"

@implementation ipad_BudgetCell_New
@synthesize bgImage,nameLabel,spentLabel,spentImageView,spentImageLeftArc,spentImageRightArc,totalImageView,totalImageLeftArc,totalImageRightArc;
@synthesize todayView;
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        self.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        UIImageView *selectedImageView =[[UIImageView alloc]initWithImage:[self imageWithColor:[UIColor colorWithRed:196/255.0 green:198/255.0 blue:199/255.0 alpha:1]]];
        self.selectedBackgroundView =  selectedImageView;
        
        
        _cateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 18, 28, 28)];
        [self.contentView addSubview:_cateImageView];
        
	 	nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 6, 300, 20)];
 		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
		[nameLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:nameLabel];
		
        spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 46, 310, 13)];
		[spentLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10]];
		[spentLabel setTextColor:[UIColor colorWithRed:94.0/255 green:99.0/255 blue:117.0/255 alpha:1.0]];
		[spentLabel setTextAlignment:NSTextAlignmentRight];
		[spentLabel setBackgroundColor:[UIColor clearColor]];
	 	[self.contentView addSubview:spentLabel];
        
        _budgetLabel=[[UILabel alloc]initWithFrame:CGRectMake(53, 27, 310, 13)];
        [_budgetLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10]];
        [_budgetLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
        [_budgetLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_budgetLabel];
        
        if (self.selected)
        {
            self.budgetBar.top.image=[UIImage imageNamed:@"iPad_budgetBar_list_select"];
        }
        else
        {
            self.budgetBar.top.image=[UIImage imageNamed:@"iPad_budgetBar_list"];
        }
    }
    return self;
}




@end
