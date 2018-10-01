//
//  OverViewCell.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-13.
//
//

#import "OverViewCell.h"
#import "EventKitDataSource_week.h"
#import "OverViewWeekCalenderViewController.h"
#import "AppDelegate_iPhone.h"


#define THREEBTNWITH 156

@implementation OverViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        float screenWith = [UIScreen mainScreen].bounds.size.width;
        
        AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        
        _categoryIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
        _categoryIconImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_categoryIconImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 8, 150,20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor colorWithRed:94.f/255.f green:94.f/255.f blue:94.f/255.f alpha:1];
        [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        _accountNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 31, 250, 15)];
        _accountNameLabel.backgroundColor = [UIColor clearColor];
        _accountNameLabel.textColor = [UIColor colorWithRed:166/255.f green:166/255.f blue:166/255.f alpha:1];
        [_accountNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        _accountNameLabel.textAlignment = NSTextAlignmentLeft;
        _accountNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_accountNameLabel];
        
    
        _amountLabel=[[UILabel alloc]initWithFrame:CGRectMake(215, 17, SCREEN_WIDTH-230, 20)];
        _amountLabel.backgroundColor = [UIColor clearColor];
        [_amountLabel setFont:[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
        _amountLabel.textAlignment = NSTextAlignmentRight;
        _amountLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_amountLabel];
        
        //cycle
		_cycleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(140,27, 20, 20)];
		_cycleImageView.image = [UIImage imageNamed:@"icon_recurring_20_20.png"];
		_cycleImageView.hidden = YES;
		[self.contentView addSubview:_cycleImageView];
        
        //memo
		_memoImage = [[UIImageView alloc] initWithFrame:CGRectMake(140,30, 20, 20)];
		_memoImage.image = [UIImage imageNamed:@"icon_memo_20_20.png"];
		_memoImage.hidden = YES;
		[self.contentView addSubview:_memoImage];
        
        //photo
        _photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(160,32, 20, 20)];
		_photoImage.image = [UIImage imageNamed:@"icon_photo_20_20.png"];
		_photoImage.hidden = YES;
		[self.contentView addSubview:_photoImage];
        
        _thireeBtnContainView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 156, 53)];
        _thireeBtnContainView.backgroundColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
        [self.contentView addSubview:_thireeBtnContainView];
        
//        _threeBtnViewBgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  THREEBTNWITH, 60)];
//        _threeBtnViewBgImage.image = [UIImage imageNamed:@"cell_blue_124_60.png"];
//        [_thireeBtnContainView addSubview:_threeBtnViewBgImage];
        
        _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 23, 23)];
        [_searchBtn setImage:[UIImage imageNamed:@"sideslip_relation"] forState:UIControlStateNormal];
        [_thireeBtnContainView addSubview:_searchBtn];
        
        _duplicateBtn = [[UIButton alloc]initWithFrame:CGRectMake(68, 15, 23, 23)];
        [_duplicateBtn setImage:[UIImage imageNamed:@"sideslip_copy.png"] forState:UIControlStateNormal];
        [_thireeBtnContainView addSubview:_duplicateBtn];

        _deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(121, 15, 23,23)];
        [_deleteBtn setImage:[UIImage imageNamed:@"sideslip_delete.png"] forState:UIControlStateNormal];
        [_thireeBtnContainView addSubview:_deleteBtn];
        
        swipGestureFromLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [swipGestureFromLeft setDirection:UISwipeGestureRecognizerDirectionRight];
        swipGestureFromLeft.delegate = self;
        [self.contentView addGestureRecognizer:swipGestureFromLeft];
        
        swipGuetureFromRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [swipGuetureFromRight setDirection:UISwipeGestureRecognizerDirectionLeft];
        swipGuetureFromRight.delegate = self;
        [self.contentView addGestureRecognizer:swipGuetureFromRight];
        
        //设置背景图片
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(53, 53-EXPENSE_SCALE, SCREEN_WIDTH-53, EXPENSE_SCALE)];
        line.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
        [self.contentView addSubview:line];
        
        
    }
    return self;
}

-(void)moveCelltoRight{
    
    [_delegate setTableViewIndex:self.tag];
}

-(void)layoutShowTwoCellBtns:(BOOL)showThreeBtns{
    float threeBtnL = SCREEN_WIDTH - 156;
    
    if (showThreeBtns)
    {
        if (_thireeBtnContainView.frame.size.width==0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            _thireeBtnContainView.frame = CGRectMake(threeBtnL, _thireeBtnContainView.frame.origin.y, THREEBTNWITH, _thireeBtnContainView.frame.size.height);
            [UIView commitAnimations];
            
        }
    }
    else{
        if (_thireeBtnContainView.frame.size.width>0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            _thireeBtnContainView.frame = CGRectMake(SCREEN_WIDTH, _thireeBtnContainView.frame.origin.y, 0, _thireeBtnContainView.frame.size.height);
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
