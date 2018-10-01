//
//  CustomOverViewCell.m
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "CustomOverViewCell.h"
#import "AppDelegate_iPhone.h"

@implementation CustomOverViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        float screenWith = [UIScreen mainScreen].bounds.size.width;
        
        AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        
        _categoryIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
        _categoryIconImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_categoryIconImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(67, 15, (SCREEN_WIDTH - 60)/2,22)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = RGBColor(85, 85, 85);
        [_nameLabel setFont:[UIFont fontWithName:FontSFUITextRegular size:16]];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.minimumScaleFactor = 0.7f;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_nameLabel];
        
        _accountNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(67, 37, IS_IPHONE_5?210:250, 16)];
        _accountNameLabel.backgroundColor = [UIColor clearColor];
        _accountNameLabel.textColor = RGBColor(200, 200, 200);
        [_accountNameLabel setFont:[UIFont fontWithName:FontSFUITextRegular size:14]];
        _accountNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_accountNameLabel];
        
        
        
        _amountLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - (SCREEN_WIDTH - 60)/2, 15, (SCREEN_WIDTH - 60)/2-15, 30)];
        _amountLabel.backgroundColor = [UIColor clearColor];
        [_amountLabel setFont:[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
        _amountLabel.textAlignment = NSTextAlignmentRight;
        _amountLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_amountLabel];
        
//        _accountLbl=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - (SCREEN_WIDTH - 60)/2, 37, (SCREEN_WIDTH - 60)/2-15, 16)];
//        _accountLbl.backgroundColor = [UIColor clearColor];
//        _accountLbl.textColor = RGBColor(200, 200, 200);
//        [_accountLbl setFont:[UIFont fontWithName:FontSFUITextRegular size:14]];
//        _accountLbl.textAlignment = NSTextAlignmentRight;
//        _accountLbl.adjustsFontSizeToFitWidth = YES;
//        [self.contentView addSubview:_accountLbl];
        
        //cycle
        _cycleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(140,27, 20, 20)];
        _cycleImageView.image = [UIImage imageNamed:@"icon_cycle"];
        _cycleImageView.contentMode = UIViewContentModeCenter;
        _cycleImageView.hidden = YES;
        [self.contentView addSubview:_cycleImageView];
        
        //memo
        _memoImage = [[UIImageView alloc] initWithFrame:CGRectMake(140,30, 20, 20)];
        _memoImage.image = [UIImage imageNamed:@"icon_memo"];
        _memoImage.contentMode = UIViewContentModeCenter;
        _memoImage.hidden = YES;
        [self.contentView addSubview:_memoImage];
        
        //photo
        _photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(160,32, 20, 20)];
        _photoImage.image = [UIImage imageNamed:@"icon_photo_20_20.png"];
        _photoImage.hidden = YES;
        [self.contentView addSubview:_photoImage];
        
//                //设置背景图片
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 69.5, SCREEN_WIDTH-15, 0.5)];
        line.backgroundColor = RGBColor(238, 238, 238);
        [self.contentView addSubview:line];
        
        
    }
    return self;
}


@end
