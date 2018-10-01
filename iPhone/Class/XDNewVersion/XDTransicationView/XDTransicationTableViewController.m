//
//  XDTransicationTableViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/10.
//

#import "XDTransicationTableViewController.h"
#import "CustomOverViewCell.h"
#import "PokcetExpenseAppDelegate.h"
#import "Payee.h"
#import "AppDelegate_iPhone.h"
#import "Category.h"
static NSString * cellID = @"cell";

@interface XDTransicationTableViewController ()<SWTableViewCellDelegate>
{
    CGFloat _startPointY;
    BOOL _isToTop;
    
    UILabel* _dateLbl;
    UILabel* _moneyLbl;
}
@property(nonatomic, strong)NSMutableArray * dataMuArr;
@property(nonatomic, strong)Category * otherCategory_income;
@end

@implementation XDTransicationTableViewController


-(Category *)otherCategory_income{
    if (!_otherCategory_income) {
        _otherCategory_income = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"isDefault = 1 and categoryType = %@",@"INCOME"] sortDescriptors:nil]lastObject];
        if (!_otherCategory_income) {
            _otherCategory_income = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"categoryName = %@ and categoryType = %@",@"Others",@"INCOME"] sortDescriptors:nil]lastObject];
            if (!_otherCategory_income) {
                _otherCategory_income = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"categoryType = %@",@"INCOME"] sortDescriptors:nil]firstObject];
            }
        }
    }
    return _otherCategory_income;
}

-(void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    
    self.dataMuArr = [NSMutableArray arrayWithArray:[[XDDataManager shareManager] getTransactionDate:selectedDate withAccount:nil]];
    
    [self.tableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor whiteColor]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];

}


#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 31;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
    view.backgroundColor = [UIColor whiteColor];
    _dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 150, 20)];
    _dateLbl.font = [UIFont systemFontOfSize:12];
    _dateLbl.textColor = RGBColor(200, 200, 200);
    [view addSubview:_dateLbl];
    
    _moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake( SCREEN_WIDTH - 215 , 5, 200, 20)];
    _moneyLbl.font = [UIFont systemFontOfSize:12];
    _moneyLbl.textAlignment = NSTextAlignmentRight;
    _moneyLbl.textColor = RGBColor(200, 200, 200);
    [view addSubview:_moneyLbl];
    
    [self calculateMoney];
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 30.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGBColor(238, 238, 238);
    [view addSubview:line];

    
    return view;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomOverViewCell *cell = (CustomOverViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell = [[CustomOverViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] ;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    cell.clipsToBounds = YES;
    
    cell.tag = indexPath.row;
    float width;
    if (IS_IPHONE_4)
    {
        width=53;
    }
    else if (IS_IPHONE_5)
    {
        width = 53;
    }
    else
    {
        width=70;
    }
    [cell setRightUtilityButtons:[self cellEditBtnsSet] WithButtonWidth:width];
    cell.delegate = self;
    
    [self configureTranscationCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.transcationDelegate respondsToSelector:@selector(returnSelectedCellTranscation:)]) {
        [self.transcationDelegate returnSelectedCellTranscation:[self.dataMuArr objectAtIndex:indexPath.row]];
    }
}

-(NSArray *)cellEditBtnsSet
{
    NSMutableArray *btns=[[NSMutableArray alloc]init];
    [btns sw_addUtilityButtonWithColor:RGBColor(200, 199, 205) normalIcon:[UIImage imageNamed:@"relevance"] selectedIcon:[UIImage imageNamed:@"relevance"]];
    [btns sw_addUtilityButtonWithColor:RGBColor(120, 123, 255) normalIcon:[UIImage imageNamed:@"copy"] selectedIcon:[UIImage imageNamed:@"copy"]];
    [btns sw_addUtilityButtonWithColor:RGBColor(254, 59, 47) normalIcon:[UIImage imageNamed:@"del"] selectedIcon:[UIImage imageNamed:@"del"]];
    return btns;
}
#pragma mark - SWTableviewCell Delegate
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    Transaction* transition = [self.dataMuArr objectAtIndex:indexPath.row];
   
    
    if (index == 2) {
        
        PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegete.epdc deleteTransactionRel:transition];

        [self.dataMuArr removeObject:transition];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUI" object:nil];

        });
        
    }else{
        if ([self.transcationDelegate respondsToSelector:@selector(returnCellSelectedBtn:index:)]) {
            [self.transcationDelegate returnCellSelectedBtn:transition index:index];
        }
    }
}



