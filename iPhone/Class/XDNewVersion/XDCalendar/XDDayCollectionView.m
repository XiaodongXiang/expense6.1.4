//
//  XDDayCollectionView.m
//  calendar
//
//  Created by 晓东 on 2018/1/3.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import "XDDayCollectionView.h"
#import "XDCalendarClass.h"
#import "XDDaysCollectionViewCell.h"

static NSString* const cellID = @"dayCell";

@interface XDDayCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,XDDaysCollectionViewCellDelegate>
{
    XDDaysCollectionViewCell* _currentDaysCell;
    NSArray* _dataArr;
    
    NSArray* _currentArr;
}
@end
@implementation XDDayCollectionView

-(void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    
    NSInteger integer = [[XDCalendarClass shareCalendarClass] getDayViewCurrentMonthWithSelectedDate:selectedDate];
//    if ([NSCalendar currentCalendar].calendarIdentifier == NSCalendarIdentifierBuddhist) {
//        integer = [[XDCalendarClass shareCalendarClass] getDayViewCurrentMonthWithSelectedDate:selectedDate];
//    }
//    if (integer < 6770) {
        [self layoutIfNeeded];

        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:integer] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
//    }else{
//        integer = [[XDCalendarClass shareCalendarClass] getDayViewCurrentMonthWithSelectedDate:[NSDate internetDate]];
//        [self layoutIfNeeded];
//
//        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:integer] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
//    }
    [self reloadData];
}


+(instancetype)dayView{
    return [[self alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 53)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    _dataArr = [[XDCalendarClass shareCalendarClass]getDaysDataWithCurrentDateTo1970Years];
    UICollectionViewFlowLayout *flow =[[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self = [super initWithFrame:frame collectionViewLayout:flow];
    
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        
        [self registerClass:[XDDaysCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        
        self.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.6];
        
//        NSInteger integer = [[XDCalendarClass shareCalendarClass] sevenCountWithCurrentDate];
        
//        if (integer < 6770) {
//
//            [self layoutIfNeeded];
//            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:integer] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
//        }else{
//            integer = [[XDCalendarClass shareCalendarClass] getDayViewCurrentMonthWithSelectedDate:[NSDate internetDate]];
//            [self layoutIfNeeded];
//
//            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:integer] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
//        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarFirstDayChange) name:@"calendarFirstDayChange" object:nil];

    }
    return self;
}

-(void)calendarFirstDayChange{
    _dataArr = [[XDCalendarClass shareCalendarClass]getDaysDataWithCurrentDateTo1970Years];
    NSInteger integer = [[XDCalendarClass shareCalendarClass] getDayViewCurrentMonthWithSelectedDate:_selectedDate];
    
//    if (integer < 6770) {
        [self layoutIfNeeded];

        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:integer] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
//    }else{
//        integer = [[XDCalendarClass shareCalendarClass] getDayViewCurrentMonthWithSelectedDate:[NSDate internetDate]];
//        [self layoutIfNeeded];
//        
//        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:integer] atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
//    }
    
    [self reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataArr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XDDaysCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSArray* sevenArr = _dataArr[indexPath.section];
    cell.dayDataArr = sevenArr;
    cell.delegate = self;
    cell.selectedDate = _selectedDate;

    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 53);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger count = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    NSArray* dataArr = _dataArr[count];
    
    if (![dataArr containsObject:_selectedDate]) {
        _selectedDate = dataArr.firstObject;
        
        [self returnDaysSelectedBtn:_selectedDate];
    }
    
    [self reloadData];
}
#pragma mark - XDDaysCollectionViewCellDelegate
-(void)returnDaysSelectedBtn:(NSDate *)date{
    
    _selectedDate = date;
    
    if ([self.dayDelegate respondsToSelector:@selector(returnDayCollectionViewSelected:)]) {
        [self.dayDelegate returnDayCollectionViewSelected:date];
    }
}



@end
