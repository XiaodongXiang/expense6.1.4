//
//  ReleatedCell.m
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-14.
//
//

#import "ReleatedCell.h"
#import "SearchRelatedViewController.h"
#import "PokcetExpenseAppDelegate.h"


#define TWOBTNWITH 100

@implementation ReleatedCell
@synthesize nameLabel,blanceLabel,bgImageView,cateIcon,twoBtnContainView,twoBtnContainViewImage,cellcopyBtn,celldeleteBtn,searchRelatedViewController,swipGestureFromLeft,swipGuetureFromRight;
@synthesize memoIcon,phonteIcon,dateTimeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float screenWith = [UIScreen mainScreen].bounds.size.width;
        
//        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWith, 60.0)];
//        self.backgroundView = bgImageView;
        
        cateIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
        cateIcon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:cateIcon];
        
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 12, 200, 30)];
		[nameLabel setFont:[UIFont fontWithName:FontSFUITextRegular size:16.0]];
		[nameLabel setTextAlignment:NSTextAlignmentLeft];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
		[nameLabel setTextColor:[UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1]];
 		[self.contentView addSubview:nameLabel];
 		
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
 		blanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 0.0, SCREEN_WIDTH-230, 70.0)];
        [blanceLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
 		[blanceLabel setTextAlignment:NSTextAlignmentRight];
		[blanceLabel setBackgroundColor:[UIColor clearColor]];
 		[blanceLabel setTextColor:[UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1]];
        blanceLabel.adjustsFontSizeToFitWidth = YES;
		[self.contentView addSubview:blanceLabel];
        
        dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 32, 164.0, 25.0)];
        dateTimeLabel.backgroundColor = [UIColor clearColor];
        dateTimeLabel.textColor = [UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1];
        [dateTimeLabel setFont:[UIFont fontWithName:FontSFUITextRegular size:14]];
        dateTimeLabel.textAlignment = NSTextAlignmentLeft;
        dateTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:dateTimeLabel];
        
        memoIcon = [[UIImageView alloc]initWithFrame:CGRectMake(140, 30, 20, 20)];
        memoIcon.image = [UIImage imageNamed:@"icon_memo_20_20.png"];
        memoIcon.hidden = YES;
        [self.contentView addSubview:memoIcon];
        
        phonteIcon = [[UIImageView alloc]initWithFrame:CGRectMake(160, 30, 20, 20)];
        phonteIcon.image = [UIImage imageNamed:@"icon_photo_20_20.png"];
        phonteIcon.hidden = YES;
        [self.contentView addSubview:phonteIcon];
        
        [blanceLabel setFont:[appDelegate.epnc  getMoneyFont_exceptInCalendar_WithSize:16]];
 		[blanceLabel setTextAlignment:NSTextAlignmentRight];
		[blanceLabel setBackgroundColor:[UIColor clearColor]];
 		[blanceLabel setTextColor:[UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1]];
		[self.contentView addSubview:blanceLabel];
        
        
//        twoBtnContainView = [[UIView alloc]initWithFrame:CGRectMake(screenWith, 0, 100, 60)];
//        twoBtnContainView.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:twoBtnContainView];
        
        twoBtnContainViewImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
        twoBtnContainViewImage.image = [UIImage imageNamed:@"cell_blue_100_60.png"];
        [twoBtnContainView addSubview:twoBtnContainViewImage];
        
        cellcopyBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 40, 60)];
        [cellcopyBtn setImage:[UIImage imageNamed:@"icon_copy1_30_30.png"] forState:UIControlStateNormal];
        [twoBtnContainView addSubview:cellcopyBtn];
        
        celldeleteBtn =[[UIButton alloc]initWithFrame:CGRectMake(46, 0, 50, 60)];
        [celldeleteBtn setImage:[UIImage imageNamed:@"icon_delete1_30_30.png"] forState:UIControlStateNormal];
        [twoBtnContainView addSubview:celldeleteBtn];
        
        swipGestureFromLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [swipGestureFromLeft setDirection:UISwipeGestureRecognizerDirectionRight];
        swipGestureFromLeft.delegate = self;
        [self.contentView addGestureRecognizer:swipGestureFromLeft];
        
        swipGuetureFromRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [swipGuetureFromRight setDirection:UISwipeGestureRecognizerDirectionLeft];
        swipGuetureFromRight.delegate = self;
        [self.contentView addGestureRecognizer:swipGuetureFromRight];
        
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 69.5, SCREEN_WIDTH-15, 0.5)];
//        line.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:line];
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(46, 60-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
//        line.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
//        [self.contentView addSubview:line];
    }
    return self;
}

-(void)moveCelltoRight{
    
    
    if (self.searchRelatedViewController != nil) {
        if (self.searchRelatedViewController.swipCellIndex == -1) {
            self.searchRelatedViewController.swipCellIndex = self.tag;
            [self.searchRelatedViewController.myTableView reloadData];
        }
        else{
            self.searchRelatedViewController.swipCellIndex = -1;
            [self.searchRelatedViewController.myTableView reloadData];
        }

            }
}

-(void)layoutShowTwoCellBtns:(BOOL)showTwoBtns{
    float twoBtnWith = SCREEN_WIDTH-100;
    blanceLabel.hidden = NO;
    float screenWith = [UIScreen mainScreen].bounds.size.width;

    if (showTwoBtns) {
        if (twoBtnContainView.frame.size.width==0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            twoBtnContainView.frame = CGRectMake(twoBtnWith, twoBtnContainView.frame.origin.y, TWOBTNWITH, twoBtnContainView.frame.size.height);
            [UIView commitAnimations];
            
        }
    }
    else{
        if (twoBtnContainView.frame.size.width>0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            twoBtnContainView.frame = CGRectMake(screenWith, twoBtnContainView.frame.origin.y, 0, twoBtnContainView.frame.size.height);
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
