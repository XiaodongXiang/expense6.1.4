//
//  XDTimeSelectView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/27.
//

#import "XDTimeSelectView.h"
#import "XDDateSelectedModel.h"
#import "Transaction.h"
@interface XDTimeSelectView()<UITableViewDelegate,UITableViewDataSource>
{
    UIView* _btnBackView;
    UIButton* _currentFourBtn;
    UIColor* _selectedColor;
    
    UIScrollView* _scrollView;
    UITableView* _tableView;
    
    UIButton* _selectedBtn;
    
    NSArray* _dataArr;
    

    BOOL _startDateShow;
    BOOL _endDateShow;
    
    UIDatePicker* _startDatePicker;
    UIDatePicker* _endDatePicker;
    
    UIButton* _saveBtn;
    
    NSDate* _tranStartDate;
    NSDate* _tranEndDate;
}

@end
@implementation XDTimeSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedColor = RGBColor(113, 163, 245);
        self.backgroundColor = [UIColor whiteColor];
        self.height = 178;
        
        [self setupFourBtn];
        [self setupScrollView];
        [self setupTableView];
        [self setDataArr];
        [self setupDatePicker];
        
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        view.backgroundColor = RGBColor(226, 226, 226);
        [self addSubview:view];
        
    
    }
    return self;
}

-(void)setupDatePicker{
    _startDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 224)];
    _endDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 224)];
    _startDatePicker.date = _endDatePicker.date  = [NSDate date];
    _startDatePicker.datePickerMode = _endDatePicker.datePickerMode = UIDatePickerModeDate;
    
    [_startDatePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [_endDatePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];

    NSArray* tranArr = [[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@ and parTransaction = null",@"1"] sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateTime" ascending:YES]]];
    
    Transaction* startTransaction = [tranArr firstObject];
    Transaction* endTransaction = [tranArr lastObject];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar* calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate* tranStartDay = [calendar dateFromComponents:[calendar components:unit fromDate:startTransaction.dateTime]];
    NSDate* tranEndDay = [calendar dateFromComponents:[calendar components:unit fromDate:endTransaction.dateTime]];
    
    _startDatePicker.minimumDate = _endDatePicker.minimumDate = tranStartDay;
    _startDatePicker.maximumDate = _endDatePicker.maximumDate = tranEndDay;
//    _startDatePicker.timeZone = _endDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
}

-(void)valueChange:(UIDatePicker*)datePicker{
    if (datePicker == _startDatePicker) {
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)refreshUI{
    [self setDataArr];
    
    NSArray* tranArr = [[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@ and parTransaction = null",@"1"] sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateTime" ascending:YES]]];
    
    Transaction* startTransaction = [tranArr firstObject];
    Transaction* endTransaction = [tranArr lastObject];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate* tranStartDay = [calendar dateFromComponents:[calendar components:unit fromDate:startTransaction.dateTime]];
    NSDate* tranEndDay = [calendar dateFromComponents:[calendar components:unit fromDate:endTransaction.dateTime]];
    
    _startDatePicker.minimumDate = _endDatePicker.minimumDate = tranStartDay;
    _startDatePicker.maximumDate = _endDatePicker.maximumDate = tranEndDay;
    _startDatePicker.timeZone = _endDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];

    
}

