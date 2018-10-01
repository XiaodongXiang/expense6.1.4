//
//  SearchCellCell.m
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-14.
//
//

#import "SearchCellCell.h"
#import "AccountSearchViewController.h"
#import "PokcetExpenseAppDelegate.h"

@implementation SearchCellCell

#define TWOBTNWITH 106

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
        //category
        _categoryIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15,12, 28, 28)];
        _categoryIcon.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_categoryIcon];
        
        //name
		_nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(53, 7, 120, 20)];
 		[_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
        [_nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
		[_nameLabel setTextAlignment:NSTextAlignmentLeft];
		[_nameLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:_nameLabel];
        
        //time
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 29, 120, 15)];
		[_timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [_timeLabel setTextColor:[UIColor colorWithRed:168.0/255 green:168.0/255 blue:168.0/255 alpha:1.0]];
		[_timeLabel setTextAlignment:NSTextAlignmentLeft];
		[_timeLabel setBackgroundColor:[UIColor clearColor]];
 		[self addSubview:_timeLabel];
        
        //photo
		_phontoImage = [[UIImageView alloc] initWithFrame:CGRectMake(160,29, 13, 11)];
		_phontoImage.image = [UIImage imageNamed:@"icon_photo.png"];
		_phontoImage.hidden = YES;
		[self.contentView addSubview:_phontoImage];
        
        //memo
        _memoImage = [[UIImageView alloc] initWithFrame:CGRectMake(140,29, 13, 11)];
		_memoImage.image = [UIImage imageNamed:@"icon_memo.png"];
		_memoImage.hidden = YES;
		[self.contentView addSubview:_memoImage];
        
        //amount
 		_spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-200, 16,200, 20)];
        [_spentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];

 		[_spentLabel setTextAlignment:NSTextAlignmentRight];
 		[_spentLabel setBackgroundColor:[UIColor clearColor]];
        [_spentLabel setTextColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
        _spentLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_spentLabel];
        
        _cellBtnContainView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 0, 53)];
        _cellBtnContainView.backgroundColor = [UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
        [self addSubview:_cellBtnContainView];
        
        _cellsearchBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 23, 23)];
        [_cellsearchBtn setImage:[UIImage imageNamed:@"sideslip_relation.png"] forState:UIControlStateNormal];
        [_cellBtnContainView addSubview:_cellsearchBtn];
        
        _cellDeleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(68, 15, 23, 23)];
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
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(53, 53-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
        line.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
        [self.contentView addSubview:line];

 	}
    return self;
}

-(void)moveCelltoRight{
    
    if (self.accountSearchViewController != nil) {
        if (self.accountSearchViewController.swipCellIndex == -1) {
            self.accountSearchViewController.swipCellIndex = _cellsearchBtn.tag;
            [self.accountSearchViewController.asvc_tableView  reloadData];
            
        }
        else{
            self.accountSearchViewController.swipCellIndex = nil;
            [self.accountSearchViewController.asvc_tableView reloadData];
        }
    }
}

-(void)layoutShowTwoCellBtns:(BOOL)showTwoBtns{
    float twoBtnLeft = SCREEN_WIDTH - 106;
    if (showTwoBtns) {
        if (_cellBtnContainView.frame.size.width==0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            _cellBtnContainView.frame = CGRectMake(twoBtnLeft, _cellBtnContainView.frame.origin.y, TWOBTNWITH, 53);
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
