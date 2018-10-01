//
//  CategorySelectCell.h
//  PokcetExpense
//
//  Created by ZQ on 12/6/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AccountSelectCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineX;

@end
