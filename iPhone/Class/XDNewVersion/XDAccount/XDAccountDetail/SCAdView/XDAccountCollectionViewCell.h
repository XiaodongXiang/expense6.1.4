//
//  XDAccountCollectionViewCell.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/9.
//

#import <UIKit/UIKit.h>
#import "SCAdViewRenderDelegate.h"

@class AccountCount;
@interface XDAccountCollectionViewCell : UICollectionViewCell<SCAdViewRenderDelegate>

@property(nonatomic, strong)AccountCount * account;

@end
