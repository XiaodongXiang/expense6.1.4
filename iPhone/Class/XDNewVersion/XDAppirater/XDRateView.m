//
//  XDRateView.m
//  PocketExpense
//
//  Created by 下大雨 on 2018/7/23.
//

#import "XDRateView.h"

@interface XDRateView()
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation XDRateView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];

}

- (IBAction)cancelClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if ([self.xxDelegate respondsToSelector:@selector(cancelApp)]) {
            [self.xxDelegate cancelApp];
        }
    }];
}
- (IBAction)yesClick:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    
        if ([self.xxDelegate respondsToSelector:@selector(likeApp)]) {
            [self.xxDelegate likeApp];
        }
        
    }];
}

- (IBAction)noClick:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if ([self.xxDelegate respondsToSelector:@selector(hateApp)]) {
            [self.xxDelegate hateApp];
        }
       
    }];
    
    
}

@end
