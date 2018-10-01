//
//  touchIDViewController_iPad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/20.
//
//

#import "touchIDViewController_iPad.h"

@interface touchIDViewController_iPad ()

@end

@implementation touchIDViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
