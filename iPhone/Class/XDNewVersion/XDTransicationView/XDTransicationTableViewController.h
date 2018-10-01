//
//  XDTransicationTableViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/1/10.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@protocol XDTransicationTableViewDelegate  <NSObject>
-(void)returnDragContentOffset:(CGFloat)offsetY;
-(void)returnCellSelectedBtn:(Transaction *)transcation index:(NSInteger)index;
-(void)returnSelectedCellTranscation:(Transaction*)transcation;
@end

@interface XDTransicationTableViewController : UITableViewController

@property(nonatomic, strong)NSDate * selectedDate;
@property(nonatomic, weak)id<XDTransicationTableViewDelegate> transcationDelegate;

@end
