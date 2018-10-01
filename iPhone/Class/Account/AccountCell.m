//
//  AccountCell.m
//
//  Created by BHI_James on 4/13/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "AccountCell.h"
#import "AppDelegate_iPhone.h"
#import "AccountsViewController.h"
#import "UIViewAdditions.h"


#define DELETEBTN_ORIGNX1 -30
#define DELETEBTN_ORIGNX2 8

#define NAMELABLE_ORIGNX1 46
#define NAMELABEL_ORIGNX2 8
#define BALANCELABEL_ORIGNX1 184
#define BALANCELABEL_ORIGNX2 0

@implementation AccountCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        detailBtn_Origin1 = SCREEN_WIDTH;
        detailBtn_Origin2 = SCREEN_WIDTH - 140;
        
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, 30, 60)];
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_delete_30_30.png"] forState:UIControlStateNormal];
        _deleteBtn.hidden = YES;
        [self addSubview:_deleteBtn];
        
        _detailBtn =[[UIButton alloc]initWithFrame:CGRectMake(detailBtn_Origin1, 0, 60, 60)];
        _detailBtn.hidden = YES;
        [_detailBtn setImage:[UIImage imageNamed:@"icon_Contact_Info.png"] forState:UIControlStateNormal];
        _detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.contentView addSubview:_detailBtn];
        
        _accountIcon = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 20, 20)];
        _accountIcon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_accountIcon];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(46.0, 3.0, 164, 30.0)];
        [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
        [_nameLabel setHighlightedTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
        [self.contentView addSubview:_nameLabel];
        
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(46.0, 30.0, 164, 20.0)];
        [_typeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [_typeLabel setTextAlignment:NSTextAlignmentLeft];
        [_typeLabel setBackgroundColor:[UIColor clearColor]];
        [_typeLabel setTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1]];
        [_typeLabel setHighlightedTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1]];
        [self.contentView addSubview:_typeLabel];
        
        AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        _blanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 0.0, SCREEN_WIDTH-245, 59.0)];
        [_blanceLabel setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
        [_blanceLabel setTextAlignment:NSTextAlignmentRight];
        [_blanceLabel setBackgroundColor:[UIColor clearColor]];
        [_blanceLabel setTextColor:[UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1]];
        [_blanceLabel setHighlightedTextColor:[UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1]];
        _blanceLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_blanceLabel];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-33, 15, 30, 30)];
        _arrowImageView.image = [UIImage imageNamed:@"arrow1_30_30.png"];
        [self.contentView addSubview:_arrowImageView];

        _line = [[UIView alloc]initWithFrame:CGRectMake(46, 60-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
        _line.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
        [self.contentView addSubview:_line];
    }
    return self;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (self.editing == editing)
	{
		return;
	}
	
	[super setEditing:editing animated:animated];
    if (self.editing)
    {
//        for (UIView * view in self.subviews) {
//            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
//                for (UIView * subview in view.subviews) {
//                    if ([subview isKindOfClass: [UIImageView class]]) {
//                        ((UIImageView *)subview).image = [UIImage imageNamed: @"yourimage.png"];
//                    }
//                }
//            }
//        }
        _accountIcon.alpha = 0;
        _deleteBtn.hidden = NO;
        _nameLabel.frame = CGRectMake(8, _nameLabel.frame.origin.y, _nameLabel.frame.size.width, _nameLabel.frame.size.height);
        _typeLabel.frame = CGRectMake(8, _typeLabel.frame.origin.y, _typeLabel.frame.size.width, _typeLabel.frame.size.height);
        _line.frame = CGRectMake(8, _line.frame.origin.y, _line.frame.size.width, _line.frame.size.height);

        _detailBtn.frame = CGRectMake(detailBtn_Origin2, _detailBtn.frame.origin.y, _detailBtn.frame.size.width, _detailBtn.frame.size.height);
        _detailBtn.hidden = NO;
        _blanceLabel.hidden = YES;
        _arrowImageView.hidden = YES;

        
        if (!self.accountViewController.righBtnPressed)
        {
            _detailBtn.hidden = YES;
        }
    }
    else
    {
        _accountIcon.alpha = 1;
        _deleteBtn.hidden = YES;
        _nameLabel.frame = CGRectMake(46, _nameLabel.frame.origin.y, _nameLabel.frame.size.width, _nameLabel.frame.size.height);
        _typeLabel.frame = CGRectMake(46, _typeLabel.frame.origin.y, _typeLabel.frame.size.width, _typeLabel.frame.size.height);
        _detailBtn.frame = CGRectMake(detailBtn_Origin1, _detailBtn.frame.origin.y, _detailBtn.frame.size.width, _detailBtn.frame.size.height);
        _detailBtn.hidden = YES;
        _line.frame = CGRectMake(46, _line.frame.origin.y, _line.frame.size.width, _line.frame.size.height);
        _blanceLabel.hidden = NO;
        _arrowImageView.hidden = NO;
    }

}



@end
