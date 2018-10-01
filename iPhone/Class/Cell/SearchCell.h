//
//  SearchCell.h
//  Expense 5
//
//  Created by BHI_James on 4/26/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchCell : UITableViewCell 
{
	UILabel										*categoryLabel;
	UILabel										*accountLabel;
	UILabel										*amountLabel;
	UILabel										*dateLable;
	UILabel										*noteLabel;
	UIImageView									*cycleImageView;

	UIImageView									*bgImageView;
}

@property (nonatomic, strong) IBOutlet UILabel			*categoryLabel;
@property (nonatomic, strong) IBOutlet UILabel			*accountLabel;
@property (nonatomic, strong) IBOutlet UILabel			*amountLabel;
@property (nonatomic, strong) IBOutlet UILabel			*dateLabel;
@property (nonatomic, strong) IBOutlet UILabel			*noteLabel;
@property (nonatomic, strong) IBOutlet UIImageView		*bgImageView;
@property (nonatomic, strong) IBOutlet UIImageView		*cycleImageView;

@end
