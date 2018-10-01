//
//  XDBillCalView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/4/9.
//

#import "XDBillCalView.h"
#import "XDCalendarClass.h"
#import "Setting+CoreDataClass.h"
#import "XDBillCalCollectionViewCell.h"
#import "AppDelegate_iPhone.h"
#import "EP_BillRule.h"
#import "BillFather.h"
#import "EP_BillItem.h"
#import "CustomBillCell.h"
#import "BillsViewController.h"

@interface XDBillCalView()<UICollectionViewDelegate,UICollectionViewDataSource,XDBillCalCollectionDelegate>
{
    NSArray * _dataArr;
    NSDate* _selectedDate;
    NSMutableArray* _totalMuArray;
    NSDate* _currentMonthDate;
}
@property(nonatomic, strong)UICollectionView * collectionView;

@end

@implementation XDBillCalView

static NSString* const cellID = @"monthCell";


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArr = [NSArray arrayWithArray:[[XDCalendarClass shareCalendarClass] dateArray]];
        _selectedDate = [[XDCalendarClass shareCalendarClass] getCurrentDayInitDay];
        [self setupWeekLabel];
        [self setupCollectionView];
        
        [self returnDataWithCurrentMonth:[[NSDate date]initDate]];
        _currentMonthDate = [[NSDate date]initDate];

    }
    return self;
}


-(void)setupWeekLabel{
    
    Setting * setting = [[[XDDataManager shareManager] getObjectsFromTable:@"Setting"]lastObject];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *weekdayNames = [dateFormatter shortWeekdaySymbols];
    CGFloat width = ([[UIScreen mainScreen] bounds].size.width/7.f);
    
    NSMutableArray* muarr = [NSMutableArray arrayWithArray:weekdayNames];
    [muarr removeObjectAtIndex:0];
    [muarr addObject:[weekdayNames firstObject]];
    
    if ([setting.others16 integerValue] == 1) {
        for (int i = 0; i<weekdayNames.count; i++) {
            CGRect weekdayFrame = CGRectMake(width * i, 0, width, 20);
            
            UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
            weekdayLabel.backgroundColor = [UIColor whiteColor];
            weekdayLabel.textAlignment = NSTextAlignmentCenter;
            weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f];
            weekdayLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:129.0/255.0 blue:148.0/255.0 alpha:1.0];
            weekdayLabel.text = [weekdayNames objectAtIndex:i];
            [self addSubview:weekdayLabel];
        }
    }else{
        
        for (int i = 0; i<muarr.count; i++) {
            CGRect weekdayFrame = CGRectMake(width * i, 0, width, 20);
            
            UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
            weekdayLabel.backgroundColor = [UIColor whiteColor];
            weekdayLabel.textAlignment = NSTextAlignmentCenter;
            weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f];
            weekdayLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:129.0/255.0 blue:148.0/255.0 alpha:1.0];
            weekdayLabel.text = [muarr objectAtIndex:i];
            [self addSubview:weekdayLabel];
        }
    }
}

