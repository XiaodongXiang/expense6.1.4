//
//  XDAccountTableView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/9.
//

#import "XDAccountTableView.h"
#import "XDAccountDetailTableViewCell.h"
#import "Accounts.h"
#import "Transaction.h"
#import "AccountCount.h"
#import "Category.h"
#import "PokcetExpenseAppDelegate.h"
@interface XDAccountTableView()<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>

@property(nonatomic, strong)NSFetchedResultsController * fetchResultController;
@property(nonatomic, strong)NSArray * headViewMuArr;
@property(nonatomic, strong)NSArray * headDateMuArr;

@property(nonatomic, strong)NSArray * clearedMuArr;
@property(nonatomic, strong)NSArray * hideArr;

@property(nonatomic, strong)UILabel * startBalanceLbl;
@property(nonatomic, strong)UIView* footView;


@end
@implementation XDAccountTableView

-(void)setRecondile:(BOOL)recondile{
    _recondile = recondile;
    [self reloadData];
}

-(void)setHide:(BOOL)hide{
    _hide = hide;
    [self getAccountTransaction];
    [self reloadData];
}


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        self.tableFooterView = self.footView;
        
        UIView* sview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        sview.backgroundColor = RGBColor(226, 226, 226);
        [self.footView addSubview:sview];
        
        self.startBalanceLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 20)];
        self.startBalanceLbl.font = [UIFont fontWithName:FontSFUITextRegular size:14];
        self.startBalanceLbl.textColor = RGBColor(200, 200, 200);
        self.startBalanceLbl.textAlignment = NSTextAlignmentRight;
        
        [self.footView addSubview:self.startBalanceLbl];
        
        self.separatorColor = RGBColor(226 , 226 , 226);
        
        
    }
    return self;
}

-(void)setAccounts:(AccountCount *)accounts{
    _accounts = accounts;
    [self getAccountTransaction];

    self.startBalanceLbl.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"VC_StartBalance", nil),[XDDataManager moneyFormatter:[accounts.accountsItem.amount doubleValue]]];
    [self reloadData];
    
}

-(void)refreshUI{
    [self getAccountTransaction];
    [self reloadData];
}

-(void)getAccountTransaction{
    
    
    NSDictionary *sub = [NSDictionary dictionaryWithObjectsAndKeys:_accounts.accountsItem,@"incomeAccount",_accounts.accountsItem,@"expenseAccount",nil];
    
    NSFetchRequest * fetchRequest = [[XDDataManager shareManager].managedObjectModel 
                                     fetchRequestFromTemplateWithName:@"getAllTranscationByAccount" substitutionVariables:sub];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO]; // generate a description that describe which field you want to sort by
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[XDDataManager shareManager].managedObjectContext sectionNameKeyPath:@"groupByDateString" cacheName:@"Root"];
    NSError * error=nil;
    [aFetchedResultsController performFetch:&error];
    
    self.fetchResultController = aFetchedResultsController;
    
    NSMutableArray* muArray = [NSMutableArray array];
    NSMutableArray* dateMuArr = [NSMutableArray array];
    NSMutableArray* clearMuArr = [NSMutableArray array];
    NSMutableArray* childClearMuArr = [NSMutableArray array];
    double amount = [_accounts.accountsItem.amount doubleValue];
    for (long j=[[self.fetchResultController sections] count]-1; j>=0;j--)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchResultController sections] objectAtIndex:j];

        NSDate* date = nil;
        NSMutableArray* muArr = [NSMutableArray array];
        
        NSMutableArray* hideMuArr = [NSMutableArray array];
        NSMutableArray* childHideMuArr = [NSMutableArray array];
        
        for (long k=[sectionInfo numberOfObjects]-1; k>=0; k--)
        {
            Transaction *transactions = (Transaction *)[[sectionInfo objects]objectAtIndex:k];
            date = transactions.dateTime;
            if ([transactions.transactionType isEqualToString:@"income"] || ((transactions.expenseAccount == nil && transactions.incomeAccount != nil)&&[transactions.category.categoryType isEqualToString:@"INCOME"])) {
                if (transactions.incomeAccount && transactions.expenseAccount && transactions.category) {
                    if ([transactions.category.categoryType isEqualToString:@"EXPENSE"]) {
                        amount -= [transactions.amount doubleValue];
                    }else if([transactions.category.categoryType isEqualToString:@"INCOME"]){
                        amount += [transactions.amount doubleValue];
                    }
                }else{
                    if (transactions.incomeAccount == nil && transactions.expenseAccount) {
                        amount -= [transactions.amount doubleValue];
                    }else{
                        amount += [transactions.amount doubleValue];
                    }
                }
            }else if([transactions.transactionType isEqualToString:@"expense"] || ((transactions.expenseAccount != nil && transactions.incomeAccount == nil)&&[transactions.category.categoryType isEqualToString:@"EXPENSE"])){
                if (transactions.category == nil && transactions.incomeAccount && transactions.expenseAccount) {
                    if (transactions.incomeAccount == _accounts.accountsItem) {
                        amount += [transactions.amount doubleValue];
                    }else if (transactions.expenseAccount == _accounts.accountsItem){
                        amount -= [transactions.amount doubleValue];
                    }
                }else{
                    amount -= [transactions.amount doubleValue];
                }
            }else{
                if (transactions.incomeAccount == _accounts.accountsItem) {
                    amount += [transactions.amount doubleValue];
                }else if (transactions.expenseAccount == _accounts.accountsItem){
                    amount -= [transactions.amount doubleValue];
                }
            }
            [muArr addObject:@(amount)];
            
            if (_hide && ![transactions.isClear boolValue]) {
                [hideMuArr addObject:transactions];
                [childHideMuArr addObject:@(amount)];
            }
        }
        [muArray addObject:[[muArr reverseObjectEnumerator] allObjects]];
        [dateMuArr addObject:[self returnInitDate:date]];
        
        if (hideMuArr.count > 0) {
//            [clearMuArr addObject:[[hideMuArr reverseObjectEnumerator] allObjects]];
//            [childClearMuArr addObject:[[childHideMuArr reverseObjectEnumerator]allObjects]];

            
            [clearMuArr addObject:hideMuArr];
            [childClearMuArr addObject:childHideMuArr];
        }
    }
    
    self.headDateMuArr = [NSArray array];
    self.headViewMuArr = [NSArray array];
    if (muArray.count > 0) {
        self.headViewMuArr = [[muArray reverseObjectEnumerator]allObjects];
        self.headDateMuArr = [[dateMuArr reverseObjectEnumerator]allObjects];
    }
    
    self.clearedMuArr = [NSArray array];
    self.hideArr = [NSArray array];
    if (clearMuArr.count > 0) {
        self.clearedMuArr = [[clearMuArr reverseObjectEnumerator]allObjects];
        self.hideArr = [[childClearMuArr reverseObjectEnumerator]allObjects];
    }
}



