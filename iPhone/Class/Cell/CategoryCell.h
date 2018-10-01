//
//  CategoryCell.h
//  Expense 5
//
//  Created by BHI_James on 4/19/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineX;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameX;

@property(nonatomic,assign)BOOL    thisCellisEdit;
@end
