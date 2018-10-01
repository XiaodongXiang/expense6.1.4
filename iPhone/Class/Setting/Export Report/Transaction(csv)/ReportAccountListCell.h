//
//  ReportAccountListCell.h
//  PocketExpense
//
//  Created by humingjing on 14-4-22.
//
//

#import <UIKit/UIKit.h>

@interface ReportAccountListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineX;


@end
