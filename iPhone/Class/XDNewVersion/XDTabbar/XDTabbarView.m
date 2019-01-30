//
//  XDTabbarView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/1.
//

#import "XDTabbarView.h"
#import "XDTabbarItem.h"
@implementation XDTabbarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self initItemBtn];
        
        
        if (IS_IPHONE_5) {
            UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, -17, 70, 66)];
            [btn setImage:[UIImage imageNamed:@"add_se"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"add_press"] forState:UIControlStateHighlighted];

            btn.adjustsImageWhenHighlighted = NO;
            btn.centerX = SCREEN_WIDTH/2;
            btn.tag =2;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }else{
            UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, -17, SCREEN_WIDTH/5, 66)];
            [btn setImage:[UIImage imageNamed:@"add-1"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"add_press"] forState:UIControlStateHighlighted];

            btn.adjustsImageWhenHighlighted = NO;
            btn.centerX = SCREEN_WIDTH/2;
            btn.tag =2;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
       
    }
    return self;
}

-(void)initItemBtn{
    CGFloat width = SCREEN_WIDTH/5;
    NSArray* imageArr = @[@"transcations_normal",@"chart_normal",@"",@"budgets_normal",@"bill_normal"];
    NSArray* selectImageArr = @[@"transcations_press",@"chart_press",@"",@"budgets_press",@"bill_press"];
    NSArray* titleArr = @[NSLocalizedString(@"VC_Calendar", nil),NSLocalizedString(@"VC_Chart", nil),@"",NSLocalizedString(@"VC_Budget", nil),NSLocalizedString(@"VC_Bills", nil)];
    
    for (int i = 0; i < 5; i++) {
        if (i != 2) {
            XDTabbarItem* item = [[XDTabbarItem alloc ]initWithFrame:CGRectMake(i * width, 1, width, 49)];
            item.tag = i;
            item.imageStr = imageArr[i];
            item.selectImageStr = selectImageArr[i];
            item.titleStr = titleArr[i];
            [item addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:item];
            if (i == 0) {
                item.itemSelected = YES;
            }
        }
    }
}

-(void)btnClick:(UIButton*)btn{
    
    self.block(btn.tag);
    
    if (btn.tag == 2) {
        return;
    }
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[XDTabbarItem class]]) {
            XDTabbarItem* btn = (XDTabbarItem*)view;
            btn.itemSelected = NO;
        }
    }
    
    XDTabbarItem* item = (XDTabbarItem*)btn;
    item.itemSelected = YES;

}

-(void)drawRect:(CGRect)rect{
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH, 0)];
    path.lineWidth = 1/[UIScreen mainScreen].scale;
    [RGBColor(218, 218, 218) set];
    [path stroke];
}

@end
