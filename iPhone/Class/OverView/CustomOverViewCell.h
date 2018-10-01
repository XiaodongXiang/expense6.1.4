//
//  CustomOverViewCell.h
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "SWTableViewCell.h"

@interface CustomOverViewCell : SWTableViewCell
@property(nonatomic,strong)UIImageView *categoryIconImage;
@property(nonatomic,strong)UILabel     *nameLabel;
@property(nonatomic,strong)UILabel     *accountNameLabel;
@property(nonatomic,strong)UILabel     *amountLabel;
@property(nonatomic,strong)UIImageView							    *cycleImageView;
@property(nonatomic,strong)UIImageView							    *memoImage;
@property(nonatomic,strong)UIImageView                             *photoImage;
//@property(nonatomic, strong)UILabel* accountLbl;

@end
