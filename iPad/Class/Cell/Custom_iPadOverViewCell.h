//
//  Custom_iPadOverViewCell.h
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "SWTableViewCell.h"

@interface Custom_iPadOverViewCell : SWTableViewCell
@property(nonatomic,strong)UIImageView *categoryIconImage;
@property(nonatomic,strong)UILabel     *nameLabel;
@property(nonatomic,strong)UILabel     *accountNameLabel;
@property(nonatomic,strong)UILabel     *amountLabel;

@end
