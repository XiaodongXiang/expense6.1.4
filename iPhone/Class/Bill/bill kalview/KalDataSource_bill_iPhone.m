/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalDataSource_bill_iPhone.h"
#import "KalPrivate_bill_iPhone.h"

@implementation SimpleKalDataSource_bill_iPhone

+ (SimpleKalDataSource_bill_iPhone*)dataSource
{
  return [[[self class] alloc] init] ;
}
 
 

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"MyCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) 
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  cell.textLabel.text = @"Filler text";
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
}

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks_bill_iPhone>)delegate
{
  [delegate loadedDataSource:self];
}

//- (NSArray *)markedAllDatesRecord
//{
//	return [NSArray array];
//}

//- (NSArray *)markedPaidDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
//{
//  return [NSArray array];
//}

//- (NSArray *)markedUnPaidDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
//{
//	return [NSArray array];
//}

//- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
//{
//  // do nothing
//}
//- (NSArray *)paidandunpaidFrom:(NSDate *)fromDate to:(NSDate *)toDate;
//{
//
//}

-(void)loadItemsforselectedDay{
    
}

- (void)removeAllItems
{
  // do nothing
}
@end
