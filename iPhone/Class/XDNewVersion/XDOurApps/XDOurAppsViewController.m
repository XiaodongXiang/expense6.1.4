//
//  XDOurAppsViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/6.
//

#import "XDOurAppsViewController.h"
@interface XDOurAppsViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *thirdCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *forthCell;
@property (weak, nonatomic) IBOutlet UIView *secondBackView;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIView *thirdBackView;
@property (weak, nonatomic) IBOutlet UIView *fourthBackView;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;
@property (weak, nonatomic) IBOutlet UIView *firstBackView;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;

@end

@implementation XDOurAppsViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.topView.layer addSublayer:[UIColor setGradualChangingColor:self.topView fromColor:RGBColor(129, 177, 255) toColor:RGBColor(82, 147, 252)]];

    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(5, 20, 44, 44);
    if (IS_IPHONE_X) {
        cancelBtn.y = 40;
        self.topViewH.constant = 180;
    }
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:cancelBtn];
    
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(cancelBtn.frame), 200, 30)];
    lable.font = [UIFont boldSystemFontOfSize:24];
    lable.textColor = [UIColor whiteColor];
    lable.text = @"OUR APPS";
    [self.topView addSubview:lable];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
   
    
    self.firstBackView.layer.cornerRadius = self.thirdBackView.layer.cornerRadius = self.fourthBackView.layer.cornerRadius = self.secondBackView.layer.cornerRadius = 10;
    self.firstBackView.layer.shadowOffset = self.thirdBackView.layer.shadowOffset = self.fourthBackView.layer.shadowOffset = self.secondBackView.layer.shadowOffset = CGSizeMake(0, 4);
    self.firstBackView.layer.shadowColor = self.thirdBackView.layer.shadowColor = self.fourthBackView.layer.shadowColor = self.secondBackView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.firstBackView.layer.shadowOpacity = self.thirdBackView.layer.shadowOpacity = self.fourthBackView.layer.shadowOpacity = self.secondBackView.layer.shadowOpacity = 0.06;//阴影透明度，默认0
    self.firstBackView.layer.shadowRadius = self.thirdBackView.layer.shadowRadius = self.fourthBackView.layer.shadowRadius = self.secondBackView.layer.shadowRadius = 18;//阴影半径，默认3
    self.firstBackView.layer.masksToBounds = self.thirdBackView.layer.masksToBounds = self.fourthBackView.layer.masksToBounds = self.secondBackView.layer.masksToBounds = NO;
    
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/hours-keeper/id563155321?mt=8"]]){
        [self.firstBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    }else{
        [self.firstBtn setImage:[UIImage imageNamed:@"get"] forState:UIControlStateNormal];
    };
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/checkbook-account-tracker/id484000695?mt=8"]]){
        [self.secondBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    }else{
        [self.secondBtn setImage:[UIImage imageNamed:@"get"] forState:UIControlStateNormal];
    };
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/scanner-now/id1193953564?mt=8"]]){
        [self.thirdBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    }else{
        [self.thirdBtn setImage:[UIImage imageNamed:@"get"] forState:UIControlStateNormal];
    };
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/fax-now-send-fax-from-pocket/id1197930396?mt=8"]]){
        [self.fourthBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    }else{
        [self.fourthBtn setImage:[UIImage imageNamed:@"get"] forState:UIControlStateNormal];
    };

}

-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.firstCell;
    }else if(indexPath.row == 1){
        return self.secondCell;
    }else if (indexPath.row == 2){
        return self.thirdCell;
    }else{
        return self.forthCell;
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 120;
    }
    return 100;
}

- (IBAction)getOrOopenClick:(id)sender {
    UIButton * btn = sender;

    if (btn.tag == 1) {
        NSString *urlStr = @"https://itunes.apple.com/us/app/hours-keeper/id563155321?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];

    }else if (btn.tag == 2){
        NSString *urlStr = @"https://itunes.apple.com/us/app/checkbook-account-tracker/id484000695?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];

    }else if (btn.tag == 3){
        NSString *urlStr = @"https://itunes.apple.com/us/app/scanner-now/id1193953564?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];

    }else if (btn.tag == 4){
        NSString *urlStr = @"https://itunes.apple.com/us/app/fax-now-send-fax-from-pocket/id1197930396?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];

    }
}

@end