-(void)setupCollectionView{
    UICollectionViewFlowLayout *flow =[[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView* view = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 318) collectionViewLayout:flow];
    
    view.delegate = self;
    view.dataSource = self;
    
    view.pagingEnabled = YES;
    
    view.showsHorizontalScrollIndicator = NO;
    
    [view registerClass:[XDBillCalCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.6];
    
    NSInteger interger = [[XDCalendarClass shareCalendarClass] getCurrentMonthInterger];
    [view scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:interger] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
    
    [self addSubview:view];
    
    self.collectionView = view;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataArr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XDBillCalCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
//    cell.monthDelegate = self;
    cell.xxdDelegate = self;
    cell.model = _dataArr[indexPath.section];
    cell.selectedDate = _selectedDate;
    cell.dataMuArr = _totalMuArray;

    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    XDCalendarModel* model = _dataArr[index];
    _currentMonthDate = model.calendarMonth;
//    NSLog(@"date -- %@",model.calendarMonth);
    if ([self.xxdDelegate respondsToSelector:@selector(returnCurrentMonth:)]) {
        [self.xxdDelegate returnCurrentMonth:model.calendarMonth];
    }
    
    NSArray* dataArr = model.currentMonthArr;
    if (![dataArr containsObject:_selectedDate]) {
        _selectedDate = model.calendarMonth;
        
        if ([self.xxdDelegate respondsToSelector:@selector(returnSelectedDate:)]) {
            [self.xxdDelegate returnSelectedDate:_selectedDate];
        }
    }
    
    
    [self returnDataWithCurrentMonth:model.calendarMonth];
    
    [self.collectionView reloadData];

}

-(void)returnOtherMonth:(NSDate *)date{
    NSInteger interger = [[XDCalendarClass shareCalendarClass] getSelectedMonthInterger:date];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:interger] atScrollPosition:UICollectionViewScrollPositionNone  animated:YES];
    
    XDCalendarModel* model = _dataArr[interger];
    _currentMonthDate = model.calendarMonth;
    //    NSLog(@"date -- %@",model.calendarMonth);
    if ([self.xxdDelegate respondsToSelector:@selector(returnCurrentMonth:)]) {
        [self.xxdDelegate returnCurrentMonth:model.calendarMonth];
    }
    [self returnDataWithCurrentMonth:date];

    [self.collectionView reloadData];
    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 318);
}


#pragma mark - XDBillCalCollectionDelegate
-(void)returnSelectDate:(NSDate *)date{
    
    if ([self.xxdDelegate respondsToSelector:@selector(returnSelectedDate:)]) {
        [self.xxdDelegate returnSelectedDate:date];
    }
    _selectedDate = date;
}


#pragma mark - other
-(void)refreshUI{
    [self returnDataWithCurrentMonth:_currentMonthDate];
    [self.collectionView reloadData];
}

-(void)returnDataWithCurrentMonth:(NSDate *)date{
    
    
    NSDate* startDate = [self getMonthStartDay:date];
    NSDate* endDate = [self getMonthEndDay:date];
    
    
    NSMutableArray* muArray = [self getBillRuleArray:startDate endDate:endDate];
    
    _totalMuArray = [NSMutableArray array];
    [self useBill1CreateAllBill:muArray totalArray:_totalMuArray startDate:startDate endDate:endDate];
    
    NSMutableArray* muArray2 = [NSMutableArray arrayWithArray:[self getBillItemArray:startDate endDate:endDate]];
    
    [self useBill2CreateAllBill:muArray2 allArray:_totalMuArray];
    
}

-(NSArray*)getBillItemArray:(NSDate *)startDate endDate:(NSDate *)endDate{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:startDate,@"startDate",endDate,@"endDate",nil];
    
    NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"searchBill2byDate" substitutionVariables:sub];
    
    NSError *error = nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
    
    return objects;
    
}

-(void)useBill2CreateAllBill:(NSMutableArray *)tmpBill2Array allArray:(NSMutableArray *)tmpAllArray{
    for (int i=0; i<[tmpBill2Array count]; i++) {
        EP_BillItem *billObject = [tmpBill2Array objectAtIndex:i];
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        
        //如果被删除了，就从all中删除这个数据
        if ([billObject.ep_billisDelete boolValue]){
            for (int j=0; j<[tmpAllArray count]; j++) {
                BillFather   *checkedBill = [tmpAllArray objectAtIndex:j];
                if (checkedBill.bf_billRule == billObject.billItemHasBillRule && [appDelegate.epnc dateCompare:billObject.ep_billItemDueDate withDate:checkedBill.bf_billDueDate]==0) {
                    [tmpAllArray removeObject:checkedBill];
                }
            }
        }
        else{
            for (int j=0; j<[tmpAllArray count]; j++) {
                BillFather *oneBillfather = [tmpAllArray objectAtIndex:j];
                //相等的话说明是同一件事情，此时需要修改
                if (oneBillfather.bf_billRule == billObject.billItemHasBillRule && [appDelegate.epnc dateCompare:oneBillfather.bf_billDueDate withDate:billObject.ep_billItemDueDate]==0)
                {
                    [appDelegate.epdc editBillFather:oneBillfather withBillItem:billObject];
                }
            }
        }
        
    }
    
}

