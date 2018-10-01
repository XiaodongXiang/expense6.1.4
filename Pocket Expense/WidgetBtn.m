//
//  WidgetBtn.m
//  widget
//
//  Created by 晓东项 on 2018/8/10.
//

#import "WidgetBtn.h"

@interface WidgetBtn()


@end


@implementation WidgetBtn

-(UIImageView *)categoryImageView{
    if (!_categoryImageView) {
        
        _categoryImageView = [[UIImageView alloc]init];
        _categoryImageView.frame = CGRectMake((self.bounds.size.width - 50) / 2, 5, 50, 50);
        _categoryImageView.layer.cornerRadius = 22;
        _categoryImageView.layer.masksToBounds = YES;
    }
    return _categoryImageView;
}

-(UILabel *)categoryLabel{
    if (!_categoryLabel) {
        _categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 55, self.bounds.size.width - 10, 28)];
        _categoryLabel.font = [UIFont systemFontOfSize:12];
        _categoryLabel.numberOfLines = 0;
        _categoryLabel.minimumScaleFactor = 0.8;
        _categoryLabel.adjustsFontSizeToFitWidth = YES;
        _categoryLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _categoryLabel;
}

-(void)setCategory:(Category *)category{
    _category = category;
    if (category) {
        self.categoryImageView.image = [UIImage imageNamed:category.iconName];
        self.categoryLabel.text = category.categoryName;
    }
}
-(void)setPayee:(Payee *)payee{
    _payee = payee;
    if (payee) {
        self.categoryImageView.image = [UIImage imageNamed:payee.category.iconName];
        self.categoryLabel.text = payee.name.length>0?payee.name:payee.category.categoryName;
    }

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.categoryLabel];
        [self addSubview:self.categoryImageView];
    }
    return self;
}
@end
