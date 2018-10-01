//
//  BillsCell.m
//  Bill Buddy
//
//  Created by Tommy on 1/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BillsCell.h"
#import "BillRule.h" 
#import "PokcetExpenseAppDelegate.h"
#import "Category.h"
#import "BillsViewController.h"
#import "AppDelegate_iPhone.h"
#import "UIViewAdditions.h"



@interface BillsCell (SubviewFrames)

@end

@implementation BillsCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        float cellWidth;
        if (ISPAD)
        {
            cellWidth=378;
        }
        else
        {
            cellWidth=SCREEN_WIDTH;
        }
        
        _categoryIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 28.0, 28.0)];
        _categoryIconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_categoryIconImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 7, 100, 20)];
        [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
        [_nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.f]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_nameLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 29.0, 164.0, 15)];
        [_dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [_dateLabel setTextColor:[UIColor colorWithRed:166.f/255 green:166.f/255 blue:166.f/255 alpha:1.f]];
        [_dateLabel setTextAlignment:NSTextAlignmentLeft];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_dateLabel];
        
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 16, cellWidth-230, 20)];
        _amountLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
        [_amountLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.f]];
        [_amountLabel setTextAlignment:NSTextAlignmentRight];
        [_amountLabel setBackgroundColor:[UIColor clearColor]];
        _amountLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_amountLabel];
        
        //memo
        _memoImage = [[UIImageView alloc] initWithFrame:CGRectMake(145,31, 13, 11)];
        _memoImage.image = [UIImage imageNamed:@"icon_memo.png"];
        _memoImage.hidden = YES;
        [self.contentView addSubview:_memoImage];
        
        _payIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(cellWidth-23, 35.0, 8, 8)];
        _payIconImage.contentMode = UIViewContentModeScaleAspectFit;
        _payIconImage.hidden = YES;
        [self.contentView addSubview:_payIconImage];
        
        _twoBtnContainView = [[UIView alloc]initWithFrame:CGRectMake(cellWidth, 0, 104, 53)];
        _twoBtnContainView.backgroundColor =  [UIColor colorWithRed:99/255.f green:203/255.f blue:255/255.f alpha:1];
        [self.contentView addSubview:_twoBtnContainView];

        
        _celleditBtn = [[HMJButton alloc]initWithFrame:CGRectMake(0, 0, 53, 53)];
        [_celleditBtn setImage:[UIImage imageNamed:@"sideslip_revise.png"] forState:UIControlStateNormal];
        [_twoBtnContainView addSubview:_celleditBtn];
        
        _celldeleteBtn =[[HMJButton alloc]initWithFrame:CGRectMake(68, 15, 23, 23)];
        [_celldeleteBtn setImage:[UIImage imageNamed:@"sideslip_delete.png"] forState:UIControlStateNormal];
        [_twoBtnContainView addSubview:_celldeleteBtn];
        
        _swipGestureFromLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [_swipGestureFromLeft setDirection:UISwipeGestureRecognizerDirectionRight];
        _swipGestureFromLeft.delegate = self;
        [self.contentView addGestureRecognizer:_swipGestureFromLeft];
        
        _swipGuetureFromRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [_swipGuetureFromRight setDirection:UISwipeGestureRecognizerDirectionLeft];
        _swipGuetureFromRight.delegate = self;
        [self.contentView addGestureRecognizer:_swipGuetureFromRight];
        
        float lineWidth;
        if (ISPAD)
        {
            lineWidth=378-53-15;
        }
        else
        {
            lineWidth=SCREEN_WIDTH-53;
        }
        _line2 = [[UIView alloc]initWithFrame:CGRectMake(53, 53-EXPENSE_SCALE, lineWidth, EXPENSE_SCALE)];
        _line2.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
        [self.contentView addSubview:_line2];
    }
    return self;
}



-(void)moveCelltoRight{
    
    
    if (self.billViewController != nil || self.iBillsViewController != nil ) {
        
        if (_viewType == 1) {
            if (self.billViewController.swipIndex == nil) {
                self.billViewController.swipIndex = self.indePath;
                [self.billViewController.bvc_tableView reloadData];
            }
            else{
                self.billViewController.swipIndex = nil;
                [self.billViewController.bvc_tableView reloadData];
            }
        }
        else if (_viewType == 2)
        {
            if (self.billViewController.swipIntergerCalendar == -1) {
                self.billViewController.swipIntergerCalendar = self.indePath.row;
                [self.billViewController.bvc_kalView.tableView reloadData];
            }
            else{
                self.billViewController.swipIntergerCalendar = -1;
                [self.billViewController.bvc_kalView.tableView reloadData];
            }
        }
        
    }
}

-(void)layoutShowTwoCellBtns:(BOOL)showTwoBtns{
    
    float width=0;
    if (ISPAD)
    {
        width=378;
    }
    else
    {
        width=SCREEN_WIDTH;
    }
    double  twoBtnWith = 104;
    double twoBtnLeft = width - twoBtnWith;
    if (showTwoBtns) {
        if (_twoBtnContainView.left>=width)
        {

            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            _twoBtnContainView.frame = CGRectMake(twoBtnLeft, _twoBtnContainView.frame.origin.y, twoBtnWith, _twoBtnContainView.frame.size.height);
            [UIView commitAnimations];
            
        }
    }
    else{
        if (_twoBtnContainView.frame.size.width>0)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            _twoBtnContainView.frame = CGRectMake(width, _twoBtnContainView.frame.origin.y, 0, _twoBtnContainView.frame.size.height);
            [UIView commitAnimations];

        }
    }
    
}


@end
