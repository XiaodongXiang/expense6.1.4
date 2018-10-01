//
//  DRDynamicSlideShow_ipad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/6/30.
//
//

#import "DRDynamicSlideShow_ipad.h"
#import "LogInViewController_ipad.h"

#define SLIDESHOW_WIDTH 400


typedef NS_ENUM(NSUInteger, DRDynamicSlideShowAnimationValueType) {
    DRDynamicSlideShowAnimationValueTypeCGFloat,
    DRDynamicSlideShowAnimationValueTypeCGPoint,
    DRDynamicSlideShowAnimationValueTypeCGSize,
    DRDynamicSlideShowAnimationValueTypeCGRect,
    DRDynamicSlideShowAnimationValueTypeCGAffineTransform,
    DRDynamicSlideShowAnimationValueTypeUIColor
};

#pragma mark Interfaces Extensions

@interface DRDynamicSlideShow_ipad ()

@property (readwrite, nonatomic) NSInteger numberOfPages;

@end

@interface DRDynamicSlideShowAnimation_ipad ()

@property (nonatomic) DRDynamicSlideShowAnimationValueType valueType;

@end

#pragma mark Implementations

@implementation DRDynamicSlideShowAnimation_ipad

/*
 将某一个视图底下的子视图移动
 参数说明：
 (1)subview 显示动画的view
 (2)keyPath
 (3)toValue 移动到的位置
 (4)delay 延迟多长时间执行动画
 */
+ (id)animationForSubview:(UIView *)subview page:(NSInteger)page keyPath:(NSString *)keyPath toValue:(id)toValue delay:(CGFloat)delay {
    DRDynamicSlideShowAnimation_ipad * animation = [DRDynamicSlideShowAnimation_ipad animationForSubview:subview page:page keyPath:keyPath fromValue:[subview valueForKeyPath:keyPath] toValue:toValue delay:delay];
    
    return animation;
}

/*
 将某一个视图底下的子视图移动
 */
+ (id)animationForSubview:(UIView *)subview page:(NSInteger)page keyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue delay:(CGFloat)delay
{
    DRDynamicSlideShowAnimation_ipad * animation = [[DRDynamicSlideShowAnimation_ipad alloc] init];
    
    [animation setSubview:subview];
    [animation setPage:page];
    [animation setKeyPath:keyPath];
    [animation setFromValue:fromValue];
    [animation setToValue:toValue];
    [animation setDelay:delay];
    [animation setValueType:[animation valueDataType]];
    return animation;
}

- (DRDynamicSlideShowAnimationValueType)valueDataType {
    DRDynamicSlideShowAnimationValueType valueDataType = 0;
    
    if ([self.fromValue isKindOfClass:NSClassFromString(@"NSNumber")]) {
        if ([self valueTypeIsEqualTo:@encode(CGFloat)]) {
            valueDataType = DRDynamicSlideShowAnimationValueTypeCGFloat;
        }
    } else if ([self.fromValue isKindOfClass:NSClassFromString(@"NSValue")]) {
        if ([self valueTypeIsEqualTo:@encode(CGPoint)]) {
            valueDataType = DRDynamicSlideShowAnimationValueTypeCGPoint;
        } else if ([self valueTypeIsEqualTo:@encode(CGSize)]) {
            valueDataType = DRDynamicSlideShowAnimationValueTypeCGSize;
        } else if ([self valueTypeIsEqualTo:@encode(CGRect)]) {
            valueDataType = DRDynamicSlideShowAnimationValueTypeCGRect;
        } else if ([self valueTypeIsEqualTo:@encode(CGAffineTransform)]) {
            valueDataType = DRDynamicSlideShowAnimationValueTypeCGAffineTransform;
        }
    } else {
        valueDataType = DRDynamicSlideShowAnimationValueTypeUIColor;
    }
    
    return valueDataType;
}

- (BOOL)valueTypeIsEqualTo:(const char *)typeChar {
    NSString * valueDataTypeString = [[NSString alloc] initWithCString:[self.fromValue objCType] encoding:NSUTF8StringEncoding];
    
    NSString * comparisonDataTypeString = [[NSString alloc] initWithCString:typeChar encoding:NSUTF8StringEncoding];
    
    if ([valueDataTypeString isEqualToString:comparisonDataTypeString]) {
        return YES;
    }
    
    return NO;
}

/*
 执行动画到某一种程度,为什么更改了属性，就会以动画形式展示出来呢
 */
