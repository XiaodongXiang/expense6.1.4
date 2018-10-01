//
//  TrackerCell.h
//  Expense 5
//
//  Created by BHI_James on 4/24/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "piView.h"

@interface TrackerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *colorLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *categoryToLeft;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *percentToRight;

@end
