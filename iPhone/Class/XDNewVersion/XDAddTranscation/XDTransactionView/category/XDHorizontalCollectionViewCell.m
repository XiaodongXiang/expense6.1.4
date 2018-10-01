//
//  XDHorizontalCollectionViewCell.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/24.
//

#import "XDHorizontalCollectionViewCell.h"
#import "XDCategoryBtn.h"

@interface XDHorizontalCollectionViewCell()


@end
@implementation XDHorizontalCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    if (self.contentView.subviews.count > 0) {
        for (UIView* view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
    }

    CGFloat width = SCREEN_WIDTH/4;
   
    for (int i = 0; i < dataArr.count; i++) {
        Category* category = dataArr[i];
        CGFloat x = i % 4 * width;
        CGFloat y = i / 4 * width;
                
        XDCategoryBtn* btn = [[XDCategoryBtn alloc]initWithFrame:CGRectMake(x, y, width, width)];
        btn.category = category;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:btn];
    }
}

-(void)btnClick:(XDCategoryBtn*)btn{

    if ([self.delegate respondsToSelector:@selector(returnSelectedCategory:)]) {
        [self.delegate returnSelectedCategory:btn.category];
    }
}

@end
