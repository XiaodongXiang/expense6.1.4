//
//  OverViewCell.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-13.
//
//

#import "ipad_OverViewCell.h"
#import "iPad_OverViewViewController.h"
#import "PokcetExpenseAppDelegate.h"


#define THREEBTNLEFT 222
#define THREEBTNWITH 156

@implementation ipad_OverViewCell
@synthesize categoryIconImage,nameLabel,accountNameLabel,amountLabel,thireeBtnContainView,threeBtnViewBgImage,searchBtn,duplicateBtn,deleteBtn;
@synthesize delegate;
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        
        categoryIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 23, 23)];
        categoryIconImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:categoryIconImage];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(53, 7, 120, 20)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1];
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        
        accountNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(53, 31, 200, 15)];
        accountNameLabel.backgroundColor = [UIColor clearColor];
        accountNameLabel.textColor = [UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1];
        [accountNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        accountNameLabel.textAlignment = NSTextAlignmentLeft;
        accountNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:accountNameLabel];
        
        amountLabel=[[UILabel alloc]initWithFrame:CGRectMake(378-15-200, 0, 200, 53)];
        amountLabel.backgroundColor = [UIColor clearColor];
        [amountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
        amountLabel.textAlignment = NSTextAlignmentRight;
        amountLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:amountLabel];
        
        UIView *bottomLine=[[UIView alloc]initWithFrame:CGRectMake(53, 53-EXPENSE_SCALE, 310, EXPENSE_SCALE)];
        bottomLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [self.contentView addSubview:bottomLine];
        
        thireeBtnContainView = [[UIView alloc]initWithFrame:CGRectMake(378, 0, 156, 53)];
        thireeBtnContainView.backgroundColor=[UIColor colorWithRed:79/255.0 green:193/255.0 blue:255/255.0 alpha:1];
        [self.contentView addSubview:thireeBtnContainView];
        
  
        searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 52, 53)];
        [searchBtn setImage:[UIImage imageNamed:@"sideslip_relation"] forState:UIControlStateNormal];
        [thireeBtnContainView addSubview:searchBtn];
        
        duplicateBtn = [[UIButton alloc]initWithFrame:CGRectMake(52, 0, 52, 53)];
        [duplicateBtn setImage:[UIImage imageNamed:@"sideslip_copy"] forState:UIControlStateNormal];
        [thireeBtnContainView addSubview:duplicateBtn];

        deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(104, 0, 52,53)];
        [deleteBtn setImage:[UIImage imageNamed:@"sideslip_delete"] forState:UIControlStateNormal];
        [thireeBtnContainView addSubview:deleteBtn];
        
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
    [delegate setTableViewIndex:self.tag];
}

-(void)layoutShowTwoCellBtns:(BOOL)showThreeBtns{
    if (showThreeBtns) {
        if (thireeBtnContainView.frame.size.width==0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            thireeBtnContainView.frame = CGRectMake(THREEBTNLEFT, thireeBtnContainView.frame.origin.y, THREEBTNWITH, thireeBtnContainView.frame.size.height);
            [UIView commitAnimations];
            
        }
    }
    else{
        if (thireeBtnContainView.frame.size.width>0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            thireeBtnContainView.frame = CGRectMake(378, thireeBtnContainView.frame.origin.y, 0, thireeBtnContainView.frame.size.height);
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
