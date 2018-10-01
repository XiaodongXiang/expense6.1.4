//
//  Expense.m
//  PokcetExpense
//
//  Created by ZQ on 9/27/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "ExpenseCell.h"
#import "AccountTranscationViewController.h"
#import "HMJButton.h"
#import "PokcetExpenseAppDelegate.h"


@implementation ExpenseCell

#define TWOBTNWITH 156

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
	{
        PokcetExpenseAppDelegate *appdelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

        //category
        _categoryIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15,12, 28, 28)];
        _categoryIcon.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_categoryIcon];
        
        //name
		_nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(53, 9, 200, 20)];
 		[_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
        [_nameLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
		[_nameLabel setTextAlignment:NSTextAlignmentLeft];
		[_nameLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:_nameLabel];

        //time
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 29, 150, 15)];
		[_timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [_timeLabel setTextColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0]];
		[_timeLabel setTextAlignment:NSTextAlignmentLeft];
		[_timeLabel setBackgroundColor:[UIColor clearColor]];
 		[self addSubview:_timeLabel];
    
        _cycleImage = [[UIImageView alloc] initWithFrame:CGRectMake(140,33, 13, 11)];
        _cycleImage.image = [UIImage imageNamed:@"icon_cycle.png"];
        _cycleImage.hidden = YES;
        [self.contentView addSubview:_cycleImage];
        
        //memo
		_memoImage = [[UIImageView alloc] initWithFrame:CGRectMake(160,33, 13, 11)];
		_memoImage.image = [UIImage imageNamed:@"icon_memo.png"];
		_memoImage.hidden = YES;
		[self.contentView addSubview:_memoImage];
        
        //photo
        _photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(180,33, 13, 11)];
		_photoImage.image = [UIImage imageNamed:@"icon_photo.png"];
		_photoImage.hidden = YES;
		[self.contentView addSubview:_photoImage];

        //amount
 		_spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 9, SCREEN_WIDTH-230, 20)];
        _spentLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
 		[_spentLabel setTextAlignment:NSTextAlignmentRight];
 		[_spentLabel setBackgroundColor:[UIColor clearColor]];
        [_spentLabel setTextColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
        _spentLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_spentLabel];
        [_spentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
		
        //clear btn
        _clearBtn = [[ClearCusBtn alloc] init];
        _clearBtn.frame = CGRectMake(0, 0, 53, 53);
        [_clearBtn setImage:[UIImage imageNamed:@"icon_check3_sel.png"] forState:UIControlStateSelected];
        [_clearBtn setImage:[UIImage imageNamed:@"icon_check3.png"] forState:UIControlStateNormal];
        _clearBtn.hidden = YES;
         [self addSubview:_clearBtn];
        
        _runningBalaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 29.0, SCREEN_WIDTH-230, 15)];
//        [_runningBalaceLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13]];
        [_runningBalaceLabel setTextColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0]];
 		[_runningBalaceLabel setTextAlignment:NSTextAlignmentRight];
 		[_runningBalaceLabel setBackgroundColor:[UIColor clearColor]];
        _runningBalaceLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_runningBalaceLabel];
        _runningBalaceLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];


        _cellBtnContainView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 0, 53)];
        _cellBtnContainView.backgroundColor = [UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
        [self addSubview:_cellBtnContainView];

        
        
        _cellsearchBtn = [[HMJButton alloc]initWithFrame:CGRectMake(15, 15, 23, 23)];
        [_cellsearchBtn setImage:[UIImage imageNamed:@"sideslip_relation.png"] forState:UIControlStateNormal];
        [_cellBtnContainView addSubview:_cellsearchBtn];
        
        _cellDuplicateBtn = [[HMJButton alloc]initWithFrame:CGRectMake(68, 15, 23, 23)];
        [_cellDuplicateBtn setImage:[UIImage imageNamed:@"sideslip_copy.png"] forState:UIControlStateNormal];
        [_cellBtnContainView addSubview:_cellDuplicateBtn];
        
        _cellDeleteBtn = [[HMJButton alloc]initWithFrame:CGRectMake(121, 15, 23, 23)];
        [_cellDeleteBtn setImage:[UIImage imageNamed:@"sideslip_delete.png"] forState:UIControlStateNormal];
        [_cellBtnContainView addSubview:_cellDeleteBtn];
        
        
        
        
        _swipGestureFromLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [_swipGestureFromLeft setDirection:UISwipeGestureRecognizerDirectionRight];
        _swipGestureFromLeft.delegate = self;
        [self.contentView addGestureRecognizer:_swipGestureFromLeft];
        
        _swipGuetureFromRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [_swipGuetureFromRight setDirection:UISwipeGestureRecognizerDirectionLeft];
        _swipGuetureFromRight.delegate = self;
        [self.contentView addGestureRecognizer:_swipGuetureFromRight];
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(53, 53-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
        _line.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [self.contentView addSubview:_line];
        //设置背景图片
//        UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_320_60.png"]];
//        UIImageView *selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        selectedImageView.image = [UIImage imageNamed:@"cell_320_60_sel.png"];
//        [self setBackgroundView:bgImageView];
//        [self setSelectedBackgroundView:selectedImageView];
//        [bgImageView release];
//        [selectedImageView release];

 	}
    return self;
}

-(void)moveCelltoRight{
   
        if (self.accountTransactionViewController != nil) {
        if (self.accountTransactionViewController.swipCellIndex == nil) {
            self.accountTransactionViewController.swipCellIndex = _cellDuplicateBtn.btnIndex;
            [self.accountTransactionViewController.mytableview reloadData];
            
        }
        else{
            self.accountTransactionViewController.swipCellIndex = nil;
            [self.accountTransactionViewController.mytableview reloadData];
        }
    }
}

-(void)layoutShowTwoCellBtns:(BOOL)showTwoBtns{
    float TWOBTNLEFT = SCREEN_WIDTH - 156;
    if (showTwoBtns) {
        if (_cellBtnContainView.frame.size.width==0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            _cellBtnContainView.frame = CGRectMake(TWOBTNLEFT, _cellBtnContainView.frame.origin.y, TWOBTNWITH, 53);
            [UIView commitAnimations];
            
        }
    }
    else{
        if (_cellBtnContainView.frame.size.width>0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            _cellBtnContainView.frame = CGRectMake(SCREEN_WIDTH, _cellBtnContainView.frame.origin.y, 0, _cellBtnContainView.frame.size.height);
            [UIView commitAnimations];
        }
    }
}



@end