#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([[self.fetchResultController sections]count]>0)
    {
        return 36.0;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_hide) {
        
        if (self.clearedMuArr.count>0) {
            if ([self.clearedMuArr[section] count]>0) {
                Transaction* tran = [self.clearedMuArr[section]firstObject];
                
                UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
                headerView.backgroundColor = RGBColor(246, 246, 246);
                //            id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchResultController sections]objectAtIndex:section];
                
                UILabel *headetLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 150, 22)];
                headetLabel.text = [self returnInitDate:tran.dateTime];
                [headetLabel setFont:[UIFont fontWithName:FontSFUITextRegular size:12.0]];
                [headetLabel setTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:170.f/255.f alpha:1]];
                [headetLabel setTextAlignment:NSTextAlignmentLeft];
                headetLabel.backgroundColor = [UIColor clearColor];
                [headerView addSubview:headetLabel];
                
                //            UIView *topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, EXPENSE_SCALE)];
                //            topLine.backgroundColor=[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
                //            [headerView addSubview:topLine];
                //
                //            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
                //            line.backgroundColor = [UIColor colorWithRed:216/255.f green:216/255.f blue:216/255.f alpha:1];
                //            [headerView addSubview:line];
                return headerView;
            }
            
        }
    }else{
        if ([[self.fetchResultController sections]count]>0) {
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
            headerView.backgroundColor = RGBColor(246, 246, 246);
            id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchResultController sections]objectAtIndex:section];
            
            UILabel *headetLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 150, 22)];
            headetLabel.text = sectionInfo.name;
            [headetLabel setFont:[UIFont fontWithName:FontSFUITextRegular size:12.0]];
            [headetLabel setTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:170.f/255.f alpha:1]];
            [headetLabel setTextAlignment:NSTextAlignmentLeft];
            headetLabel.backgroundColor = [UIColor clearColor];
            [headerView addSubview:headetLabel];
            
