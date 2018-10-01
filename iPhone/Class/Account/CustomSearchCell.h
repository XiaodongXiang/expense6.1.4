//
//  CustomSearchCell.h
//  PocketExpense
//
//  Created by 刘晨 on 16/3/3.
//
//

#import "SWTableViewCell.h"

@interface CustomSearchCell : SWTableViewCell
@property (nonatomic,strong) UILabel									*nameLabel;
@property (nonatomic,strong) UILabel									*spentLabel;
@property (nonatomic,strong) UILabel									*timeLabel;
@property (nonatomic,strong) UIImageView							    *phontoImage;
@property (nonatomic,strong) UIImageView                             *memoImage;
@property (nonatomic,strong) UIImageView                             *categoryIcon;

@end