- (void)configureTranscationCell:(CustomOverViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.dataMuArr.count -1 || self.dataMuArr.count == 0) {
        return;
    }
    Transaction *transactions = [self.dataMuArr objectAtIndex:indexPath.row];
    
    if (transactions.payee != nil) {
        cell.nameLabel.text = transactions.payee.name;
    }else if ([transactions.notes length]>0)
        cell.nameLabel.text = transactions.notes;
    else
        cell.nameLabel.text = @"-";
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

   
    
    //Expense
    if([transactions.category.categoryType isEqualToString:@"EXPENSE"]  || [transactions.childTransactions count]>0)
    {
        if ([transactions.childTransactions count]>0)
        {
            cell.categoryIconImage.image = [UIImage imageNamed:@"icon_mind.png"];
            
            NSMutableArray *childTransactionArray =  [[NSMutableArray alloc]initWithArray:[transactions.childTransactions allObjects ]];
            double totalAmount = 0;
            for (int i=0; i<[childTransactionArray count]; i++)
            {
                Transaction *oneTrans = [childTransactionArray objectAtIndex:i];
                if ([oneTrans.state isEqualToString:@"1"]) {
                    totalAmount += [oneTrans.amount doubleValue];
                }
                
            }
            cell.amountLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
            cell.accountNameLabel.text =transactions.expenseAccount.accName;
            cell.amountLabel.textColor=RGBColor(240, 106, 68);
            
        }
        else
        {
            cell.categoryIconImage.image = [UIImage imageNamed:transactions.category.iconName];
            cell.amountLabel.text = [NSString stringWithFormat:@"-%@",[appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]]];
            cell.accountNameLabel.text =transactions.expenseAccount.accName;
            cell.amountLabel.textColor=RGBColor(240, 106, 68);

            if (transactions.incomeAccount && transactions.expenseAccount && transactions.transactionType == nil) {
                cell.categoryIconImage.image = [UIImage imageNamed:@"iocn_transfer.png"];
                [cell.amountLabel setTextColor:[appDelegate_iPhone.epnc getAmountGrayColor]];
                
                NSString *expenseName = [transactions.expenseAccount.accName uppercaseString];
                NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
                
                cell.accountNameLabel.text = [NSString stringWithFormat:@"%@ > %@",expenseName,incomeString];
                
                cell.amountLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
                
            }
        }
