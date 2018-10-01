//
//  XDCategorySplitTableViewCell.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/1.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "CategorySelect.h"

@class XDCategorySplitTableViewCell;

@protocol XDCategorySplitCellDelegate <NSObject>

-(void)returnSplitAmount:(XDCategorySplitTableViewCell*) cell;

@optional
-(void)returnCellFrame:(XDCategorySplitTableViewCell*) cell;
@end

@interface XDCategorySplitTableViewCell : UITableViewCell

@property(nonatomic, strong)CategorySelect * categorySelect;
@property(nonatomic, weak)id<XDCategorySplitCellDelegate> delegate;

@end
