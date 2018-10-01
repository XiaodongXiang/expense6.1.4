//
//  XDNewTypeTableViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/14.
//

#import "XDNewTypeTableViewController.h"
#import "AccountType.h"
#import "EPNormalClass.h"
@interface XDNewTypeTableViewController ()
{
    NSArray * _imageArr;
    NSString* _iconName;
}
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UITextField *typeNameT;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;

@end

@implementation XDNewTypeTableViewController
@synthesize accountType;

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArr = @[@"asset.png",@"cash.png",@"checking.png",@"credit-card.png",@"Debt.png",@"investing.png",@"loan.png",@"Saving.png",@"icon_other.png"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    if (accountType) {
        self.typeIcon.image = [UIImage imageNamed:accountType.iconName];
        self.typeNameT.text = accountType.typeName;
        _iconName = accountType.iconName;
    }else{
        self.typeIcon.image = [UIImage imageNamed:_imageArr[0]];
        _iconName = _imageArr[0];
    }
    [self setupSecondCell];
    
    
    [self.typeNameT becomeFirstResponder];
    self.title = @"New Type";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) title:@"Cancel" font:[UIFont fontWithName:FontSFUITextRegular size:17] titleColor:RGBColor(113, 163, 245) highlightedColor:RGBColor(113, 163, 245) titleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(saveClick) title:@"Save" font:[UIFont fontWithName:FontSFUITextRegular size:17] titleColor:RGBColor(113, 163, 245) highlightedColor:RGBColor(113, 163, 245) titleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveClick{
    if (self.typeNameT.text.length == 0) {
        return;
    }
    if (accountType) {
        accountType.typeName = self.typeNameT.text;
        accountType.iconName = _iconName;
        accountType.updatedTime = [NSDate date];
        if ([self.addDelegate respondsToSelector:@selector(updateAccountType)]) {
            [self.addDelegate updateAccountType];
        }
    }else{
        AccountType* type = [[XDDataManager shareManager] insertObjectToTable:@"AccountType"];
        type.isDefault = @(NO);
        type.uuid = [EPNormalClass GetUUID];
        type.typeName = self.typeNameT.text;
        type.iconName = _iconName;
        type.dateTime = [NSDate date];
        type.state = @"1";
        type.updatedTime = [NSDate date];
        
        if ([self.addDelegate respondsToSelector:@selector(addNewAccountType:)]) {
            [self.addDelegate addNewAccountType:type];
        }
    }
    
    [[XDDataManager shareManager]saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupSecondCell{
    CGFloat width = SCREEN_WIDTH / 5;
    CGFloat height = width;
    for (int i = 0; i < _imageArr.count; i++) {
        NSInteger x = i / 5;
        NSInteger y = i % 5;
        
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(y * width, x * height, width, height)];
        [self.secondCell.contentView addSubview:view];

        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:_imageArr[i]] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 40, 40);
        btn.center = CGPointMake(width/2, height/2);
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn ];
        
    }
    
}

-(void)btnClick:(UIButton*)btn{
    self.typeIcon.image = [UIImage imageNamed:_imageArr[btn.tag]];
    _iconName = _imageArr[btn.tag];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 166;
    }
    return 56;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return self.firstCell;
    }else{
        return self.secondCell;
    }
    
    return nil;
}

@end
