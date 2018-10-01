//
//  XDTransactionCatgroyView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/1/24.
//

#import <UIKit/UIKit.h>

@class Category;
@protocol XDTransactionCatgroyViewDelegate <NSObject>

-(void)returnSelectCategory:(Category*)category;
-(void)returnCurrentPage:(NSInteger)index;
@end

@interface XDTransactionCatgroyView : UICollectionView

@property(nonatomic, assign)TransactionType transactionType;
@property(nonatomic, weak)id<XDTransactionCatgroyViewDelegate> categoryDelegate;
@property(nonatomic, strong)Category * selectCategory;

@end
