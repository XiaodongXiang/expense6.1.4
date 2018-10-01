//
//  ipad_ReportCategoryPopCell.h
//  PocketExpense
//
//  Created by humingjing on 14-5-23.
//
//

#import <UIKit/UIKit.h>

@interface ipad_ReportCategoryPopCell : UITableViewCell
{
    UIImageView							    *bgImageView;
    //对应payee的Name
	UILabel									*nameLabel;
    UILabel									*timeLabel;
    UILabel									*spentLabel;
}
@property(nonatomic,strong) UIImageView							    *bgImageView;
//对应payee的Name
@property(nonatomic,strong)UILabel									*nameLabel;
@property(nonatomic,strong)UILabel									*timeLabel;
@property(nonatomic,strong)UILabel									*spentLabel;
@end
