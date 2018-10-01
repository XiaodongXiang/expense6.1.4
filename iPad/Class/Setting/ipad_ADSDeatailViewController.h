//
//  ipad_ADSDeatailViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-7-2.
//
//

#import <UIKit/UIKit.h>

@interface ipad_ADSDeatailViewController : UIViewController<UIScrollViewDelegate>
@property(nonatomic,assign)NSInteger    pageNum;
@property(nonatomic,strong)IBOutlet UIScrollView    *imageContainScrollView;
@property(nonatomic,strong)IBOutlet UIImageView     *imageView_expoerData;
@property(nonatomic,strong)IBOutlet UIImageView     *imageView_syncData;
@property(nonatomic,strong)IBOutlet UIImageView     *imageView_backup;
@property(nonatomic,strong)IBOutlet UIPageControl   *pageControl;
@property(nonatomic,strong)IBOutlet UIButton        *backBtn1;
@property(nonatomic,strong)IBOutlet UILabel         *priceLabel;

@property(nonatomic,strong)IBOutlet UIButton        *purchaseBtn;
@property(nonatomic,strong)IBOutlet UIButton        *restoreBtn;
@property(nonatomic,assign)BOOL                      isComeFromSetting;
-(void)backBtnPressed:(id)sender;
@end
