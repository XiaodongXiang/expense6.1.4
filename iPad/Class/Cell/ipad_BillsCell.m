//
//  ipad_BillCell.m
//  PocketExpense
//
//  Created by Tommy on 11-4-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ipad_BillsCell.h"
#import "PokcetExpenseAppDelegate.h"
#import "Category.h"
#import "HMJButton.h"
#import "ipad_DateSelBillsViewController.h"

#define TWOBTNLEFT 462
#define TWOBTNWITH 104

@interface ipad_BillsCell (SubviewFrames)
@end

@implementation ipad_BillsCell
@synthesize categoryIconImage,nameLabel,amountLabel,dateLabel,memoImage;
@synthesize	bgImageView,paidStateImageView;
@synthesize twoBtnContainView,twoBtnContainViewImage,celleditBtn,celldeleteBtn,swipGestureFromLeft,swipGuetureFromRight,indePath,billViewController,iDateSelBillsViewController;
#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
	
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
//        bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 330, 60)];
//        self.backgroundView = bgImageView;
        
        //category
		categoryIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 28, 28)];
		categoryIconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:categoryIconImage];
        
        //name
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(203, 0, 218, 44)];
 		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
		[nameLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
      	[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:nameLabel];
        
        //amount
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(566-14-155, 0.0, 155.0, 44) ];
		[amountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
		[amountLabel setTextColor:[UIColor colorWithRed:94.f/255 green:99.f/255 blue:117.f/255 alpha:1.f]];
      	[amountLabel setTextAlignment:NSTextAlignmentRight];
		[amountLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:amountLabel];
		
        //date
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 0, 110.0, 44)];
		[dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
		[dateLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.f]];
      	[dateLabel setTextAlignment:NSTextAlignmentCenter];
		[dateLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:dateLabel];
        
        //memo
//		memoImage = [[UIImageView alloc] initWithFrame:CGRectMake(140,30, 20, 20)];
//		memoImage.image = [UIImage imageNamed:@"icon_memo.png"];
//		memoImage.hidden = YES;
//		[self.contentView addSubview:memoImage];
    
        //paid image
        paidStateImageView =[[UIImageView alloc] initWithFrame:CGRectMake(300,40, 8, 8)];
		paidStateImageView.hidden = YES;
		[self.contentView addSubview:paidStateImageView];
        
        twoBtnContainView = [[UIView alloc]initWithFrame:CGRectMake(566, 0, 0, 44)];
        twoBtnContainView.backgroundColor = [UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
        [self.contentView addSubview:twoBtnContainView];

        
        celleditBtn = [[HMJButton alloc]initWithFrame:CGRectMake(0, 0, 52, 44)];
        [celleditBtn setBackgroundImage:[UIImage imageNamed:@"sideslip_revise"] forState:UIControlStateNormal];
        [twoBtnContainView addSubview:celleditBtn];
        
        celldeleteBtn =[[HMJButton alloc]initWithFrame:CGRectMake(52, 0, 52, 44)];
        [celldeleteBtn setImage:[UIImage imageNamed:@"sideslip_delete"] forState:UIControlStateNormal];
        [twoBtnContainView addSubview:celldeleteBtn];
        
        swipGestureFromLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [swipGestureFromLeft setDirection:UISwipeGestureRecognizerDirectionRight];
        swipGestureFromLeft.delegate = self;
        [self.contentView addGestureRecognizer:swipGestureFromLeft];
        
        swipGuetureFromRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [swipGuetureFromRight setDirection:UISwipeGestureRecognizerDirectionLeft];
        swipGuetureFromRight.delegate = self;
        [self.contentView addGestureRecognizer:swipGuetureFromRight];
        
        self.backgroundColor = [UIColor clearColor];


	}
    return self;
}

-(void)moveCelltoRight{
    if (self.billViewController != nil) {
        
        if (self.billViewController.swipIndex == nil) {
            self.billViewController.swipIndex = self.indePath;
            [self.billViewController.myTableview reloadData];
        }
        else{
            self.billViewController.swipIndex = nil;
            [self.billViewController.myTableview reloadData];
        }
        
    }
    else if (self.iDateSelBillsViewController != nil)
    {
        if (self.iDateSelBillsViewController.swipIndex == nil) {
            self.iDateSelBillsViewController.swipIndex = self.indePath;
            [self.iDateSelBillsViewController.tableView reloadData];
            [self.billViewController.kalViewController.tableView reloadData];
        }
        else{
            self.iDateSelBillsViewController.swipIndex = nil;
            [self.iDateSelBillsViewController.tableView reloadData];
        }
    }
}

-(void)layoutShowTwoCellBtns:(BOOL)showTwoBtns{
    
    if (showTwoBtns) {
        if (twoBtnContainView.frame.size.width==0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            twoBtnContainView.frame = CGRectMake(TWOBTNLEFT, twoBtnContainView.frame.origin.y, TWOBTNWITH, twoBtnContainView.frame.size.height);
            [UIView commitAnimations];
            
        }
    }
    else{
        if (twoBtnContainView.frame.size.width>0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            twoBtnContainView.frame = CGRectMake(566, twoBtnContainView.frame.origin.y, 0, twoBtnContainView.frame.size.height);
            [UIView commitAnimations];
        }
    }
    
}

#pragma mark -
#pragma mark Memory management


@end
