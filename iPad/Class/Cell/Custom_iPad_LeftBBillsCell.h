//
//  Custom_iPad_LeftBBillsCell.h
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "SWTableViewCell.h"

@interface Custom_iPad_LeftBBillsCell : SWTableViewCell
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *categoryIconImage;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *amountLabel;
@property (nonatomic, strong) UILabel     *dateLabel;
@property (nonatomic, strong) UIImageView *memoImage;

@property (nonatomic, strong) UIImageView *paidStateImageView;
@end