//            UIView *topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, EXPENSE_SCALE)];
//            topLine.backgroundColor=[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
//            [headerView addSubview:topLine];
//
//            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
//            line.backgroundColor = [UIColor colorWithRed:216/255.f green:216/255.f blue:216/255.f alpha:1];
//            [headerView addSubview:line];
            return headerView;
        }
    }
        return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_hide) {
        if (self.clearedMuArr.count>0) {
            self.footView.hidden = NO;
        }else{
            self.footView.hidden = YES;
        }
    }else{
        if ([[self.fetchResultController sections] count]>0) {
            self.footView.hidden = NO;
        }else{
            self.footView.hidden = YES;
        }
    }
    return _hide?self.clearedMuArr.count:[[self.fetchResultController sections] count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _hide?[self.clearedMuArr[section]count]:[[[self.fetchResultController sections]objectAtIndex:section] numberOfObjects];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    XDAccountDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDAccountDetailTableViewCell" owner:self options:nil]lastObject];
    }
    
    [cell setRightUtilityButtons:[self cellEditBtnsSet] WithButtonWidth:70];
    cell.delegate = self;
    
    cell.cleared = _recondile;
    if (_hide) {
        if (indexPath.section < [self.clearedMuArr count] && indexPath.row < [self.clearedMuArr[indexPath.section] count]) {
            Transaction* transaction = self.clearedMuArr[indexPath.section][indexPath.row];
            cell.account = _accounts.accountsItem;
            cell.transaction = transaction;
            cell.tranBalance.text = [XDDataManager moneyFormatter:[self.hideArr[indexPath.section][indexPath.row] doubleValue]];
        }
    }else{
        if (indexPath.row <  [[[[self.fetchResultController sections] objectAtIndex:indexPath.section] objects] count] && indexPath.section < [[self.fetchResultController sections] count]) {
            Transaction* transaction = [[[[self.fetchResultController sections] objectAtIndex:indexPath.section] objects] objectAtIndex:indexPath.row];
            cell.account = _accounts.accountsItem;
            cell.transaction = transaction;
            cell.tranBalance.text = [XDDataManager moneyFormatter:[self.headViewMuArr[indexPath.section][indexPath.row] doubleValue]];
        }
    }
    
    return cell;
}
-(NSArray *)cellEditBtnsSet
{
    NSMutableArray *btns=[[NSMutableArray alloc]init];
    [btns sw_addUtilityButtonWithColor:RGBColor(200, 199, 205) normalIcon:[UIImage imageNamed:@"relevance"] selectedIcon:[UIImage imageNamed:@"relevance"]];
    [btns sw_addUtilityButtonWithColor:RGBColor(120, 123, 255) normalIcon:[UIImage imageNamed:@"copy"] selectedIcon:[UIImage imageNamed:@"copy"]];
    [btns sw_addUtilityButtonWithColor:RGBColor(254, 59, 47) normalIcon:[UIImage imageNamed:@"del"] selectedIcon:[UIImage imageNamed:@"del"]];
    return btns;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_hide) {
        Transaction* transaction = self.clearedMuArr[indexPath.section][indexPath.row];
        if ([self.xxdDelegate respondsToSelector:@selector(returnSelectedAccountTransaction:)]) {
            [self.xxdDelegate returnSelectedAccountTransaction:transaction];
        }
    }else{
        Transaction* transaction = [[[[self.fetchResultController sections] objectAtIndex:indexPath.section] objects] objectAtIndex:indexPath.row];
        if ([self.xxdDelegate respondsToSelector:@selector(returnSelectedAccountTransaction:)]) {
            [self.xxdDelegate returnSelectedAccountTransaction:transaction];
        }
    }
    
}
#pragma mark - SWTableviewCell Delegate
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath* indexPath = [self indexPathForCell:cell];
    Transaction* transaction;
    if (_hide) {
        transaction = self.clearedMuArr[indexPath.section][indexPath.row];
        }else{
        transaction = [[[[self.fetchResultController sections] objectAtIndex:indexPath.section] objects] objectAtIndex:indexPath.row];
        }
    if (index == 2) {
        PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegete.epdc deleteTransactionRel:transaction];
        
        [self getAccountTransaction];
        
        [self reloadData];
        
        if ([self.xxdDelegate respondsToSelector:@selector(returnSwipeBtn:withTran:)]) {
            [self.xxdDelegate returnSwipeBtn:index withTran:nil];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUI" object:nil];

    }else{
        if ([self.xxdDelegate respondsToSelector:@selector(returnSwipeBtn:withTran:)]) {
            [self.xxdDelegate returnSwipeBtn:index withTran:transaction];
        }
    }
}

-(NSString*)returnInitDate:(NSDate*)date{
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:date];
    
    NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MMMM yyyy";
    NSString* dateStr = [formatter stringFromDate:newDate];
    
    return dateStr;
    
}

@end
