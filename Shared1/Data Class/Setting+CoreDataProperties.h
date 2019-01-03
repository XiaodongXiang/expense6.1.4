//
//  Setting+CoreDataProperties.h
//  PocketExpense
//
//  Created by 晓东项 on 2018/9/25.
//
//

#import "Setting+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Setting (CoreDataProperties)

+ (NSFetchRequest<Setting *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *otherBool18;// alreadyInvited  1.已经邀请过成功
@property (nullable, nonatomic, copy) NSString *others11;
@property (nullable, nonatomic, copy) NSString *others12;
@property (nullable, nonatomic, copy) NSString *others20;
@property (nullable, nonatomic, copy) NSString *others13;
@property (nullable, nonatomic, copy) NSNumber *otherBool11;
@property (nullable, nonatomic, copy) NSString *others14;
@property (nullable, nonatomic, copy) NSDate *accDRendDate;
@property (nullable, nonatomic, copy) NSNumber *otherBool1;
@property (nullable, nonatomic, copy) NSString *others15;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *others16;
@property (nullable, nonatomic, copy) NSNumber *otherBool19; // haveOneMonthTrial 1.有一个月试用
@property (nullable, nonatomic, copy) NSNumber *otherBool2;
@property (nullable, nonatomic, copy) NSString *others17;
@property (nullable, nonatomic, copy) NSNumber *payeeMemo;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *others18;
@property (nullable, nonatomic, copy) NSString *others19;
@property (nullable, nonatomic, copy) NSNumber *otherBool12;
@property (nullable, nonatomic, copy) NSNumber *payeeCategory;
@property (nullable, nonatomic, copy) NSNumber *otherBool3;
@property (nullable, nonatomic, copy) NSString *expenseLastView;
@property (nullable, nonatomic, copy) NSString *currency;
@property (nullable, nonatomic, copy) NSNumber *otherBool4;//打开widget
@property (nullable, nonatomic, copy) NSNumber *otherBool20; // invitedSuccessNotif 1.需要提醒
@property (nullable, nonatomic, copy) NSNumber *otherBool13;
@property (nullable, nonatomic, copy) NSNumber *otherBool5;
@property (nullable, nonatomic, copy) NSNumber *payeeName;
@property (nullable, nonatomic, copy) NSDate *accDRstartDate;
@property (nullable, nonatomic, copy) NSNumber *budgetNewStyle;
@property (nullable, nonatomic, copy) NSNumber *otherBool6;
@property (nullable, nonatomic, copy) NSString *accDRstring;
@property (nullable, nonatomic, copy) NSNumber *otherBool14;
@property (nullable, nonatomic, copy) NSString *passcode;
@property (nullable, nonatomic, copy) NSNumber *otherBool7;
@property (nullable, nonatomic, copy) NSNumber *otherBool8;
@property (nullable, nonatomic, copy) NSNumber *payeeTranMemo;
@property (nullable, nonatomic, copy) NSNumber *otherBool15;
@property (nullable, nonatomic, copy) NSNumber *payeeTranClear;
@property (nullable, nonatomic, copy) NSNumber *otherBool9;
@property (nullable, nonatomic, copy) NSString *budgetNewStyleCycle;
@property (nullable, nonatomic, copy) NSNumber *otherBool;
@property (nullable, nonatomic, copy) NSDate *cateDRstartDate;
@property (nullable, nonatomic, copy) NSString *sortType;
@property (nullable, nonatomic, copy) NSString *others2;
@property (nullable, nonatomic, copy) NSString *others3;
@property (nullable, nonatomic, copy) NSString *passcodeStyle;
@property (nullable, nonatomic, copy) NSString *others4;
@property (nullable, nonatomic, copy) NSDate *cateDRendDate;
@property (nullable, nonatomic, copy) NSString *others5;
@property (nullable, nonatomic, copy) NSString *others1;
@property (nullable, nonatomic, copy) NSString *others6;
@property (nullable, nonatomic, copy) NSNumber *isBefore;
@property (nullable, nonatomic, copy) NSNumber *otherBool16; // isTryingPremium 1.正在免费试用.
@property (nullable, nonatomic, copy) NSString *others7;
@property (nullable, nonatomic, copy) NSString *others8;
@property (nullable, nonatomic, copy) NSNumber *payeeTranAmount;
@property (nullable, nonatomic, copy) NSString *others9;
@property (nullable, nonatomic, copy) NSString *others;
@property (nullable, nonatomic, copy) NSString *weekstartday;
@property (nullable, nonatomic, copy) NSString *expDRString;
@property (nullable, nonatomic, copy) NSNumber *otherBool17;//是否上传成功
@property (nullable, nonatomic, copy) NSNumber *syncAuto;
@property (nullable, nonatomic, copy) NSString *cateDRstring;
@property (nullable, nonatomic, copy) NSDate *dateTime;
@property (nullable, nonatomic, copy) NSNumber *payeeCfged;
@property (nullable, nonatomic, copy) NSNumber *otherBool10;
@property (nullable, nonatomic, copy) NSNumber *payeeTranType;
@property (nullable, nonatomic, copy) NSString *others10;
@property (nullable, nonatomic, copy) NSNumber *playorder;
@property (nullable, nonatomic, copy) NSDate *purchasedDate;
@property (nullable, nonatomic, copy) NSDate *purchasedStartDate;
@property (nullable, nonatomic, copy) NSDate *purchasedEndDate;
@property (nullable, nonatomic, copy) NSString *purchaseOriginalProductID;
@property (nullable, nonatomic, copy) NSString *purchasedProductID;
@property (nullable, nonatomic, copy) NSDate *purchasedUpdateTime;
@property (nullable, nonatomic, copy) NSNumber *purchasedIsSubscription;

@end

NS_ASSUME_NONNULL_END
