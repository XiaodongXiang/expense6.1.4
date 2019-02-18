//
//  XDBudgetTransferViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/28.
//

#import "XDBudgetTransferViewController.h"
#import "Category.h"
#import "numberKeyboardView.h"
#import "BudgetTransfer.h"
#import "BudgetItem.h"
#import "EPNormalClass.h"
#import "ParseDBManager.h"
#import <Parse/Parse.h>
#import "PokcetExpenseAppDelegate.h"

@interface XDBudgetTransferViewController ()
{
    BudgetTemplate* _currentBt;
}
@property (weak, nonatomic) IBOutlet UIImageView *transferIcon;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *fromCategoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *toCategoryBtn;
@property (weak, nonatomic) IBOutlet UIView *navBackView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (strong, nonatomic) IBOutlet UIView *toCateView;
@property (strong, nonatomic) IBOutlet UIView *fromCateView;

@property (weak, nonatomic) IBOutlet UIImageView *fromCateIcon;
@property (weak, nonatomic) IBOutlet UILabel *fromCateName;
@property (weak, nonatomic) IBOutlet UILabel *fromCateAmount;
@property (weak, nonatomic) IBOutlet UIImageView *toCateIcon;
@property (weak, nonatomic) IBOutlet UILabel *toCateName;
@property (weak, nonatomic) IBOutlet UILabel *toCateAmount;
@property (weak, nonatomic) IBOutlet UILabel *toCateTitle;

@property(nonatomic, strong)numberKeyboardView * keyboard;

@property (weak, nonatomic) IBOutlet UITableView *budgetTableView;

@property (weak, nonatomic) IBOutlet UIView *toBudgetView;
@property(nonatomic, strong)NSArray * dataArray;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBackViewH;

@end

@implementation XDBudgetTransferViewController
@synthesize budgetTemple,residurAmount,classType;

-(numberKeyboardView *)keyboard{
    if (!_keyboard) {
        _keyboard = [[[NSBundle mainBundle]loadNibNamed:@"numberKeyboardView" owner:self options:nil]lastObject];
        __weak __typeof__(self) weakSelf = self;
        _keyboard.amountBlock = ^(NSString *string) {
//             NSLog(@"amount == %@",string);
            if ([string doubleValue] != 0.0) {
                [weakSelf.saveBtn setImage:[UIImage imageNamed:@"done_normal"] forState:UIControlStateNormal];
                weakSelf.saveBtn.enabled = YES;
            }else{
                [weakSelf.saveBtn setImage:[UIImage imageNamed:@"done_disabled"] forState:UIControlStateNormal];
                weakSelf.saveBtn.enabled = NO;
            }
            weakSelf.amountTextField.text = string;
            [weakSelf.saveBtn setImage:[UIImage imageNamed:@"done_normal"] forState:UIControlStateNormal];
        };
        _keyboard.completed = ^{
            [weakSelf saveBtnClick:nil];
        };
    }
    return _keyboard;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!classType.budgetTransfer) {
        self.fromCateIcon.image = [UIImage imageNamed:budgetTemple.category.iconName];
        self.fromCateName.text = budgetTemple.category.categoryName;
        self.fromCateAmount.text = [XDDataManager moneyFormatter:residurAmount];
        
        self.toCateTitle.text  = @"Select Target Budget";
    }else{
        self.fromCateIcon.image = [UIImage imageNamed:classType.budgetTransfer.fromBudget.budgetTemplate.category.iconName];
        self.fromCateName.text = classType.budgetTransfer.fromBudget.budgetTemplate.category.categoryName;
        self.fromCateAmount.text = [XDDataManager moneyFormatter:residurAmount];
        
        self.toCateIcon.image = [UIImage imageNamed:classType.budgetTransfer.toBudget.budgetTemplate.category.iconName];
        self.toCateName.text = classType.budgetTransfer.toBudget.budgetTemplate.category.categoryName;
        self.toCateAmount.text = [XDDataManager moneyFormatter:[classType.budgetTransfer.amount doubleValue]];
        
        _currentBt = classType.budgetTransfer.toBudget.budgetTemplate;
        self.amountTextField.text = [NSString stringWithFormat:@"%.2f",[classType.budgetTransfer.amount doubleValue]];
        
        self.saveBtn.enabled = YES;
        [self.saveBtn setImage:[UIImage imageNamed:@"done_normal"] forState:UIControlStateNormal];
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fromCategoryBtn.frame = CGRectMake(0, 160, SCREEN_WIDTH/2+10, 115);
    self.toCategoryBtn.frame = CGRectMake( SCREEN_WIDTH/2-11, 160, SCREEN_WIDTH/2+11, 115);
    
    if (IS_IPHONE_X) {
        self.navBackViewH.constant = 184;
        self.fromCategoryBtn.y = 184;
        self.toCategoryBtn.y = 184;
        
    }
    self.transferIcon.image = [[UIImage imageNamed:@"iocn_transfer"] imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.fromCategoryBtn.frame), SCREEN_WIDTH, 0.5);

    self.toCateView.frame = CGRectMake(0, 0, self.fromCategoryBtn.width, self.fromCategoryBtn.height);
    self.toCateView.centerX =self.fromCategoryBtn.width/2;
    [self.toCategoryBtn addSubview:self.toCateView];
    
    self.fromCateView.frame = CGRectMake(0, 0, self.fromCategoryBtn.width, self.fromCategoryBtn.height);
    self.fromCateView.centerX =self.fromCategoryBtn.width/2;
    [self.fromCategoryBtn addSubview:self.fromCateView];
    
    [self.amountTextField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] forKeyPath:@"_placeholderLabel.textColor"];
    self.toCateView.userInteractionEnabled = NO;
    
    self.amountTextField.inputView = self.keyboard;
    if (IS_IPHONE_X) {
        self.amountTextField.inputView.transform = CGAffineTransformMakeTranslation(0, -34);
    }
    NSMutableArray* muArr = [NSMutableArray arrayWithArray:[[XDDataManager shareManager]getObjectsFromTable:@"BudgetTemplate" predicate:[NSPredicate predicateWithFormat:@"isNew = 1 and state = %@",@"1"] sortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES]]]];
    [muArr removeObject:budgetTemple];
    self.dataArray = muArr;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.coverView addGestureRecognizer:tap];
    
    self.budgetTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.amountTextField becomeFirstResponder];

}

