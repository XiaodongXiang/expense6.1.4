//
//  ADSDeatailViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-7-2.
//
//

#import <UIKit/UIKit.h>

//#import "InAppPurchaseManager.h"

@interface ADSDeatailViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *priceImage;

@property(nonatomic,assign)NSInteger    pageNum;
@property (weak, nonatomic) IBOutlet UIImageView *contentBg;
@property(nonatomic,strong)IBOutlet UIImageView *bgImage;
@property(nonatomic,strong)IBOutlet UIView  *contentView;
@property(nonatomic,strong)IBOutlet UIScrollView    *imageContainScrollView;
@property(nonatomic,strong)IBOutlet UIImageView     *page1_imageview;
@property(nonatomic,strong)IBOutlet UIImageView     *page2_imageview;

@property(nonatomic,strong)IBOutlet UIPageControl   *pageControl;
@property(nonatomic,strong)IBOutlet UIButton        *backBtn1;
@property(nonatomic,strong)IBOutlet UILabel         *priceLabel;

@property(nonatomic,strong)IBOutlet UIButton        *purchaseBtn;
@property(nonatomic,strong)IBOutlet UIButton        *restoreBtn;
@property(nonatomic,assign)BOOL                      isComeFromSetting;




-(void)contentViewDisAppear;

@end
