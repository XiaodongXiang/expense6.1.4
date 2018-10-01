//
//  PaymentViewController.h
//  Expense 5
//
//  Created by BHI_James on 5/14/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BillFather.h"

@class BillEditViewController;
@interface PaymentViewController : UIViewController <UIPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
	UITableView				*mytableView;
 	NSMutableArray			*paymentList;
	NSDateFormatter			*outputFormatter;
	BillFather              *billFather;
	
    UIImageView             *categoryimage;
    UILabel                 *nameLabel;
    UILabel                 *headLabel;
    UILabel					*dueLabel;
    UILabel					*paidLabel;
    UILabel					*leftLabel;
    UIButton                *addPaymentBtn;
	BOOL                    needReflshData;
    
    UILabel                 *dueLabelText;
    UILabel                 *totalLabelText;
    UILabel                 *paidLabelText;
    UIView                  *padiContainView;
    UILabel                 *paid2LabelText;
    
    BillEditViewController  *billEditViewController;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;

@property (nonatomic, strong) IBOutlet UITableView			*mytableView;
@property (nonatomic, strong) NSDateFormatter		*outputFormatter;
@property (nonatomic, strong) NSMutableArray		*paymentList;
@property (nonatomic, strong) BillFather			*billFather;

@property(nonatomic,strong)IBOutlet UIImageView     *billDetailBg;

@property (nonatomic, strong) IBOutlet UIImageView             *categoryimage;
@property (nonatomic, strong) IBOutlet UILabel                 *nameLabel;
@property (nonatomic, strong) UILabel               *headLabel;
@property (nonatomic, strong) IBOutlet UILabel      *dueLabel;
@property (nonatomic, strong) IBOutlet UILabel      *paidLabel;
@property (nonatomic, strong) IBOutlet UILabel      *leftLabel;
@property(nonatomic,strong)IBOutlet UIButton        *addPaymentBtn;

@property (nonatomic, strong) IBOutlet UILabel                 *dueLabelText;
@property (nonatomic, strong) IBOutlet UILabel                 *totalLabelText;
@property (nonatomic, strong) IBOutlet UILabel                 *paidLabelText;
@property (nonatomic, strong) IBOutlet UIView                  *padiContainView;
@property (nonatomic, strong) IBOutlet UILabel                 *paid2LabelText;

@property(nonatomic,strong)BillEditViewController   *billEditViewController;
@property (nonatomic, assign) BOOL                   needReflshData;

-(void)refleshUI;

@end
