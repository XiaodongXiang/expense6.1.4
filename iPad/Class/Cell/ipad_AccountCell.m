//
//  ipad_AccountCell.m
//  PocketExpense
//
//  Created by Tommy on 11-4-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ipad_AccountCell.h"
#import "AppDelegate_iPad.h"
#import "ipad_MainViewController.h"

#define DELETEBTN_ORIGNX1 -30
#define DELETEBTN_ORIGNX2 16
#define DETAILBTN_ORIGNX1 271
#define DETAILBTN_ORIGNX2 180

#define NAMELABLE_ORIGNX1 46
#define NAMELABEL_ORIGNX2 18
#define BALANCELABEL_ORIGNX1 185
#define BALANCELABEL_ORIGNX2 0

@implementation ipad_AccountCell
@synthesize nameLabel;
@synthesize blanceLabel;
@synthesize titleLabel;
@synthesize typeImageView;
@synthesize deleteBtn,detailBtn;
@synthesize iAccountViewController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  isVModule:(BOOL)isV{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        
        
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ipad_cell_330_60.png"]];
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ipad_cell_330_60_sel.png"]];
        
        typeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
        [self.contentView addSubview:typeImageView];
        
        
 		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0, 1.0, 135.0, 35.0)];
		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
		[nameLabel setTextColor:[appDelegate.epnc getAmountBlackColor]];
 		[self.contentView addSubview:nameLabel];
		
        
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0, 27.0, 135.0, 25.0)];
		[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [titleLabel setTextColor:[appDelegate.epnc getAmountGrayColor]];
        [titleLabel setHighlightedTextColor:[UIColor colorWithRed:139.0/255 green:140.0/255 blue:140.0/255 alpha:1]];
		[titleLabel setTextAlignment:NSTextAlignmentLeft];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
 		[self.contentView addSubview:titleLabel];

        
 		blanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(185.0,0.0, 130.0, 60.0)];
		[blanceLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
 		[blanceLabel setTextAlignment:NSTextAlignmentRight];
		[blanceLabel setBackgroundColor:[UIColor clearColor]];
        //文字自适应大小
        blanceLabel.adjustsFontSizeToFitWidth = YES;
		[self addSubview:blanceLabel];
        
        deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(11, 0, 30, 60)];
        [deleteBtn setImage:[UIImage imageNamed:@"icon_delete_30_30.png"] forState:UIControlStateNormal];
        [deleteBtn setBackgroundColor:[UIColor clearColor]];
        deleteBtn.hidden = YES;
        [self addSubview:deleteBtn];
        
        detailBtn =[[UIButton alloc]initWithFrame:CGRectMake(DETAILBTN_ORIGNX1, 0, 60, 60)];
        detailBtn.hidden = YES;
        [detailBtn setImage:[UIImage imageNamed:@"icon_Contact_Info.png"] forState:UIControlStateNormal];
        detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.contentView addSubview:detailBtn];
        
        self.backgroundColor = [UIColor whiteColor];

        }
    return self;
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    self.backgroundColor = [UIColor whiteColor];

    if (self.editing == editing)
	{
        
        if ([self.iAccountViewController.accountArray count]>1 && self.tag==0)
        {
            [self noEditState];
        }
        
        if (!editing) {
            [self noEditState];
        }

		return;
	}
	
	[super setEditing:editing animated:animated];
    if (editing && self.iAccountViewController.tableViewEditState)
    {
        typeImageView.alpha = 0;
        deleteBtn.hidden = NO;
        deleteBtn.frame = CGRectMake(DELETEBTN_ORIGNX2, 0, 30, 60);
        detailBtn.frame = CGRectMake(DETAILBTN_ORIGNX2, 0, 60, 60);
        nameLabel.frame = CGRectMake(NAMELABEL_ORIGNX2, nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height);
        titleLabel.frame = CGRectMake(NAMELABEL_ORIGNX2, titleLabel.frame.origin.y, titleLabel.frame.size.width, titleLabel.frame.size.height);
        blanceLabel.hidden = YES;
        blanceLabel.frame = CGRectMake(BALANCELABEL_ORIGNX2, blanceLabel.frame.origin.y, blanceLabel.frame.size.width, blanceLabel.frame.size.height);
        detailBtn.hidden = NO;
    }
    else
    {
        typeImageView.alpha = 1;
        deleteBtn.hidden = YES;
        deleteBtn.frame = CGRectMake(DELETEBTN_ORIGNX1, 0, 30, 60);
        detailBtn.frame = CGRectMake(DETAILBTN_ORIGNX1, 0, 60, 60);
        nameLabel.frame = CGRectMake(NAMELABLE_ORIGNX1, nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height);
        titleLabel.frame = CGRectMake(NAMELABLE_ORIGNX1, titleLabel.frame.origin.y, titleLabel.frame.size.width, titleLabel.frame.size.height);
        blanceLabel.frame = CGRectMake(BALANCELABEL_ORIGNX1, blanceLabel.frame.origin.y, blanceLabel.frame.size.width, blanceLabel.frame.size.height);
        blanceLabel.hidden = NO;
        detailBtn.hidden = YES;

    }
}

-(void)noEditState
{
    [super setEditing:NO animated:NO];
//    self.backgroundColor = [UIColor whiteColor];

    typeImageView.alpha = 1;
    deleteBtn.hidden = YES;
    deleteBtn.frame = CGRectMake(DELETEBTN_ORIGNX1, 0, 30, 60);
    detailBtn.frame = CGRectMake(DETAILBTN_ORIGNX1, 0, 60, 60);
    nameLabel.frame = CGRectMake(NAMELABLE_ORIGNX1, nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height);
    titleLabel.frame = CGRectMake(NAMELABLE_ORIGNX1, titleLabel.frame.origin.y, titleLabel.frame.size.width, titleLabel.frame.size.height);
    blanceLabel.frame = CGRectMake(BALANCELABEL_ORIGNX1, blanceLabel.frame.origin.y, blanceLabel.frame.size.width, blanceLabel.frame.size.height);
    blanceLabel.hidden = NO;
    detailBtn.hidden = YES;

}

@end