-(void)setDataArr{
    
    _dataArr = [XDDateSelectedModel returnDateSelectedWithType:_currentFourBtn.tag completion:nil];
    
    for (UIView* view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _dataArr.count / 12, 0);
    
    CGFloat width = SCREEN_WIDTH / 6;
    CGFloat height = 30;
    _tableView.hidden = YES;
    _scrollView.hidden = YES;
    
    if (_currentFourBtn.tag == 1) {
        _scrollView.hidden = NO;
        for (int i = 0; i < _dataArr.count / 12; i++) {
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH+20, -10, SCREEN_WIDTH, 20)];
            label.textColor = RGBColor(200, 200, 200);
            label.font = [UIFont fontWithName:FontSFUITextRegular size:12];
            label.text = [self yearDateformatter:_dataArr[i*12]];
            [_scrollView addSubview:label];
            
            for (int j = i * 12; j < (i+1)*12; j++) {
                int wIndex = j % 6;
                int hIndex = (j%12) / 6;
                CGFloat x = i * SCREEN_WIDTH + wIndex * width;
                CGFloat y = hIndex * 56;
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.layer.cornerRadius = height/2;
                btn.tag = 1000 + j;
                btn.titleLabel.font=[UIFont fontWithName:FontSFUITextRegular size:14];
                btn.layer.masksToBounds = YES;
                [btn setTitle:[self dateformatter:_dataArr[j]] forState:UIControlStateNormal];
                [btn setTitleColor:RGBColor(85, 85, 85) forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:[UIImage createImageWithColor:_selectedColor] forState:UIControlStateSelected];
                btn.frame = CGRectMake(x, y+12, width, height);
                if ([_dataArr[j] compare:[self currentMonthDate]] == NSOrderedSame) {
//                    btn.selected = YES;
                    [btn setTitleColor:RGBColor(113, 163, 245) forState:UIControlStateNormal];
//                    _selectedBtn = btn;
                    _scrollView.contentOffset = CGPointMake(i*SCREEN_WIDTH, 0);
                   
                }
                [_scrollView addSubview:btn];
            }
        }
    }else if (_currentFourBtn.tag == 2){
        _scrollView.hidden = NO;

        for (int i = 0; i <= _dataArr.count / 12; i++) {
            for (int j = i * 12; j < ((i+1)*12 < _dataArr.count?(i+1)*12:_dataArr.count); j++) {
                int wIndex = j % 6;
                int hIndex = (j%12) / 6;
                CGFloat x = i * SCREEN_WIDTH + wIndex * width;
                CGFloat y = hIndex * 56;
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.layer.cornerRadius = height/2;
                btn.tag = 1000 + j;
                btn.titleLabel.font=[UIFont fontWithName:FontSFUITextRegular size:14];
                btn.layer.masksToBounds = YES;
                [btn setTitle:[self yearDateformatter:_dataArr[j]] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:[UIImage createImageWithColor:_selectedColor] forState:UIControlStateSelected];
                btn.frame = CGRectMake(x, y+12, width, height);
                NSDate* date = _dataArr[j];
                if ([date compare:[self currentYearDate]] == NSOrderedSame) {
                    [btn setTitleColor:RGBColor(113, 163, 245) forState:UIControlStateNormal];

//                    btn.selected = YES;
//                    _selectedBtn = btn;
                    _scrollView.contentOffset = CGPointMake(i*SCREEN_WIDTH, 0);
                  
                }
                [_scrollView addSubview:btn];
            }
        }
    }else if (_currentFourBtn.tag == 3){
        _tableView.hidden = NO;
        
    }
}

-(void)timeBtnClick:(UIButton*)btn{
  
    btn.selected = !btn.selected;
    _selectedBtn.selected = NO;
    _selectedBtn = btn;
    
    if([self.delegate respondsToSelector:@selector(returnSubTime:index:)]){
        [self.delegate returnSubTime:_dataArr[btn.tag - 1000] index:btn.tag - 1000];
    }
    
}

-(NSString*)dateformatter:(NSDate*)date{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"LLL"];
    return [format stringFromDate:date];
}

-(NSString*)yearDateformatter:(NSDate*)date{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy"];
    return [format stringFromDate:date];
}

-(NSString*)cellDateFormatter:(NSDate*)date{
    
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"LLL dd, yyyy"];
    return [format stringFromDate:date];
}

-(void)setupFourBtn{
    
    CGFloat width;
    if (IS_IPHONE_5 || IS_IPHONE_6) {
        _btnBackView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 30)];
        width = (SCREEN_WIDTH - 30)/4;

    }else{
        _btnBackView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, 30)];
        width = (SCREEN_WIDTH - 40)/4;


    }
    _btnBackView.layer.cornerRadius = 15;
    _btnBackView.layer.masksToBounds = YES;
    _btnBackView.backgroundColor = RGBColor(230, 230, 230);
    
    [self addSubview:_btnBackView];
    
    
    for (int i = 0; i < 4; i++) {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(width*i, 0, width, 30)];
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont fontWithName:FontSFUITextRegular size:14];
        btn.tag = i;
        [btn setAdjustsImageWhenHighlighted:NO];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBackView addSubview:btn];
        
        if (btn.tag == 0) {
            [btn setTitle:@"Week" forState:UIControlStateNormal];
        }else if (btn.tag == 1){
            [btn setTitle:@"Month" forState:UIControlStateNormal];
            [btn setBackgroundColor:_selectedColor];
            _currentFourBtn = btn;
            
        }else if(btn.tag == 2){
            [btn setTitle:@"Year" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"Custom" forState:UIControlStateNormal];
        }
    }
}

-(void)setupScrollView{
    
    _scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 112)];
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    _scrollView.clipsToBounds = NO;
    _startDateShow = _endDateShow = NO;

}