- (void)performWithPercentage:(CGFloat)percentage
{
    //动画应该执行多少
    percentage = MAX((percentage-self.delay)/(1-self.delay), 0);
    
    switch (self.valueType) {
        case DRDynamicSlideShowAnimationValueTypeCGFloat: {
            CGFloat newFloat = [self partialValueWithFromValue:[self.fromValue floatValue] toValue:[self.toValue floatValue] percentage:percentage];
            
            [self.subview setValue:@(newFloat) forKeyPath:self.keyPath];
        }
            break;
        case DRDynamicSlideShowAnimationValueTypeCGPoint: {
            CGFloat newX = [self partialValueWithFromValue:[self.fromValue CGPointValue].x toValue:[self.toValue CGPointValue].x percentage:percentage];
            CGFloat newY = [self partialValueWithFromValue:[self.fromValue CGPointValue].y toValue:[self.toValue CGPointValue].y percentage:percentage];
            
            [self.subview setValue:[NSValue valueWithCGPoint:CGPointMake(newX, newY)] forKeyPath:self.keyPath];
        }
            break;
        case DRDynamicSlideShowAnimationValueTypeCGSize: {
            CGFloat newWidth = [self partialValueWithFromValue:[self.fromValue CGSizeValue].width toValue:[self.toValue CGSizeValue].width percentage:percentage];
            CGFloat newHeight = [self partialValueWithFromValue:[self.fromValue CGSizeValue].height toValue:[self.toValue CGSizeValue].height percentage:percentage];
            
            [self.subview setValue:[NSValue valueWithCGSize:CGSizeMake(newWidth, newHeight)] forKeyPath:self.keyPath];
        }
            break;
        case DRDynamicSlideShowAnimationValueTypeCGRect: {
            CGFloat newX = [self partialValueWithFromValue:[self.fromValue CGRectValue].origin.x toValue:[self.toValue CGRectValue].origin.x percentage:percentage];
            CGFloat newY = [self partialValueWithFromValue:[self.fromValue CGRectValue].origin.y toValue:[self.toValue CGRectValue].origin.y percentage:percentage];
            CGFloat newWidth = [self partialValueWithFromValue:[self.fromValue CGRectValue].size.width toValue:[self.toValue CGRectValue].size.width percentage:percentage];
            CGFloat newHeight = [self partialValueWithFromValue:[self.fromValue CGRectValue].size.height toValue:[self.toValue CGRectValue].size.height percentage:percentage];
            
            [self.subview setValue:[NSValue valueWithCGRect:CGRectMake(newX, newY, newWidth, newHeight)] forKeyPath:self.keyPath];
        }
            break;
        case DRDynamicSlideShowAnimationValueTypeCGAffineTransform: {
            CGFloat newA = [self partialValueWithFromValue:[self.fromValue CGAffineTransformValue].a toValue:[self.toValue CGAffineTransformValue].a percentage:percentage];
            CGFloat newB = [self partialValueWithFromValue:[self.fromValue CGAffineTransformValue].b toValue:[self.toValue CGAffineTransformValue].b percentage:percentage];
            CGFloat newC = [self partialValueWithFromValue:[self.fromValue CGAffineTransformValue].c toValue:[self.toValue CGAffineTransformValue].c percentage:percentage];
            CGFloat newD = [self partialValueWithFromValue:[self.fromValue CGAffineTransformValue].d toValue:[self.toValue CGAffineTransformValue].d percentage:percentage];
            CGFloat newTx = [self partialValueWithFromValue:[self.fromValue CGAffineTransformValue].tx toValue:[self.toValue CGAffineTransformValue].tx percentage:percentage];
            CGFloat newTy = [self partialValueWithFromValue:[self.fromValue CGAffineTransformValue].ty toValue:[self.toValue CGAffineTransformValue].ty percentage:percentage];
            
            [self.subview setValue:[NSValue valueWithCGAffineTransform:CGAffineTransformMake(newA, newB, newC, newD, newTx, newTy)] forKeyPath:self.keyPath];
        }
            break;
        case DRDynamicSlideShowAnimationValueTypeUIColor: {
            CGFloat fromR = 0;
            CGFloat fromG = 0;
            CGFloat fromB = 0;
            CGFloat fromA = 0;
            CGFloat toR = 0;
            CGFloat toG = 0;
            CGFloat toB = 0;
            CGFloat toA = 0;
            
            [(UIColor *)self.fromValue getRed:&fromR green:&fromG blue:&fromB alpha:&fromA];
            [(UIColor *)self.toValue getRed:&toR green:&toG blue:&toB alpha:&toA];
            
            CGFloat newR = [self partialValueWithFromValue:fromR toValue:toR percentage:percentage];
            CGFloat newG = [self partialValueWithFromValue:fromG toValue:toG percentage:percentage];
            CGFloat newB = [self partialValueWithFromValue:fromB toValue:toB percentage:percentage];
            CGFloat newA = [self partialValueWithFromValue:fromA toValue:toA percentage:percentage];
            
            UIColor * newColor = [[UIColor alloc] initWithRed:newR green:newG blue:newB alpha:newA];
            
            [self.subview setValue:newColor forKeyPath:self.keyPath];
        }
            break;
            
        default:
            break;
    }
    
}

- (CGFloat)partialValueWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue percentage:(CGFloat)percentage {
    return fromValue+(toValue-fromValue)*percentage;
}

@end

@implementation DRDynamicSlideShow_ipad

