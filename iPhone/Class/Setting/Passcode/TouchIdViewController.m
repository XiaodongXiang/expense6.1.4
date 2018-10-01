//
//  TouchIdViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/5.
//
//

#import "TouchIdViewController.h"

@interface TouchIdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation TouchIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPHONE_6PLUS)
    {
        _imageH.constant=320;
        _imageW.constant=320;
    }
    else
    {
        _imageW.constant=230;
        _imageH.constant=230;
    }
    
    if (IS_IPHONE_X) {
        self.imageView.image = [UIImage imageNamed:@"face id"];
        self.label.text = @"Face ID is ready.Your Face ID can be used";
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSNotification *noti=[[NSNotification alloc]initWithName:@"touchVCBack" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:noti];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
