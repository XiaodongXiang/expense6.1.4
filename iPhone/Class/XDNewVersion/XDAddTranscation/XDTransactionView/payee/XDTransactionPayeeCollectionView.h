//
//  XDTransactionPayeeCollectionView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/9.
//

#import <UIKit/UIKit.h>

@class Payee;

@protocol XDTransactionPayeeCollectionViewDelegate <NSObject>
-(void)returnSelectedPayee:(Payee*)payee;
@end
@interface XDTransactionPayeeCollectionView : UICollectionView

@property(nonatomic, assign)TransactionType tranType;
@property(nonatomic, weak)id<XDTransactionPayeeCollectionViewDelegate> payeeDelegate;

@property(nonatomic, copy)NSString * title;

@end
