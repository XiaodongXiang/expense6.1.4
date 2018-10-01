//
//  ipad_CategoryTransactionCell.h
//  PocketExpense
//
//  Created by humingjing on 14-9-12.
//
//

#import <UIKit/UIKit.h>

@interface ipad_CategoryTransactionCell : UITableViewCell

@property(nonatomic,strong)UILabel								*timeLabel;
@property(nonatomic,strong)UILabel                              *accountLabel;
@property(nonatomic,strong)UILabel                              *payeeLabel;
@property(nonatomic,strong)UILabel                              *memoLabel;
@property(nonatomic,strong)UILabel							    *spentLabel;

@end
