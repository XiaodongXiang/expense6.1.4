//
//  ReleatedCell.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-14.
//
//

#import <UIKit/UIKit.h>

@class SearchRelatedViewController;
@interface ReleatedCell : UITableViewCell{
    UIImageView								*bgImageView;

    UIImageView                             *cateIcon;
	UILabel									*nameLabel;
    UILabel                                 *dateTimeLabel;
 	UILabel									*blanceLabel;
    
    UIImageView                             *memoIcon;
    UIImageView                             *phonteIcon;
    
    UIView                                  *twoBtnContainView;
    UIImageView                             *twoBtnContainViewImage;
 	UIButton                                *cellcopyBtn;
    UIButton                                *celldeleteBtn;
    
    SearchRelatedViewController             *searchRelatedViewController;
    
    UISwipeGestureRecognizer                *swipGestureFromLeft;
    UISwipeGestureRecognizer                *swipGuetureFromRight;
}
@property (nonatomic, strong)UIImageView	*bgImageView;
@property (nonatomic, strong)UIImageView    *cateIcon;
@property (nonatomic, strong)UILabel		*nameLabel;
@property (nonatomic, strong)UILabel		*blanceLabel;
@property (nonatomic, strong)UILabel        *dateTimeLabel;

@property (nonatomic, strong)UIImageView                             *memoIcon;
@property (nonatomic, strong)UIImageView                             *phonteIcon;

@property (nonatomic, strong)UIView        *twoBtnContainView;
@property (nonatomic, strong)UIImageView   *twoBtnContainViewImage;
@property (nonatomic, strong)UIButton      *cellcopyBtn;
@property (nonatomic, strong)UIButton      *celldeleteBtn;


@property (nonatomic, strong)SearchRelatedViewController *searchRelatedViewController;

@property (nonatomic, strong)UISwipeGestureRecognizer *swipGestureFromLeft;
@property (nonatomic, strong)UISwipeGestureRecognizer *swipGuetureFromRight;


-(void)layoutShowTwoCellBtns:(BOOL)showTwoBtns;

@end