-(void)tapClick{
    [UIView animateWithDuration:0.2 animations:^{
        self.toBudgetView.y = self.view.height ;
        self.coverView.alpha = 0;
        self.toCategoryBtn.selected = NO;

    }completion:^(BOOL finished) {
        self.coverView.hidden = YES;
    }];
}


- (IBAction)saveBtnClick:(id)sender {
    [self.view endEditing:YES];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"09_BGT_ADJ"];

    if (!_currentBt) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_To Budget is required.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    BudgetItem* fromItem = [[budgetTemple.budgetItems allObjects]lastObject];
    BudgetItem* toItem = [[_currentBt.budgetItems allObjects]lastObject];
    
    if (classType) {
        
        classType.budgetTransfer.amount = @([self.amountTextField.text doubleValue]);
        classType.budgetTransfer.updatedTime = classType.budgetTransfer.dateTime_sync = [NSDate date];

        [classType.budgetTransfer.fromBudget removeFromTransferObject:classType.budgetTransfer];
        [classType.budgetTransfer.toBudget removeToTransferObject:classType.budgetTransfer];
        if(fromItem!=nil)
        {
            [fromItem addFromTransferObject:classType.budgetTransfer];
        }
        if(toItem!=nil)
        {
            [toItem addToTransferObject:classType.budgetTransfer];
        }
        
        classType.budgetTransfer.fromBudget = fromItem;
        classType.budgetTransfer.toBudget = toItem;
        
        [[XDDataManager shareManager] saveContext];
        
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBudgetTransfer:classType.budgetTransfer];
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"09_BGT_TSF"];
        }
        
        if ([self.delegate respondsToSelector:@selector(returnBudgetTransfer:)]) {
            [self.delegate returnBudgetTransfer:classType];
        }

    }else{
        BudgetTransfer* transfer = [[XDDataManager shareManager] insertObjectToTable:@"BudgetTransfer"];
        transfer.amount = @([self.amountTextField.text doubleValue]);
        transfer.dateTime = [NSDate date];
        transfer.updatedTime = transfer.dateTime_sync = [NSDate date];
        transfer.uuid = [EPNormalClass GetUUID];
        transfer.state = @"1";
        
         if (fromItem) {
            [fromItem addFromTransferObject:transfer];
        }
        if (toItem) {
            [toItem addToTransferObject:transfer];
        }
        
        transfer.fromBudget = fromItem;
        transfer.toBudget = toItem;
        
        [[XDDataManager shareManager] saveContext];
        
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBudgetTransfer:transfer];
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"09_BGT_TSF"];
        }
        
        BudgetDetailClassType* class = [[BudgetDetailClassType alloc]init];
        class.budgetTransfer = transfer;
        class.date = transfer.dateTime;
        class.dct = DetailClassTypeFromTransfer;
        
        if ([self.delegate respondsToSelector:@selector(returnBudgetTransfer:)]) {
            [self.delegate returnBudgetTransfer:class];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addTransfer" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)cancelBtnClick:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)toCategoryBtnClick:(id)sender {
    UIButton* btn = sender;
    btn.selected = !btn.selected;
    [self.amountTextField resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (btn.selected) {
            self.coverView.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.toBudgetView.y = self.view.height - 330;
                self.coverView.alpha = 0.5;
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.toBudgetView.y = self.view.height ;
                self.coverView.alpha = 0;
            }completion:^(BOOL finished) {
                self.coverView.hidden = YES;
            }];
        }
    });
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.font = [UIFont fontWithName:FontSFUITextRegular size:16];
    cell.textLabel.textColor = RGBColor(85, 85, 85);
    BudgetTemplate* bt = self.dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:bt.category.iconName];
    cell.textLabel.text = bt.category.categoryName;
    cell.detailTextLabel.text = [XDDataManager moneyFormatter:[bt.amount doubleValue]];
    if (bt == _currentBt) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _currentBt = self.dataArray[indexPath.row];
    
    self.toCateIcon.image = [UIImage imageNamed:_currentBt.category.iconName];
    self.toCateName.text = _currentBt.category.categoryName;
    self.toCateAmount.text = [XDDataManager moneyFormatter:[_currentBt.amount doubleValue]];
    self.toCateTitle.text = @"";
    
    [self tapClick];
}


@end
