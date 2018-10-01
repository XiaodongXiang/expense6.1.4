//
//  XDPiePageView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/23.
//

#import "XDPiePageView.h"
#import "XDPieChartBigView.h"
#import "XDPieCategoryTableViewCell.h"
#import "XDPieChartModel.h"
@interface XDPiePageView()<UITableViewDelegate,UITableViewDataSource>
{
    double _allAmount;
}
@property(nonatomic, strong)XDPieChartBigView * pieChartBigView;
@property(nonatomic, strong)UITableView * tableView;

@end

@implementation XDPiePageView



-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = [dataArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO]]];
    
    self.pieChartBigView.dataArray = dataArray;
    self.pieChartBigView.hidden = NO;

    _allAmount = 0;
    for (int i = 0; i < _dataArray.count; i++) {
        XDPieChartModel* model = _dataArray[i];
        _allAmount += model.amount;
    }
    if (_allAmount == 0) {
        self.pieChartBigView.hidden = YES;
        UIImageView* imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty state7"]];
        imageview.contentMode = UIViewContentModeCenter;
        imageview.backgroundColor = [UIColor whiteColor];
        imageview.frame = CGRectMake(0, 0, self.width, self.height);
        imageview.centerY = self.height/2;
        imageview.centerX = self.width/2;
        [self addSubview:imageview];
            
        }else{

            for (UIView* view in self.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [view removeFromSuperview];
                }
            }
    }
    
    [self.tableView reloadData];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (IS_IPHONE_5) {
            self.pieChartBigView = [[XDPieChartBigView alloc]initWithFrame:CGRectMake(0, -195, 180, 180)];
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pieChartBigView.frame)+10, self.width, self.height) style:UITableViewStylePlain];
            self.tableView.contentInset = UIEdgeInsetsMake(210, 0, 0, 0);

        }else{
            self.pieChartBigView = [[XDPieChartBigView alloc]initWithFrame:CGRectMake(0, -235, 220, 220)];
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
            self.tableView.contentInset = UIEdgeInsetsMake(250, 0, 0, 0);

        }
        self.pieChartBigView.centerX = self.width/2;
        self.pieChartBigView.userInteractionEnabled = NO;
//        [self addSubview:self.pieChartBigView];
        
        [self.tableView addSubview:self.pieChartBigView];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        self.tableView.separatorColor = RGBColor(226 , 226 , 226);

        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero]; 
    }
    return self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"pieCell";
    XDPieCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDPieCategoryTableViewCell" owner:self options:nil]lastObject];
    }
    cell.amount = _allAmount;
    cell.model = _dataArray[indexPath.row];
    if (indexPath.row == 0) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        view.backgroundColor = RGBColor(226, 226, 226);
        [cell.contentView addSubview:view];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count == 1) {
        XDPieChartModel* model = _dataArray.firstObject;
        if (model.category == nil) {
            return 0;
        }
    }
    return _dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(returnSelectedPieModel:)]) {
        [self.delegate returnSelectedPieModel:_dataArray[indexPath.row]];
    }
}


@end
