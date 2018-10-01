//
//  XDHorizontalCollectionViewCell.h
//  PocketExpense
//
//  Created by 晓东 on 2018/1/24.
//

#import <UIKit/UIKit.h>
@class  Category;
@protocol XDHorizontalCollectionDelegate <NSObject>
-(void)returnSelectedCategory:(Category*)category;
@end
@interface XDHorizontalCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong)NSArray * dataArr;
@property(nonatomic, weak)id<XDHorizontalCollectionDelegate> delegate;
@property(nonatomic, strong)Category * selectCategory;


@end