//        NSString *expenseName = [transactions.expenseAccount.accName uppercaseString];
        
    }
    //Income
    else if([transactions.category.categoryType isEqualToString:@"INCOME"])
    {
        cell.categoryIconImage.image = [UIImage imageNamed:transactions.category.iconName];
        cell.amountLabel.textColor=RGBColor(19, 200, 48);
        
//        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
        cell.accountNameLabel.text = transactions.incomeAccount.accName;
        
        cell.amountLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
        
        if (transactions.expenseAccount && transactions.incomeAccount && ![transactions.transactionType isEqualToString:@"income"]) {
            cell.categoryIconImage.image = [UIImage imageNamed:@"iocn_transfer.png"];
            [cell.amountLabel setTextColor:[appDelegate_iPhone.epnc getAmountGrayColor]];
            
            NSString *expenseName = [transactions.expenseAccount.accName uppercaseString];
            NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
            
            cell.accountNameLabel.text = [NSString stringWithFormat:@"%@ > %@",expenseName,incomeString];
            
            cell.amountLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
            
        }
    }
    //transfer
    else
    {
        cell.categoryIconImage.image = [UIImage imageNamed:@"iocn_transfer.png"];
        [cell.amountLabel setTextColor:[appDelegate_iPhone.epnc getAmountGrayColor]];
        
        NSString *expenseName = [transactions.expenseAccount.accName uppercaseString];
        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
        
        cell.accountNameLabel.text = [NSString stringWithFormat:@"%@ > %@",expenseName,incomeString];
        
        cell.amountLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
        
        if (transactions.category == nil && ![transactions.transactionType isEqualToString:@"transfer"]) {
            if (transactions.expenseAccount && transactions.incomeAccount == nil) {
                    cell.categoryIconImage.image = [UIImage imageNamed:@"icon_mind_white"];
                    cell.amountLabel.text = [NSString stringWithFormat:@"-%@",[appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]]];
                    cell.accountNameLabel.text = transactions.expenseAccount.accName;
                    cell.amountLabel.textColor=RGBColor(240, 106, 68);
                }else if(transactions.incomeAccount != nil && transactions.expenseAccount == nil  && [transactions.transactionType isEqualToString:@"income"]){
                    if (transactions.payee.category) {
                        if ([transactions.payee.category.categoryType isEqualToString:@"EXPENSE"]) {
                            cell.categoryIconImage.image = [UIImage imageNamed:transactions.payee.category.iconName];
                            cell.amountLabel.textColor=RGBColor(240, 106, 68);
                            
                            //        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
                            cell.nameLabel.text = transactions.payee.name?:@"-";
                            cell.accountNameLabel.text = transactions.expenseAccount.accName;

                            cell.amountLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
                            
                        }else if ([transactions.payee.category.categoryType isEqualToString:@"INCOME"]){
                            cell.categoryIconImage.image = [UIImage imageNamed:transactions.payee.category.iconName];
                            cell.amountLabel.textColor=RGBColor(19, 200, 48);
                            cell.accountNameLabel.text = transactions.incomeAccount.accName;

                            //        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
                            cell.nameLabel.text = transactions.payee.name?:@"-";
                            
                            cell.amountLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
                            
                        }
                    }else{
                        cell.categoryIconImage.image = [UIImage imageNamed:self.otherCategory_income.iconName];
                        cell.amountLabel.textColor=RGBColor(19, 200, 48);
                        cell.accountNameLabel.text = transactions.incomeAccount.accName;

                        //        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
                        cell.nameLabel.text = transactions.payee.name?:@"-";
                        
                        cell.amountLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
                        
                    }
                }
            }
    }
    if (![transactions.recurringType isEqualToString:@"Never"]) {
        cell.cycleImageView.hidden = NO;
        [cell.contentView bringSubviewToFront:cell.cycleImageView];
        float width = IS_IPHONE_5?210:250;
        if (cell.accountNameLabel.x + [self calculateRowWidth:cell.accountNameLabel.text] > width) {
            width = IS_IPHONE_5?210:250 + cell.accountNameLabel.x - 5;
        }else{
            width = cell.accountNameLabel.x + [self calculateRowWidth:cell.accountNameLabel.text];
        }
        cell.cycleImageView.frame = CGRectMake(width + 5, cell.accountNameLabel.y, 20, 20);
                    
    }else{
        cell.cycleImageView.hidden = YES;

    }
    
    if (transactions.notes.length > 0) {
        cell.memoImage.hidden = NO;
        [cell.contentView bringSubviewToFront:cell.memoImage];
        float width = IS_IPHONE_5?210:250;
        if (cell.accountNameLabel.x + [self calculateRowWidth:cell.accountNameLabel.text] > width) {
            width = IS_IPHONE_5?210:250 + cell.accountNameLabel.x - 5;
        }else{
            width = cell.accountNameLabel.x + [self calculateRowWidth:cell.accountNameLabel.text];
        }
        cell.memoImage.frame = CGRectMake(width + 20 + 5 , cell.accountNameLabel.y, 20, 20);
        
    }else{
        cell.memoImage.hidden = YES;
    }
}

