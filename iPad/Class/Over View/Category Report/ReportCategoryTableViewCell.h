//
//  ReportCategoryTableViewCell.h
//  PocketExpense
//
//  Created by appxy_dev on 14-3-3.
//
//

#import <UIKit/UIKit.h>

@interface ReportCategoryTableViewCell : UITableViewCell
{
    UIImageView                             *colorImage;
	UILabel									*nameLabel;
	UILabel									*spentLabel;
	UILabel									*percentLabel;
	
    
    UIImageView								*bgImageView;
}
@property (nonatomic, strong) UIImageView       *colorImage;
@property (nonatomic, strong) UILabel		*nameLabel;
@property (nonatomic, strong) UILabel		*spentLabel;
@property (nonatomic, strong) UILabel		*percentLabel;
@property(nonatomic,strong)  UIImageView		*bgImageView;

@end
