//
//  ipad_AccountCell.h
//  PocketExpense
//
//  Created by Tommy on 11-4-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>

@class ipad_AccountViewController;
@interface ipad_AccountCell : UITableViewCell 

@property (nonatomic, strong) UILabel		*nameLabel;
//account
@property (nonatomic, strong) UILabel		*titleLabel;
@property (nonatomic, strong) UILabel		*blanceLabel;
@property (nonatomic,strong) UIImageView    *typeImageView;
@property (nonatomic,strong) UIButton       *deleteBtn;
@property (nonatomic,strong) UIButton       *detailBtn;

@property (nonatomic,strong)ipad_AccountViewController              *iAccountViewController;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  isVModule:(BOOL)isV;

@end
