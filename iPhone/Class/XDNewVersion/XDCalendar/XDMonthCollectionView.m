//
//  XDMonthCollectionView.m
//  calendar
//
//  Created by 晓东 on 2018/1/2.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import "XDMonthCollectionView.h"
#import "XDMonthCollectionViewCell.h"
#import "XDCalendarClass.h"
@interface XDMonthCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,XDMonthCollectionViewCellDelegate>
{
    XDMonthCollectionViewCell* _currentMonthCell;
    NSArray* _dataArr;
    NSDate* _selectedDate ;
    XDCalendarModel* _currentModel;

}
@end

@implementation XDMonthCollectionView

static NSString* const cellID = @"monthCell";


+(instancetype)monthView{
    return [[self alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 318)];
}

-(void)setDayViewSelectedDate:(NSDate *)dayViewSelectedDate{
    _dayViewSelectedDate = dayViewSelectedDate;
  
    _selectedDate = _dayViewSelectedDate;

    NSInteger interger = [[XDCalendarClass shareCalendarClass] getSelectedMonthInterger:_dayViewSelectedDate];
    //    if ([NSCalendar currentCalendar].calendarIdentifier == NSCalendarIdentifierBuddhist) {

//    if (interger < 1560) {
        [self layoutIfNeeded];

        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:interger] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
//    }else{
//        interger = interger - 6516;
//
//        [self layoutIfNeeded];
//
//        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:interger] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
//    }

    [self reloadData];
}

-(NSInteger)returnMonthIntegerWithInternetDate:(NSDate*)date{
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    NSInteger integer = interval/365/24/3600;
    NSCalendar *calendar = GMTCalendar();
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    
    NSInteger monthpage = integer * 12 + dateComponent.month - 1;
    
    return monthpage;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    _dataArr = [NSArray arrayWithArray:[[XDCalendarClass shareCalendarClass] dateArray]];
    
    UICollectionViewFlowLayout *flow =[[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self = [super initWithFrame:frame collectionViewLayout:flow];
    
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        self.pagingEnabled = YES;
        
        self.showsHorizontalScrollIndicator = NO;
        
        [self registerClass:[XDMonthCollectionViewCell class] forCellWithReuseIdentifier:cellID];
                
        self.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.6];
        
//        NSInteger interger = [[XDCalendarClass shareCalendarClass] getCurrentMonthInterger];
//        if (interger < 1560) {
//
//            [self layoutIfNeeded];
//
//            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:interger] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
//        }else{
//            interger = [[XDCalendarClass shareCalendarClass] getSelectedMonthInterger:[NSDate internetDate]];
//            [self layoutIfNeeded];
//            
//            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:interger] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
//        }
//        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarFirstDayChange) name:@"calendarFirstDayChange" object:nil];
    }
    return self;
}

-(void)calendarFirstDayChange{
    _dataArr = [NSArray arrayWithArray:[[XDCalendarClass shareCalendarClass] getMonthDataWithCurrentDateTo1970Years]];
    NSInteger interger = [[XDCalendarClass shareCalendarClass] getSelectedMonthInterger:_dayViewSelectedDate];
//    if (interger < 1560) {
    [self layoutIfNeeded];

    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:interger] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
//    }else{
//        interger = interger - 6516;
//        [self layoutIfNeeded];
//        
//        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:interger] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
//    }
    
    [self reloadData];
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
    
    XDMonthCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.monthDelegate = self;
    cell.calendarModel = _dataArr[indexPath.section];
    cell.selectedDate = _selectedDate;

    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 318);
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger count = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    XDCalendarModel* model = _dataArr[count];
        
    if ([self.monthViewDelegate respondsToSelector:@selector(returnCurrentMonth:)]) {
        [self.monthViewDelegate returnCurrentMonth:model.calendarMonth];
    }
    if (_currentModel != model) {
        _currentModel = model;
        
        NSArray* dataArr = _currentModel.currentMonthArr;
        if (![dataArr containsObject:_selectedDate]) {
            _selectedDate = _currentModel.calendarMonth;
            if ([self.monthViewDelegate respondsToSelector:@selector(returnSelectedDate:)]) {
                [self.monthViewDelegate returnSelectedDate:_selectedDate];
            }
        }
    }
   
    [self reloadData];

    
}


#pragma mark - XDMonthCollectionViewCellDelegate

-(void)returnCurrentCellWithSelectedBtn:(XDMonthCollectionViewCell *)cell{
    if (_currentMonthCell != cell) {
        [_currentMonthCell cancelAllBtnSelected];
        _currentMonthCell = cell;
    }
}

-(void)returnselectedDayWithDate:(NSDate *)date{
    _selectedDate = date;
    if ([self.monthViewDelegate respondsToSelector:@selector(returnSelectedDate:)]) {
        [self.monthViewDelegate returnSelectedDate:date];
    }
    if ([self.monthViewDelegate respondsToSelector:@selector(returnCurrentMonth:)]) {
        [self.monthViewDelegate returnCurrentMonth:date];
    }
}
-(void)returnLastOrNextMonthDate:(NSDate *)date{
    
   
    NSInteger interger = [[XDCalendarClass shareCalendarClass] getSelectedMonthInterger:date];
    if (interger > 1560) {
        return;
    }
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:interger] atScrollPosition:UICollectionViewScrollPositionNone  animated:YES];
    [self reloadData];
}

#pragma mark - other




@end
