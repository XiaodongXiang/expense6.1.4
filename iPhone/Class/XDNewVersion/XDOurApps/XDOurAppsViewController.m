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
@property (weak, nonatomic) IBOutlet UIView *firstTopView;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *thirdCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *forthCell;
@property (weak, nonatomic) IBOutlet UIView *secondBackView;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIView *thirdBackView;
@property (weak, nonatomic) IBOutlet UIView *fourthBackView;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;

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
    }
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:cancelBtn];
    
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(cancelBtn.frame), 200, 30)];
    lable.font = [UIFont boldSystemFontOfSize:24];
    lable.textColor = [UIColor whiteColor];
    lable.text = @"OUR APPS";
    [self.topView addSubview:lable];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.firstTopView.layer addSublayer:[UIColor setGradualSecondChangingColor:self.firstTopView fromColor:RGBColor(129, 177, 255) toColor:RGBColor(82, 147, 252)]];
    
    UIView* firstBackView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 84)];
    firstBackView.backgroundColor = [UIColor whiteColor];
    firstBackView.layer.cornerRadius = 10;
    firstBackView.layer.shadowOffset = CGSizeMake(0, 15);
    firstBackView.layer.shadowColor = [UIColor blackColor].CGColor;
    firstBackView.layer.shadowOpacity = 0.05;//阴影透明度，默认0
    firstBackView.layer.shadowRadius = 5;//阴影半径，默认3
    firstBackView.layer.masksToBounds = NO;
    [self.firstCell addSubview:firstBackView];
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hours keeper"]];
    imageView.frame = CGRectMake(15, 12, 60, 60);
    [firstBackView addSubview:imageView];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 23, 200, 21)];
    titleLabel.font = [UIFont fontWithName:FontSFUITextMedium size:18];
    titleLabel.text = @"Hours keeper";
    
    UILabel* detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, CGRectGetMaxY(titleLabel.frame)+4, 300, 14)];
    detailLabel.font = [UIFont fontWithName:FontSFUITextRegular size:12];
    detailLabel.textColor = [UIColor lightGrayColor];
    detailLabel.text = @"Time Sheet, Pay and Invoice";
    
    [firstBackView addSubview:titleLabel];
    [firstBackView addSubview:detailLabel];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(firstBackView.width - 69, 27, 54, 30);
    [btn setImage:[UIImage imageNamed:@"get"] forState:UIControlStateNormal];
    btn.tag = 1;
    [btn addTarget:self action:@selector(getOrOopenClick:) forControlEvents:UIControlEventTouchUpInside];
    [firstBackView addSubview:btn];
    
    self.thirdBackView.layer.cornerRadius = self.fourthBackView.layer.cornerRadius = self.secondBackView.layer.cornerRadius = 10;
    self.thirdBackView.layer.shadowOffset = self.fourthBackView.layer.shadowOffset = self.secondBackView.layer.shadowOffset = CGSizeMake(0, 15);
    self.thirdBackView.layer.shadowColor = self.fourthBackView.layer.shadowColor = self.secondBackView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.thirdBackView.layer.shadowOpacity = self.fourthBackView.layer.shadowOpacity = self.secondBackView.layer.shadowOpacity = 0.05;//阴影透明度，默认0
    self.thirdBackView.layer.shadowRadius = self.fourthBackView.layer.shadowRadius = self.secondBackView.layer.shadowRadius = 5;//阴影半径，默认3
    self.thirdBackView.layer.masksToBounds = self.fourthBackView.layer.masksToBounds = self.secondBackView.layer.masksToBounds = NO;
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
    
}

@end
