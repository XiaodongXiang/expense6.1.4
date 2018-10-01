//
//  XDCategoryBtn.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/24.
//

#import "XDCategoryBtn.h"

@interface XDCategoryBtn()

@property(nonatomic, strong)UIImageView* categoryImageView;
@property(nonatomic, strong)UILabel * titleLbl;

@end

@implementation XDCategoryBtn

-(void)setCategory:(Category *)category{
    if (_category != category) {
        _category = category;
        self.categoryImageView.image = [UIImage imageNamed:category.iconName];
        self.titleLbl.text = category.categoryName;
    }
}

-(UIImageView *)categoryImageView{
    if (!_categoryImageView) {
        _categoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 45, 45)];
        if (IS_IPHONE_5) {
            _categoryImageView.y = 5;
        }
        _categoryImageView.centerX = self.width/2;
    }
    return _categoryImageView;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, self.width-10, 30)];
        _titleLbl.textColor = [UIColor lightGrayColor];
        _titleLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
        _titleLbl.adjustsFontSizeToFitWidth = YES;
        _titleLbl.minimumScaleFactor = 0.6;
        _titleLbl.numberOfLines = 2;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.centerX = self.width/2;
        if (IS_IPHONE_5) {
            _titleLbl.y = 50;
        }
        
    }
    return _titleLbl;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.categoryImageView];
        [self addSubview:self.titleLbl];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}


-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        [self setBackgroundColor:RGBColor(246, 246, 246)];
    }else{
        [self setBackgroundColor:[UIColor whiteColor]];
        
    }
}


@end
