//
//  CategorySplitCell.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-10.
//
//

#import <UIKit/UIKit.h>

@interface ipad_CategorySplitCell : UITableViewCell{
    UIImageView *bgImage;
    UIImageView *categoryIconImage;
    UILabel     *categoryNameLabel;
    UITextField *amountTextField;
    
    BOOL    thisCellisEdit;
}

@property(nonatomic,strong)UIImageView *bgImage;
@property(nonatomic,strong)UIImageView *categoryIconImage;
@property(nonatomic,strong)UILabel     *categoryNameLabel;
@property(nonatomic,strong)UITextField *amountTextField;

@property(nonatomic,assign)BOOL    thisCellisEdit;
@end