#pragma mark Basic Defined Methods

- (id)init {
    if (self = [super init]) {
        animations = [NSMutableArray new];
        //        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToNextPage)];
        //        [self addGestureRecognizer:tapGestureRecognizer];
        
        [self setDelegate:self];
        [self setPagingEnabled:YES];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        
        [self setScrollsPageOnTap:NO];
    }
    
    return self;
}

/*
 下一页
 */
- (void)scrollToNextPage {
    [self resetCurrentAnimations];
    [self performCurrentAnimationsWithPercentage:0];
    
    if (currentPage+1 < self.numberOfPages) {
        [UIView animateWithDuration:0.425 animations:^{
            [self setContentOffset:CGPointMake(self.contentOffset.x+self.frame.size.width, self.contentOffset.y)];
        }];
    }
}

/*
 动画数组添加动画对象
 */
- (void)addAnimation:(DRDynamicSlideShowAnimation_ipad *)animation {
    [animations addObject:animation];
}

/*
 设置contentsize
 */
- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    
    if (view.frame.origin.x >= self.contentSize.width) {
        NSInteger numberOfPages = floorf(view.frame.origin.x/self.frame.size.width)+1;
        
        [self setNumberOfPages:numberOfPages];
        [self setContentSize:CGSizeMake(self.frame.size.width*self.numberOfPages, self.contentSize.height)];
    }
}

/*
 添加view在scrollview中的第几页
 */
- (void)addSubview:(UIView *)view onPage:(NSInteger)page {
    [view setFrame:CGRectMake(view.frame.origin.x+self.frame.size.width*page, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
    [self addSubview:view];
}

#pragma mark Setter Overrides

//- (void)setScrollsPageOnTap:(BOOL)scrollsPageOnTap {
//    _scrollsPageOnTap = scrollsPageOnTap;
//    [tapGestureRecognizer setEnabled:scrollsPageOnTap];
//}

#pragma mark Useful Methods

- (NSInteger)currentPage {
    NSInteger page = floor(self.contentOffset.x / self.frame.size.width);
    
    return page;
}

/*设置当前页面的动画数组*/
- (void)resetCurrentAnimations {
    NSInteger page = [self currentPage];
    
    currentAnimations = [self animationsForPage:page];
}

/*将某一页的动画挑选出来*/
- (NSArray *)animationsForPage:(NSInteger)page {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"page == %i", page];
    NSArray * filteredAnimations = [animations filteredArrayUsingPredicate:predicate];
    
    return filteredAnimations;
}



#pragma mark Scroll View Delegate Methods
//获取当前页面的动画
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self resetCurrentAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIImageView *welcomImage = (UIImageView *)[self viewWithTag:11];
    UIImageView *iconImage = (UIImageView *)[self viewWithTag:1];
    UIImageView *desImageView=(UIImageView *)[self viewWithTag:2];
    
    UIImage *littleIconImage = [UIImage imageNamed:[NSString customImageName:@"ipad_logo_a2"]];
    UIImage *iconIm = [UIImage imageNamed:[NSString customImageName:@"ipad_logo_a1"]];
    
    UIImage *desIm=[UIImage imageNamed:[NSString customImageName:@"ipad_pocket_expense_a1"]];
    
    if(scrollView.contentOffset.x > 0)
        welcomImage.hidden = YES;
    else
        welcomImage.hidden = NO;
    
    if (scrollView.contentOffset.x>=SLIDESHOW_WIDTH*2)
    {
        _logInViewController_ipad.pageController.currentPage = 2;
        iconImage.image = littleIconImage;
    }
    else if (scrollView.contentOffset.x >= SLIDESHOW_WIDTH)
    {
        _logInViewController_ipad.pageController.currentPage = 1;
        iconImage.image = littleIconImage;
    }
    else
    {
        _logInViewController_ipad.pageController.currentPage = 0;
        iconImage.image = iconIm;
        desImageView.image=desIm;
    }
    
    
    NSInteger page = [self currentPage];
    
    if (currentPage != page)
    {
        //如果滑动到下一页,将第当前页面的动画执行完毕，如果滑动到上一个页面，当前位置不变,获取上一页的动画
        [self performCurrentAnimationsWithPercentage:(currentPage < page ? 1 : 0)];
        currentPage = page;
        [self resetCurrentAnimations];
    }
    
    //滑动页面滑动了多少
    CGFloat horizontalScroll = self.contentOffset.x-self.frame.size.width*currentPage;
    //滑动的距离占整个页面的多少
    CGFloat percentage = horizontalScroll/self.frame.size.width;
    
    [self performCurrentAnimationsWithPercentage:percentage];

}

/*
 当前动画执行多少百分比
 */
- (void)performCurrentAnimationsWithPercentage:(CGFloat)percentage {
    //将每一个动画显示多少百分比
    for (DRDynamicSlideShowAnimation_ipad * animation in currentAnimations) {
        [animation performWithPercentage:percentage];
    }
}


@end