//获取bill1中的数据
-(NSMutableArray*)getBillRuleArray:(NSDate *)startDate endDate:(NSDate *)endDate{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:endDate,@"startDate",nil];
    NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"searchBillRulebyDate" substitutionVariables:sub];
    NSError *error = nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
    
    NSMutableArray *tmpBill1Array = [[NSMutableArray alloc]init];
    for (int i=0; i<[objects count]; i++) {
        EP_BillRule *oneBill = [objects objectAtIndex:i];
        if ([appDelegate.epnc dateCompare:oneBill.ep_billEndDate withDate:startDate]>=0) {
            [tmpBill1Array insertObject:oneBill atIndex:[tmpBill1Array count]];
            //            [_bvc_Bill1Array removeObjectAtIndex:i];
        }
    }
    
    return tmpBill1Array;
}


//通过bill1创建billfather
-(void)useBill1CreateAllBill:(NSMutableArray *)bill1Array totalArray:(NSMutableArray *)totalArray startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    for (int i=0; i<[bill1Array count]; i++) {
        EP_BillRule *oneBill = [bill1Array objectAtIndex:i];
        [self setBillFathferbyBillRule:oneBill totalArray:totalArray  startDate:startDate endDate:endDate];
    }
}

-(void)setBillFathferbyBillRule:(EP_BillRule *)bill totalArray:(NSMutableArray *)totalArray startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    //如果是不循环的，就直接赋值然后返回，因为不循环的bill只会存在与bill1表中
    if([bill.ep_recurringType isEqualToString:@"Never"]){
        
        if (([appDelegate.epnc  dateCompare:bill.ep_billDueDate withDate:startDate]>=0 && [appDelegate.epnc dateCompare:bill.ep_billDueDate withDate:endDate]<=0)) {
            BillFather *billFateher = [[BillFather alloc]init];
            
            [appDelegate.epdc editBillFather:billFateher withBillRule:bill withDate:nil];
            
            [totalArray addObject:billFateher];
            return;
        }
        
    }
    //如果是循环账单
    else{
        NSDate *lastDate = [appDelegate.epnc getCycleStartDateByMinDate:startDate withCycleStartDate:bill.ep_billDueDate withCycleType:bill.ep_recurringType isRule:YES] ;
        
        NSDate *endDateorBillEndDate = [appDelegate.epnc dateCompare:endDate withDate:bill.ep_billEndDate]<0?endDate : bill.ep_billEndDate;
        if ([appDelegate.epnc dateCompare:startDate withDate:endDateorBillEndDate]>0) {
            return;
        }
        else{
            //循环创建账单
            while ([appDelegate.epnc dateCompare:lastDate withDate:endDateorBillEndDate]<=0)
            {
                
                if ([appDelegate.epnc dateCompare:lastDate withDate:startDate]>=0)
                {
                    BillFather *oneBillfather = [[BillFather alloc]init];
                    
                    [appDelegate.epdc editBillFather:oneBillfather withBillRule:bill withDate:lastDate];
                    [totalArray  addObject:oneBillfather];
                }
                
                //获取下一次循环的时间
                lastDate= [appDelegate.epnc getDate:lastDate byCycleType:bill.ep_recurringType];
            }
        }
    }
}

-(NSDate*)getMonthStartDay:(NSDate*)date{
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:unit fromDate:date];
    comps.day = 1;
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
    
}

-(NSDate*)getMonthEndDay:(NSDate*)date{
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:unit fromDate:date];
    comps.month += 1;
    comps.hour = 0;
    comps.minute = 0;
    comps.second = -1;
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
}

@end
