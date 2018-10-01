//
//  DRDynamicSlideShow_ipad.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/6/30.
//
//

#import <UIKit/UIKit.h>

@interface DRDynamicSlideShowAnimation_ipad : NSObject
//子view
@property (strong, nonatomic) id subview;
//第几页
@property (nonatomic) NSInteger page;
//动画的类型属性
@property (strong, nonatomic) NSString * keyPath;
//动画属性开始动画前的值
@property (strong, nonatomic) id fromValue;
//动画属性结束的值
@property (strong, nonatomic) id toValue;
//延迟开始动画时间
@property (nonatomic) CGFloat delay;

+ (id)animationForSubview:(UIView *)subview page:(NSInteger)page keyPath:(NSString *)keyPath toValue:(id)toValue delay:(CGFloat)delay;
+ (id)animationForSubview:(UIView *)subview page:(NSInteger)page keyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue delay:(CGFloat)delay;

@end

@class LogInViewController_ipad;
@interface DRDynamicSlideShow_ipad : UIScrollView<UIScrollViewDelegate>
{
    //三个页面的动画数组
    NSMutableArray * animations;
    //当前页面的动画数组
    NSArray * currentAnimations;
    //当前页面
    NSInteger currentPage;

}
//共有多少页
@property (readonly, nonatomic) NSInteger numberOfPages;
//点击是否切换页
@property (nonatomic) BOOL scrollsPageOnTap;
//???
@property (strong, nonatomic) void (^didReachPageBlock)(NSInteger page);

@property(strong,nonatomic)LogInViewController_ipad *logInViewController_ipad;
//添加动画
- (void)addAnimation:(DRDynamicSlideShowAnimation_ipad *)animation;
//添加子view
- (void)addSubview:(UIView *)subview onPage:(NSInteger)page;

@end
