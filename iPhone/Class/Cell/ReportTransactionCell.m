//
//  ReportTransactionCell.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-26.
//
//

#import "ReportTransactionCell.h"
#import "CashDetailTransactionViewController.h"
#import "AppDelegate_iPhone.h"
#import "EPNormalClass.h"

#define TWOBTNWITH 100

@implementation ReportTransactionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 1, 150, 30)];
        [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0]];
		[_nameLabel setTextAlignment:NSTextAlignmentLeft];
		[_nameLabel setBackgroundColor:[UIColor clearColor]];
		[_nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
 		[self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, 100, 20)];
        [_timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
		[_timeLabel setTextAlignment:NSTextAlignmentLeft];
		[_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setTextColor:[UIColor colorWithRed:172.0/255 green:173.0/255 blue:178.0/255 alpha:1]];
        [self.contentView addSubview:_timeLabel];
        
        AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        _amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(205, 0, SCREEN_WIDTH-220, 50)];
        [_amountLabel setFont:[appDelegate_iPhone.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
 		[_amountLabel setTextAlignment:NSTextAlignmentRight];
		[_amountLabel setBackgroundColor:[UIColor clearColor]];
 		[_amountLabel setTextColor:[UIColor colorWithRed:255.0/255 green:93.0/255 blue:103.0/255 alpha:1]];
		[self.contentView addSubview:_amountLabel];

        _twoBtnContainView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 100, 50)];
        _twoBtnContainView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_twoBtnContainView];
        
        _twoBtnContainImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
        _twoBtnContainImage.image = [UIImage imageNamed:@"cell_blue_100_60.png"];
        [_twoBtnContainView addSubview:_twoBtnContainImage];
        
        _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 40, 50)];
        [_searchBtn setImage:[UIImage imageNamed:@"icon_search1_30_30.png"] forState:UIControlStateNormal];
        [_twoBtnContainView addSubview:_searchBtn];
        
        _deleteBtn =[[UIButton alloc]initWithFrame:CGRectMake(46, 0, 50, 50)];
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_delete1_30_30.png"] forState:UIControlStateNormal];
        [_twoBtnContainView addSubview:_deleteBtn];
        
        _swipGestureFromLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [_swipGestureFromLeft setDirection:UISwipeGestureRecognizerDirectionRight];
        _swipGestureFromLeft.delegate = self;
        [self.contentView addGestureRecognizer:_swipGestureFromLeft];
        
        _swipGuetureFromRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [_swipGuetureFromRight setDirection:UISwipeGestureRecognizerDirectionLeft];
        _swipGuetureFromRight.delegate = self;
        [self.contentView addGestureRecognizer:_swipGuetureFromRight];
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(15, 50-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
        _line.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
        [self.contentView addSubview:_line];
    }
    return self;
}

-(void)moveCelltoRight{
    
    if (self.cashDetailViewController != nil){
        if (self.cashDetailViewController.swipCellIndex == -1) {
            self.cashDetailViewController.swipCellIndex = self.tag;
            [self.cashDetailViewController.ctvc_tableView reloadData];
        }
        else{
            self.cashDetailViewController.swipCellIndex = -1;
            [self.cashDetailViewController.ctvc_tableView reloadData];
        }

    }
}

-(void)layoutShowTwoCellBtns:(BOOL)showTwoBtns{
    double leftX = SCREEN_WIDTH - TWOBTNWITH;
    if (showTwoBtns) {
        if (_twoBtnContainView.frame.size.width==0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            _twoBtnContainView.frame = CGRectMake(leftX, _twoBtnContainView.frame.origin.y, TWOBTNWITH, _twoBtnContainView.frame.size.height);
            [UIView commitAnimations];
            
        }
    }
    else{
        if (_twoBtnContainView.frame.size.width>0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            _twoBtnContainView.frame = CGRectMake(SCREEN_WIDTH, _twoBtnContainView.frame.origin.y, 0, _twoBtnContainView.frame.size.height);
            [UIView commitAnimations];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
