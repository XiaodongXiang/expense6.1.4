//
//  XDPasswordKeyboard.m
//  PocketExpense
//
//  Created by 晓东项 on 2019/1/29.
//

#import "XDPasswordKeyboard.h"

@interface XDPasswordKeyboard ()
@property(nonatomic, strong)NSMutableString* password;

@end
@implementation XDPasswordKeyboard

-(void)awakeFromNib{
    [super awakeFromNib];

    self.password = [NSMutableString stringWithCapacity:4];

}

-(void)reset{
    self.password = [NSMutableString stringWithCapacity:4];
}
- (IBAction)deleteClick:(id)sender {
    if (self.password.length >= 1) {
        [self.password deleteCharactersInRange:NSMakeRange(self.password.length-1, 1)];
        
        if ([self.xxdDelegate respondsToSelector:@selector(returnPassword:)]) {
            [self.xxdDelegate returnPassword:self.password];
        }
    }
}

- (IBAction)btnClick:(id)sender {
    UIButton* btn = sender;
    [self.password appendFormat:@"%ld",(long)btn.tag];
    if ([self.xxdDelegate respondsToSelector:@selector(returnPassword:)]) {
        [self.xxdDelegate returnPassword:self.password];
    }
}






@end
