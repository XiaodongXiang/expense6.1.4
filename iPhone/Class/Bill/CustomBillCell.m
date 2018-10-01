//
//  CustomBillCell.m
//  PocketExpense
//
//  Created by 刘晨 on 16/3/2.
//
//

#import "CustomBillCell.h"
#import "AppDelegate_iPhone.h"

@implementation CustomBillCell

-(void)setDate:(NSDate *)date{
    _date = date;
   
    _leftLabel.text = [self leftDateString:date];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        float cellWidth;
        if (ISPAD)
        {
            cellWidth=378;
        }
        else
        {
            cellWidth=SCREEN_WIDTH;
        }
        
        _categoryIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        _categoryIconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_categoryIconImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 15,cellWidth - 200, 20)];
        [_nameLabel setFont:[UIFont fontWithName:FontSFUITextRegular size:16.0]];
        [_nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.f]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_nameLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 40.0, 164.0, 15)];
        [_dateLabel setFont:[UIFont fontWithName:FontSFUITextRegular size:14]];
        [_dateLabel setTextColor:RGBColor(200, 200, 200)];
        [_dateLabel setTextAlignment:NSTextAlignmentLeft];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_dateLabel];
        
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 15, cellWidth-230, 20)];
        _amountLabel.font=[UIFont fontWithName:FontSFUITextMedium size:16];
        [_amountLabel setTextColor:[UIColor colorWithRed:85.0/255 green:85.0/255 blue:85.0/255 alpha:1.f]];
        [_amountLabel setTextAlignment:NSTextAlignmentRight];
        [_amountLabel setBackgroundColor:[UIColor clearColor]];
        _amountLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_amountLabel];
        
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 40, cellWidth-230, 15)];
        _leftLabel.font=[UIFont fontWithName:FontSFUITextRegular size:14];
        [_leftLabel setTextColor:RGBColor(200, 200, 200)];
        [_leftLabel setTextAlignment:NSTextAlignmentRight];
        [_leftLabel setBackgroundColor:[UIColor clearColor]];
        _leftLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_leftLabel];
        
        //memo
        if(IS_IPHONE_5){
            _memoImage = [[UIImageView alloc] initWithFrame:CGRectMake(160,42, 13, 11)];
        }else{
            _memoImage = [[UIImageView alloc] initWithFrame:CGRectMake(180,42, 13, 11)];
        }
        _memoImage.image = [UIImage imageNamed:@"icon_memo.png"];
        _memoImage.hidden = YES;
        [self.contentView addSubview:_memoImage];
        
        _payIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(cellWidth-23, 35.0, 8, 8)];
        _payIconImage.contentMode = UIViewContentModeScaleAspectFit;
        _payIconImage.hidden = YES;
        [self.contentView addSubview:_payIconImage];
        
//        float lineWidth;
//        if (ISPAD)
//        {
//            lineWidth=378-53-15;
//        }
//        else
//        {
//            lineWidth=SCREEN_WIDTH-53;
//        }
//        _line2 = [[UIView alloc]initWithFrame:CGRectMake(53, 53-EXPENSE_SCALE, lineWidth, EXPENSE_SCALE)];
//        _line2.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
//        [self.contentView addSubview:_line2];
    }
    return self;
}

-(BOOL)compareDate:(NSDate*)date{
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay;
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:unit fromDate:[NSDate date]];
    NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
    
    if ([date compare:newDate] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

-(NSString*)leftDateString:(NSDate*)date{
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay;
    
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:unit fromDate:date];
    NSDateComponents* comp1 = [[NSCalendar currentCalendar] components:unit fromDate:[NSDate date]];
    
    NSDate* fDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
    NSDate* sDate = [[NSCalendar currentCalendar] dateFromComponents:comp1];
    
    NSTimeInterval time = [fDate timeIntervalSinceDate:sDate];
    
    NSInteger index = time / 3600 / 24;
    //    NSDateComponents *dateCom = [[NSCalendar currentCalendar] components:unit fromDate:[NSDate date] toDate:date options:0];
    
    
    if (![self compareDate:date]) {
        return  @"Overdue";
    }
    
    
    if (index > 1) {
        return [NSString stringWithFormat:@"%ld Days Left",index];
    }else if (index == 0){
        return @"Today";
    }else if (index == 1){
        return [NSString stringWithFormat:@"%ld Day Left",index];
    }
    
    return nil;
}



@end
