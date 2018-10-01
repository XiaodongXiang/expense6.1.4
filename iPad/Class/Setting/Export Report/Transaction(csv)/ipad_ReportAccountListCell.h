//
//  ipad_ReportAccountListCell.h
//  PocketExpense
//
//  Created by humingjing on 14-5-20.
//
//

#import <UIKit/UIKit.h>

@interface ipad_ReportAccountListCell : UITableViewCell
{
    UILabel									*nameLabel;
 	
	UIImageView								*headImageView;
	UIImageView								*bgImageView;
    
}
@property(nonatomic,strong) UILabel									*nameLabel;

@property(nonatomic,strong) UIImageView								*headImageView;
@property(nonatomic,strong) UIImageView								*bgImageView;

@end
