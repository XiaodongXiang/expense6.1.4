//
//  DropboxObject.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-16.
//
//

#import <Foundation/Foundation.h>
#import <Dropbox/Dropbox.h>
#import "HMJSyncIndicatorView.h"

#define SYNC_MAX_COUNT  900

NSString *const syncNeedToReflashUI;

@class SyncViewController,AccountType,Accounts,Transaction,Payee,Category,EP_BillRule,EP_BillItem,BudgetTemplate,BudgetItem,BudgetTransfer;
@interface DropboxObject : NSObject<UIAlertViewDelegate>{
    DBAccountManager        *drop_accountManager;
    DBAccount               *drop_account;
//    DBDatastore             *drop_dataStore;
    DBDatastoreManager      *drop_dataStoreManager;
    
    BOOL                    needToReflesh;
    BOOL                    isBegaintoReplaceorInteraction;
    NSURLConnection *connection;
    
    int             countMax;
//    BOOL            needCountMax;
    NSDictionary    *changed;

}

@property(nonatomic,strong)HMJSyncIndicatorView *syncIndicatorView;

@property(nonatomic,strong)DBAccountManager        *drop_accountManager;
@property(nonatomic,strong)DBAccount               *drop_account;
@property(nonatomic,strong)DBDatastore             *drop_dataStore;
@property(nonatomic,strong)DBDatastoreManager      *drop_dataStoreManager;

@property(nonatomic,assign)BOOL                    isNeedFlashAll;
//@property(nonatomic,setter = setBegaintoReplaceorInteraction:)BOOL                    isBegaintoReplaceorInteraction;
@property(nonatomic,assign)BOOL                    isBegaintoReplaceorInteraction;

-(id)init;
-(void)linkDropBoxAccount:(BOOL)needtodrop fromViewController:(id)syncViewController;
-(void)dropbox_handleOpenURL:(NSURL *)url;

//account
-(void)updateEveryAccountDataFromLocal:(Accounts *)localAccount;

//accountType
-(void)updateEveryAccountTypeDataFromLocal:(AccountType *)localAccountType;


//payee
-(void)updateEveryPayeeDataFromLocal:(Payee *)localPayee;
-(void)saveSeverPayee:(DBRecord *)oneRecord fromLocalPayee:(Payee *)localPayee;
-(id)saveLocalPayee:(Payee *)localPayee FromServerPayee:(DBRecord *)oneRecord;

//category
-(void)updateEveryCategoryDataFromLocal:(Category *)localCategory;

//transaction
-(void)updateEveryTransactionDataFromLocal:(Transaction *)localTransaction;
-(id)saveLocalTransaction:(Transaction *)localTrans FromServerTransaction:(DBRecord *)oneRecord;
-(void)saveSeverTransaction:(DBRecord *)oneRecord fromLocalTransaction:(Transaction *)localTransaction;

//bill rule
-(void)updateEveryBillRuleDataFromLocal:(EP_BillRule *)localBillRule;


//bill item
-(void)updateEveryBillItemDataFromLocal:(EP_BillItem *)localBillItem;
-(void)saveSeverBillItem:(DBRecord *)oneRecord fromLocalBillItem:(EP_BillItem *)locBillItem;

//budget template
-(id)updateEveryBudgetTemplateDataFromLocal:(BudgetTemplate *)localBudgetTemplate;
//budget item
-(void)updateEveryBudgetItemDataFromLocal:(BudgetItem *)localBudgetItem;
//budget transfer
-(void)updateEveryBudgetTransferDataFromLocal:(BudgetTransfer *)localBudgetTransfer;


@end