- (CGFloat)calculateRowWidth:(NSString *)string {
    if (string.length <= 0) {
        return 0;
    }
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:FontSFUITextRegular size:14]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(IS_IPHONE_5?210:250, 16)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |  NSStringDrawingUsesFontLeading attributes:dic context:nil];    return rect.size.width;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (_startPointY > offsetY) {
        _isToTop = NO;
    }else{
        _isToTop = YES;
    }

    if (offsetY < -30.f && !_isToTop) {
        if ([self.transcationDelegate respondsToSelector:@selector(returnDragContentOffset:)]) {
            [self.transcationDelegate returnDragContentOffset:offsetY];
        }
    }

    CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataMuArr.count inSection:0]];
    CGFloat tableViewContentY = rect.size.height + 30 - offsetY;

    if (offsetY > tableViewContentY && _isToTop) {
        if ([self.transcationDelegate respondsToSelector:@selector(returnDragContentOffset:)]) {
            [self.transcationDelegate returnDragContentOffset:offsetY];
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;

    _startPointY = offsetY;
}

-(void)calculateMoney{
    double amount = 0;
    for (Transaction* transactions in self.dataMuArr) {
        if (transactions.parTransaction == nil) {
//            if ([tran.transactionType isEqualToString:@"income"] || ((tran.expenseAccount == nil && tran.incomeAccount != nil)&&[tran.category.categoryType isEqualToString:@"INCOME"])) {
//                amount += [tran.amount doubleValue];
//            }else if([tran.transactionType isEqualToString:@"expense"] || ((tran.expenseAccount != nil && tran.incomeAccount == nil)&&[tran.category.categoryType isEqualToString:@"EXPENSE"])){
//                amount -= [tran.amount doubleValue];
//            }
            
            if ([transactions.transactionType isEqualToString:@"income"] || ((transactions.expenseAccount == nil && transactions.incomeAccount != nil)&&[transactions.category.categoryType isEqualToString:@"INCOME"])) {
                if (transactions.incomeAccount && transactions.expenseAccount && transactions.category) {
                    if ([transactions.category.categoryType isEqualToString:@"EXPENSE"]) {
                          amount -= [transactions.amount doubleValue];
//                        onetotal -= [transactions.amount doubleValue];
//                        oneSpent += [transactions.amount doubleValue];
//                        totalSpend+=[transactions.amount doubleValue];
                        
                    }else if([transactions.category.categoryType isEqualToString:@"INCOME"]){
                         amount += [transactions.amount doubleValue];
                        
//                        onetotal += [transactions.amount doubleValue];
//                        oneIncome += [transactions.amount doubleValue];
//                        totalIncome+=[transactions.amount doubleValue];
                    }
                    
                }else{
                    if (transactions.incomeAccount == nil && transactions.expenseAccount) {
                          amount -= [transactions.amount doubleValue];
//                        onetotal -= [transactions.amount doubleValue];
//                        oneSpent += [transactions.amount doubleValue];
//                        totalSpend+=[transactions.amount doubleValue];
                    }else{
                        amount += [transactions.amount doubleValue];
                        
//                        onetotal += [transactions.amount doubleValue];
//                        oneIncome += [transactions.amount doubleValue];
//                        totalIncome+=[transactions.amount doubleValue];
                    }
                }
                
            }else if([transactions.transactionType isEqualToString:@"expense"] || ((transactions.expenseAccount != nil && transactions.incomeAccount == nil)&&[transactions.category.categoryType isEqualToString:@"EXPENSE"])){
                amount -= [transactions.amount doubleValue];
            }
        }
    }
    _moneyLbl.text = [XDDataManager moneyFormatter:amount];

//    if (amount<0) {
//        _moneyLbl.textColor = RGBColor(240, 106, 68);
//    }else if(amount > 0){
//        _moneyLbl.textColor = RGBColor(19, 200, 48);
//    }else{
//        _moneyLbl.textColor = RGBColor(85, 85, 85);
//    }
    _moneyLbl.textColor = RGBColor(85, 85, 85);

    
    if ([[_selectedDate initDate] compare:[[NSDate date]initDate]] == NSOrderedSame) {
        _dateLbl.text = @"Today";
    }else{
        _dateLbl.text = [self returnInitDate:_selectedDate];
    }
    
    
}

-(NSString*)returnInitDate:(NSDate*)date{
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:date];
    
    NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"ccc, LLL d, yyyy";
    NSString* dateStr = [formatter stringFromDate:newDate];
    
    return dateStr;
    
}

@end
