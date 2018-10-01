//
//  XDTabbarItem.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/1.
//

#import "XDTabbarItem.h"

@interface XDTabbarItem()

@property(nonatomic, strong)UIImageView * itemImageView;
@property(nonatomic, strong)UILabel * itemLabel;

@end
@implementation XDTabbarItem

-(void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    self.itemImageView.image = [UIImage imageNamed:self.imageStr];

}

-(void)setSelectImageStr:(NSString *)selectImageStr{
    _selectImageStr = selectImageStr;
    
}

-(void)setItemSelected:(BOOL)itemSelected{
    _itemSelected = itemSelected;
    if (_itemSelected) {
        self.itemImageView.image = [UIImage imageNamed:self.selectImageStr];
        self.itemLabel.textColor = RGBColor(85, 85, 85);

    }else{
        self.itemImageView.image = [UIImage imageNamed:self.imageStr];
        self.itemLabel.textColor = [UIColor lightGrayColor];

    }
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.itemLabel.text = titleStr;
}

-(UIImageView *)itemImageView{
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
        _itemImageView.centerX = self.width/2;
        _itemImageView.contentMode = UIViewContentModeCenter;
    }
    return _itemImageView;
}
-(UILabel *)itemLabel{
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 32, self.width, 14)];
        _itemLabel.textColor = [UIColor lightGrayColor];
        _itemLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:10];
        _itemLabel.minimumScaleFactor = 8;
        _itemLabel.numberOfLines = 2;
        _itemLabel.textAlignment = NSTextAlignmentCenter;
        _itemLabel.centerX = self.width/2;
        
    }
    return _itemLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.itemImageView];
        [self addSubview:self.itemLabel];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH, 0)];
    path.lineWidth = 1/[UIScreen mainScreen].scale;
    [[UIColor colorWithRed:248/255 green:248/255 blue:248/255 alpha:0.2] set];
    [path stroke];
}

@end
