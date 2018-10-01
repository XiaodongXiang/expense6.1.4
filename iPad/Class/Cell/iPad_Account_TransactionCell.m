//
//  iPad_Account_TransactionCell.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-9-30.
//
//

#import "iPad_Account_TransactionCell.h"
#import "ipad_AccountViewController.h"
#import "ClearCusBtn.h"
#import "PokcetExpenseAppDelegate.h"

#define TWOBTNLEFT_IPAD 410
#define TWOBTNWITH_IPAD 156



@implementation iPad_Account_TransactionCell
@synthesize clearBtn,categoryIcon,timeLabel,payeeLabel,memoLabel,cycleImage,photoImageView,spentLabel,runningBalanceLabel;
@synthesize threeBtnContainView,threeBtnViewBgImage,cellSearchBtn,cellDeleteBtn,cellDuplicateBtn,swipGestureFromLeft,swipGuetureFromRight;
@synthesize accountViewController_iPad;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0,705,50)];
//        self.backgroundView = bgImageView;
		
        categoryIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 28, 28)];
        [self.contentView addSubview:categoryIcon];
        
        timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(58, 0, 113, 44)];
		[timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
		[timeLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
		[timeLabel setTextAlignment:NSTextAlignmentCenter];
 		[self.contentView addSubview:timeLabel];
        
        payeeLabel =[[UILabel alloc] initWithFrame:CGRectMake(58+113+15, 13, 68, 17)];
        [payeeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
 		[payeeLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
		[payeeLabel setTextAlignment:NSTextAlignmentLeft];
		[payeeLabel setBackgroundColor:[UIColor clearColor]];
 		[self.contentView addSubview:payeeLabel];

		memoLabel=[[UILabel alloc] initWithFrame:CGRectMake(162, 17, 160, 22.0)];
        [memoLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
 		[memoLabel setTextColor:[appDelegate.epnc getiPADColor_149_150_156]];
		[memoLabel setTextAlignment:NSTextAlignmentLeft];
		[memoLabel setBackgroundColor:[UIColor clearColor]];
 		[self.contentView addSubview:memoLabel];
        
        cycleImage = [[UIImageView alloc] initWithFrame:CGRectMake(58+168+113-15-20,17, 13, 11)];
        cycleImage.image = [UIImage imageNamed:@"icon_cycle.png"];
        cycleImage.hidden = YES;
        [self.contentView addSubview:cycleImage];
        
        photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(58+168+113-15,17, 13, 11)];
		photoImageView.image = [UIImage imageNamed:@"icon_photo.png"];
		photoImageView.hidden = YES;
		[self.contentView addSubview:photoImageView];

		spentLabel = [[UILabel alloc] initWithFrame:CGRectMake(58+113+168+114-15-100, 0, 100, 44)];
		[spentLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
 		[spentLabel setTextAlignment:NSTextAlignmentRight];
 		[spentLabel setBackgroundColor:[UIColor clearColor]];
        spentLabel.adjustsFontSizeToFitWidth = YES;
  		[self.contentView addSubview:spentLabel];
        
        runningBalanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(566-15-100, 0, 100, 44)];
		[runningBalanceLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
 		[runningBalanceLabel setTextAlignment:NSTextAlignmentRight];
 		[runningBalanceLabel setBackgroundColor:[UIColor clearColor]];
        runningBalanceLabel.adjustsFontSizeToFitWidth = YES;
  		[self.contentView addSubview:runningBalanceLabel];

        clearBtn = [[ClearCusBtn alloc] init];
        clearBtn.frame = CGRectMake(15, 8, 28, 28);
        [clearBtn setImage:[UIImage imageNamed:@"icon_check3_sel.png"] forState:UIControlStateSelected];
        [clearBtn setImage:[UIImage imageNamed:@"icon_check3.png"] forState:UIControlStateNormal];
        clearBtn.hidden = YES;
        [self addSubview:clearBtn];
       
        

        
        
        
        threeBtnContainView = [[UIView alloc]initWithFrame:CGRectMake(566, 0, 0, 44)];
        threeBtnContainView.backgroundColor = [UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
        [self.contentView addSubview:threeBtnContainView];
        
        cellSearchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 52, 44)];
        [cellSearchBtn setImage:[UIImage imageNamed:@"sideslip_relation"] forState:UIControlStateNormal];
        [threeBtnContainView addSubview:cellSearchBtn];
        
        cellDuplicateBtn = [[UIButton alloc]initWithFrame:CGRectMake(52, 0, 52, 44)];
        [cellDuplicateBtn setImage:[UIImage imageNamed:@"sideslip_copy"] forState:UIControlStateNormal];
        [threeBtnContainView addSubview:cellDuplicateBtn];
        
        cellDeleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(104, 0, 52, 44)];
        [cellDeleteBtn setImage:[UIImage imageNamed:@"sideslip_delete"] forState:UIControlStateNormal];
        [threeBtnContainView addSubview:cellDeleteBtn];
        
        swipGestureFromLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [swipGestureFromLeft setDirection:UISwipeGestureRecognizerDirectionRight];
        swipGestureFromLeft.delegate = self;
        [self.contentView addGestureRecognizer:swipGestureFromLeft];
        
        swipGuetureFromRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveCelltoRight)];
        [swipGuetureFromRight setDirection:UISwipeGestureRecognizerDirectionLeft];
        swipGuetureFromRight.delegate = self;
        [self.contentView addGestureRecognizer:swipGuetureFromRight];
 	}
    return self;
}

-(void)moveCelltoRight{
    if (self.accountViewController_iPad != nil) {
        if (self.accountViewController_iPad.swipCellIndex == -1 ) {
            self.accountViewController_iPad.swipCellIndex = cellDuplicateBtn.tag;
            [self.accountViewController_iPad.rightTableView reloadData];
        }
        else{
            self.accountViewController_iPad.swipCellIndex = -1;
            [self.accountViewController_iPad.rightTableView reloadData];
        }
    }
}

-(void)layoutShowTwoCellBtns_iPad:(BOOL)showTwoBtns{
    if (showTwoBtns) {
        if (threeBtnContainView.frame.size.width==0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            threeBtnContainView.frame = CGRectMake(TWOBTNLEFT_IPAD, threeBtnContainView.frame.origin.y, TWOBTNWITH_IPAD, threeBtnContainView.frame.size.height);
            [UIView commitAnimations];
            
        }
    }
    else{
        if (threeBtnContainView.frame.size.width>0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            threeBtnContainView.frame = CGRectMake(566, threeBtnContainView.frame.origin.y, 0, threeBtnContainView.frame.size.height);
            [UIView commitAnimations];
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
}

@end
