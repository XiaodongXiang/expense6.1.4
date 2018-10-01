//
//  OverViewCell.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-13.
//
//

#import <UIKit/UIKit.h>

@protocol OverViewCellDelegate <NSObject>

-(void)setTableViewIndex:(long)inDexInterger;

@end

@interface ipad_OverViewCell : UITableViewCell{
    UIImageView *backgroundImage;
    UIImageView *categoryIconImage;
    UILabel     *nameLabel;
    UILabel     *accountNameLabel;
    UILabel     *amountLabel;
    
    UIView      *threeBtnContainView;
    UIImageView *threeBtnViewBgImage;
    UIButton    *searchBtn;
    UIButton    *duplicateBtn;
    UIButton    *deleteBtn;
    
    id<OverViewCellDelegate> delegate;

    
    UISwipeGestureRecognizer *swipGestureFromLeft;
    UISwipeGestureRecognizer *swipGuetureFromRight;
    
}

@property(nonatomic,strong)UIImageView *categoryIconImage;
@property(nonatomic,strong)UILabel     *nameLabel;
@property(nonatomic,strong)UILabel     *accountNameLabel;
@property(nonatomic,strong)UILabel     *amountLabel;

@property(nonatomic,strong)UIView      *thireeBtnContainView;
@property(nonatomic,strong)UIImageView *threeBtnViewBgImage;
@property(nonatomic,strong)UIButton    *searchBtn;
@property(nonatomic,strong)UIButton    *duplicateBtn;
@property(nonatomic,strong)UIButton    *deleteBtn;
@property(nonatomic,strong)id<OverViewCellDelegate> delegate;


-(void)layoutShowTwoCellBtns:(BOOL)showThreeBtns;

@end