-(void)setupTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 56, SCREEN_WIDTH, 112) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveBtn setBackgroundImage:[UIImage createImageWithColor:RGBColor(64, 216, 142)] forState:UIControlStateNormal];
    [_saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.frame = CGRectMake(0, self.height-49, SCREEN_WIDTH, 49);
    [_saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    _saveBtn.titleLabel.font = [UIFont fontWithName:FontHelveticaNeueMedium size:18];
    _saveBtn.hidden = YES;
    [self addSubview:_saveBtn];
}

-(void)saveClick{
    if ([self.delegate respondsToSelector:@selector(returnCustomStartDate:endDate:)]) {
        [self.delegate returnSaveBtnClick];
        [self.delegate returnCustomStartDate:_startDatePicker.date endDate:_endDatePicker.date];
    }    
}

-(NSDate*)currentMonthDate{
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar* calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDateComponents* comp = [calendar components:unit fromDate:[NSDate date]];
    comp.day = 1;
    
    NSDate* date = [calendar dateFromComponents:comp];
    
    return date;
}

-(NSDate*)currentYearDate{
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar* calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDateComponents* comp = [calendar components:unit fromDate:[NSDate date]];
    comp.day = 1;
    comp.month = 1;
    NSDate* date = [calendar dateFromComponents:comp];
    
    return date;
}
#pragma mark -  uitableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 2) {
        return 56;
    }else if(indexPath.row == 1){
        return _startDateShow?224:0.001;
    }else if(indexPath.row == 3){
        return _endDateShow?224:0.001;
    }
    return 56;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    cell.textLabel.font = [UIFont fontWithName:FontSFUITextRegular size:16];
    cell.textLabel.textColor = RGBColor(135, 135, 135);
    cell.detailTextLabel.textColor = RGBColor(85, 85, 85);
    cell.detailTextLabel.font = [UIFont fontWithName:FontSFUITextRegular size:16];
    cell.clipsToBounds = YES;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Start Date";
        cell.detailTextLabel.text = [self cellDateFormatter:_startDatePicker.date];
    }else if(indexPath.row == 2){
        cell.textLabel.text = @"End Date";
        cell.detailTextLabel.text = [self cellDateFormatter:_endDatePicker.date];
    }else if (indexPath.row == 1){
        [cell.contentView addSubview:_startDatePicker];
    }else if(indexPath.row == 3){
        [cell.contentView addSubview:_endDatePicker];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        _startDateShow = !_startDateShow;
        _endDateShow = NO;
    }else if(indexPath.row == 2){
        _endDateShow  = !_endDateShow;
        _startDateShow = NO;
    }
    
    [_tableView beginUpdates];
    [_tableView endUpdates];
    
    [UIView animateWithDuration:0.2 animations:^{
        if (_startDateShow || _endDateShow) {
            self.height = 441;
            _tableView.height = 325;
        }else{
            self.height = 217;
            _tableView.height = 112;
        }
        _saveBtn.y = self.height - 49;

    }];
}

-(void)btnClick:(UIButton*)btn{
    if (btn == _currentFourBtn) {
        return;
    }
    for (UIButton* button  in _btnBackView.subviews) {
        [button setBackgroundColor: RGBColor(230, 230, 230)];
    }
    [btn setBackgroundColor:_selectedColor];
    _currentFourBtn = btn;
    [self setDataArr];

    _saveBtn.hidden = YES;
    [UIView animateWithDuration:0.1 animations:^{
        if (_currentFourBtn.tag == 0) {
            self.height = 70;
        }else if (_currentFourBtn.tag == 3){
            _saveBtn.hidden = NO;
            if (_startDateShow || _endDateShow) {
                self.height = 441;
                _tableView.height = 325;
            }else{
                self.height = 217;
                _tableView.height = 112;
            }
            _saveBtn.y = self.height - 49;

        }else if (_currentFourBtn.tag == 1){
            self.height = 178;
        }else{
            if (_dataArr.count>6) {
                self.height = 178;
            }else{
                self.height = 122;
            }
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(returnFourBtnSelected:)]) {
        if (btn.tag == 0) {
            [self.delegate returnFourBtnSelected:DateSelectedWeek];
        }else if (btn.tag == 1){
            [self.delegate returnFourBtnSelected:DateSelectedMonth];
        }else if(btn.tag == 2){
            [self.delegate returnFourBtnSelected:DateSelectedYear];
        }
    }

}



@end
