//
//  DropboxSyncTableDefine.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-16.
//
//

#import <Foundation/Foundation.h>

#define DB_ACCOUNT_TABLE                @"db_account_table"
#define DB_ACCOUNTTYPE_TABLE            @"db_accounttype_table"
#define DB_APPLICATIONDBVERSION_TABLE   @"db_applicationdbversion_table"
#define DB_BUDGETITEM_TABLE             @"db_budgetitem_table"
#define DB_BUDGETTEMPLATE_TABLE         @"db_budgettemplate_table"
#define DB_BUDGETTRANSFER_TABLE         @"db_budgettransfer_table"
#define DB_CATEGORY_TABLE               @"db_category_table"
#define DB_EP_BILLITEM_TABLE            @"db_ep_billitem_table"
#define DB_EP_BILLRULE_TABLE            @"db_ep_billrule_table"
#define DB_PAYEE_TABLE                  @"db_payee_table"
#define DB_SETTING_TABLE                @"db_setting_table"
#define DB_TRANSACTION_TABLE            @"db_transaction_table"


#define LOCAL_ACCOUNT_TABLE             @"Accounts"
#define LOCAL_ACCOUNTTYPE_TABLE         @"AccountType"
#define LOCAL_CATEGORY_TABLE            @"Category"
#define LOCAL_PAYEE_TABLE               @"Payee"
#define LOCAL_BUDGETTEMPLATE_TABLE      @"BudgetTemplate"
#define LOCAL_BUDGETITEM_TABLE          @"BudgetItem"
#define LOCAL_BUDGETTRANSFER_TABLE      @"BudgetTransfer"
#define LOCAL_BILLRULE_TABLE            @"EP_BillRule"
#define LOCAL_BILLITEM_TABLE            @"EP_BillItem"
#define LOCAL_TRANSACTION_TABLE         @"Transaction"
#define LOCAL_SETTING_TABLE             @"Setting"

//account
#pragma mark Account

#define ACCOUNT_NAME                    @"name"
#define ACCOUNT_AMOUNT                  @"amount"
#define ACCOUNT_AUTOCLEAR               @"autoclear"
#define ACCOUNT_DATETIME                @"datetime"
#define ACCOUNT_ORDERINDEX              @"orderindex"
#define ACCOUNT_RECONCILE               @"reconcile"

#define ACCOUNT_STATE                   @"state"
#define ACCOUNT_DATETIME_SYNC           @"dateTime_sync"
#define ACCOUNT_UUID                    @"uuid"

#define ACCOUNT_ACCOUNTTYPE             @"accountType"
#define ACCOUNT_EXPENSETRANSACTON_UUIDS @"expenseTransaction"
#define ACCOUNT_INCOMETRANSACTION_UUIDS @"incomeTransaction"


//accounttype
#pragma mark AccountType

#define ACCOUNTTYPE_ICONNAME            @"accounttype_iconname"
#define ACCOUNTTYPE_ISDEFAULT           @"accounttype_isdefault"
#define ACCOUNTTYPE_ORDERINDEX          @"accounttype_orderindex"
#define ACCOUNTTYPE_OTHERS              @"accounttype_others"
#define ACCOUNTTYPE_TYPENAME            @"accounttype_typename"

#define ACCOUNTTYPE_STATE               @"state"
#define ACCOUNTTYPE_DATETIME            @"dateTime"
#define ACCOUNTTYPE_UUID                @"uuid"


//budgetitem
#pragma mark Budget Item

#define BUDGETITEM_AMOUNT               @"budgetitem_amount"
#define BUDGETITEM_ENDDATE              @"budgetitem_enddate"
#define BUDGETITEM_ISCURRENT            @"budgetitem_iscurrent"
#define BUDGETITEM_ISROLLOVER           @"budgetitem_isrollover"
#define BUDGETITEM_ORDERINDEX           @"budgetitem_orderindex"
#define BUDGETITEM_ROLLOVERAMOUNT       @"budgetitem_rolloveramount"
#define BUDGETITEM_STARTDATE            @"budgetitem_startdate"

#define BUDGETITEM_STATE               @"state"
#define BUDGETITEM_DATETIME            @"dateTime"
#define BUDGETITEM_UUID                @"uuid"

#define BUDGETITEM_BUDGETTEMPLATE       @"budgetitem_budgettemplate"


//budgettemplate
#pragma mark Budget Template

#define BUDGETTEMPLATE_AMOUNT           @"budgettemplate_amount"
#define BUDGETTEMPLATE_CYCLETYPE        @"budgettemplate_cycletype"
#define BUDGETTEMPLATE_ISNEW            @"budgettemplate_isnew"
#define BUDGETTEMPLATE_ISROLLOVER       @"budgettemplate_isrollover"
#define BUDGETTEMPLATE_ORDERINDEX       @"budgettemplate_orderindex"
#define BUDGETTEMPLATE_STARTDATE        @"budgettemplate_startdate"
#define BUDGETTEMPLATE_STARTDATEHASCHANGE  @"startdatehaschange"

#define BUDGETTEMPLATE_STATE               @"state"
#define BUDGETTEMPLATE_DATETIME            @"dateTime"
#define BUDGETTEMPLATE_UUID                @"uuid"

#define BUDGETTEMPLATE_CATEGORY             @"budgettemplate_category"


//budgettransfer table field key
#pragma mark Budget Transfer

#define BUDGETTRANSFER_AMOUNT           @"budgettransfer_amount"
#define BUDGETTRANSFER_DATETIME         @"budgettransfer_datetime"

#define BUDGETTRANSFER_STATE               @"state"
#define BUDGETTRANSFER_DATETIME_SYNC      @"dateTime_sync"
#define BUDGETTRANSFER_UUID                @"uuid"

#define BUDGETTRANSFER_FROMBUDGET           @"budget_frombudget"
#define BUDGETTRANSFER_TOBUDGET             @"budget_tobudget"

//category
#pragma mark Category

#define CATEGORY_CATEGORYNAME           @"category_categoryname"
#define CATEGORY_CATEGORYTYPE           @"category_categorytype"
#define CATEGORY_HASBUDGET              @"category_hasbudget"
#define CATEGORY_ICONNAME               @"category_iconname"
#define CATEGORY_ISDEFAULT              @"category_isdefault"
#define CATEGORY_ISSYSTEMRECORD         @"category_issystemrecord"
#define CATEGORY_RECORDINDEX            @"category_recordIndex"

#define CATEGORY_STATE               @"state"
#define CATEGORY_DATETIME            @"dateTime"
#define CATEGORY_UUID                @"uuid"

//billitem
#pragma mark BillItem

#define BILLITEM_EP_BILLISDELETE                @"billitem_ep_billisdelete"
#define BILLITEM_EP_BILLITEMAMOUNT              @"billitem_ep_billitemamount"
#define BILLITEM_EP_BILLITEMBOOL1               @"billitem_ep_billitembool1"
#define BILLITEM_EP_BILLITEMBOOL2               @"billitem_ep_billitembool2"
#define BILLITEM_EP_BILLITEMDATE1               @"billitem_ep_billitemdate1"
#define BILLITEM_EP_BILLITEMDATE2               @"billitem_ep_billitemdate2"
#define BILLITEM_EP_BILLITEMDUEDATE             @"billitem_ep_billitemduedate"
#define BILLITEM_EP_BILLITEMDUEDATENEW          @"billitem_ep_billitemduedatenew"
#define BILLITEM_EP_BILLITEMENDDATE             @"billitem_ep_billitemenddate"
#define BILLITEM_EP_BILLITEMNAME                @"billitem_ep_billitemname"
#define BILLITEM_EP_BILLITEMNOTE                @"billitem_ep_billitemnote"
#define BILLITEM_EP_BILLITEMRECURRING           @"billitem_ep_billitemrecurring"
#define BILLITEM_EP_BILLITEMREMINDERDATE        @"billitem_ep_billitemreminderdate"
#define BILLITEM_EP_BILLITEMREMINDERTIME        @"billitem_ep_billitemremindertime"
#define BILLITEM_EP_BILLITEMSTRING1             @"billitem_ep_billitemstring1"

#define BILLITEMHASBILLRULE                     @"billitemhasbillrule"
#define BILLITEMHASPAYEE                        @"billitemhaspayee"
#define BILLITEMHASTRANSACTION                  @"billitemhastransaction"
#define BILLITEMHASCATEGORY                     @"billitemhascategory"


#define BILLITEM_STATE               @"state"
#define BILLITEM_DATETIME            @"dateTime"
#define BILLITEM_UUID                @"uuid"

//ep_billrule
#pragma mark Bill Rule

#define BILLRULE_EP_BILLAMOUNT                  @"billrule_ep_billamount"
#define BILLRULE_EP_BILLDUEDATE                 @"billrule_ep_billduedate"
#define BILLRULE_EP_BILLENDDATE                 @"billrule_ep_billenddate"
#define BILLRULE_EP_BILLNAME                    @"billrule_ep_billname"
#define BILLRULE_EP_NOTE                        @"billrule_ep_note"
#define BILLRULE_EP_RECURRINGTYPE               @"billrule_ep_recurringtype"
#define BILLRULE_EP_REMINDERDATE                @"billrule_ep_reminderdate"
#define BILLRULE_EP_REMINDERTIME                @"billrule_ep_remindertime"

#define BILLRULE_STATE               @"state"
#define BILLRULE_DATETIME            @"dateTime"
#define BILLRULE_UUID                @"uuid"

#define BILLRULE_BILLRULEHASBILLITEM @"billrulehasbillitem"
#define BILLRULE_BILLRULEHASCATEGORY    @"billrulehascategory"
#define BILLRULE_BILLRULEHASPAYEE       @"billrulehaspayee"
#define BILLRULE_BILLRULEHASRTANSACTION @"billrulehastransaction"


//payee
#pragma mark Payee

#define PAYEE_NAME                          @"payee_name"
#define PAYEE_MEMO                          @"payee_memo"
#define PAYEE_TRANSTYPE                     @"payee_transtype"

#define PAYEE_CATEGORY                      @"payee_category"

#define PAYEE_STATE               @"state"
#define PAYEE_DATETIME            @"dateTime"
#define PAYEE_UUID                @"uuid"


//setting
#pragma mark Setting

#define SETTING_ACCDRENDDATE                @"setting_accdrenddate"
#define SETTING_ACCDRSTARTDATE              @"setting_accdrstartdate"
#define SETTING_ACCDRSTRING                 @"setting_accdrstring"
#define SETTING_BUDGETNEWSTYLE              @"setting_budgetnewstyle"
#define SETTING_BUDGETNRESTYLECYCLE         @"setting_budgetnewstylecycle"
#define SETTING_CATEDRENDDATE               @"setting_catedrenddate"
#define SETTING_CATEDRSTARTDATE             @"setting_catedrstartdate"
#define SETTING_CATEDRSTRIGN                @"setting_catedrdrstring"
#define SETTING_CURRENCY                    @"setting_currency"
#define SETTING_EXPDBSTRING                 @"setting_expdrstring"
#define SETTING_EXPENSELASTVIEW             @"setting_expenselastview"
#define SETTING_ISBEFORE                    @"setting_isbefore"
#define SETTING_OTHERBOOL                  @"setting_therbool"
#define SETTING_OTHERBOOL1                  @"setting_otherbool1"
#define SETTING_OTHERBOOL2                  @"setting_otherbool2"
#define SETTING_OTHERBOOL3                  @"setting_therbool3"
#define SETTING_OTHERBOOL4                  @"setting_therbool4"
#define SETTING_OTHERBOOL5                  @"setting_therbool5"
#define SETTING_OTHERBOOL6                  @"setting_therbool6"
#define SETTING_OTHERBOOL7                  @"setting_therbool7"
#define SETTING_OTHERBOOL8                  @"setting_therbool8"
#define SETTING_OTHERBOOL9                  @"setting_therbool9"
#define SETTING_OTHERBOOL10                 @"setting_therbool10"
#define SETTING_OTHERBOOL11                 @"setting_therbool11"
#define SETTING_OTHERBOOL12                 @"setting_therbool12"
#define SETTING_OTHERBOOL13                 @"setting_therbool13"
#define SETTING_OTHERBOOL14                 @"setting_therbool14"
#define SETTING_OTHERBOOL15                 @"setting_therbool15"
#define SETTING_OTHERBOOL16                 @"setting_therbool16"
#define SETTING_OTHERBOOL17                 @"setting_therbool17"
#define SETTING_OTHERBOOL18                 @"setting_therbool18"
#define SETTING_OTHERBOOL19                 @"setting_therbool19"
#define SETTING_OTHERBOOL20                 @"setting_therbool20"
#define SETTING_OTHERS                      @"setting_others"
#define SETTING_OTHERS1                     @"setting_others1"
#define SETTING_OTHERS2                     @"setting_others2"
#define SETTING_OTHERS3                     @"setting_others3"
#define SETTING_OTHERS4                     @"setting_others4"
#define SETTING_OTHERS5                     @"setting_others5"
#define SETTING_OTHERS6                     @"setting_others6"
#define SETTING_OTHERS7                     @"setting_others7"
#define SETTING_OTHERS8                     @"setting_others8"
#define SETTING_OTHERS9                     @"setting_others9"
#define SETTING_OTHERS10                    @"setting_others10"
#define SETTING_OTHERS11                    @"setting_others11"
#define SETTING_OTHERS12                    @"setting_others12"
#define SETTING_OTHERS13                    @"setting_others13"
#define SETTING_OTHERS14                    @"setting_others14"
#define SETTING_OTHERS15                    @"setting_others15"
#define SETTING_OTHERS16                    @"setting_others16"
#define SETTING_OTHERS17                    @"setting_others17"
#define SETTING_OTHERS18                    @"setting_others18"
#define SETTING_OTHERS19                    @"setting_others19"
#define SETTING_OTHERS20                    @"setting_others20"
#define SETTING_PASSCODE                    @"setting_passcode"
#define SETTING_PAYEECATEGORY               @"setting_payeecategory"
#define SETTING_PAYEECFGED                  @"setting_payeecfged"
#define SETTING_PAYYEEMEMO                  @"setting_payeememo"
#define SETTING_PAYEENAME                   @"setting_payeename"
#define SETTING_PAYEETRANAMOUNT             @"setting_payeetranamount"
#define SETTING_PAYEETRANCLEAR              @"setting_payeetranclear"
#define SETTING_PAYEETRANMEMO               @"setting_payeetranmemo"
#define SETTING_PAYEETRANTYPE               @"setting_payeetrantype"
#define SETTING_PLAYORDER                   @"setting_playorder"
#define SETTING_SORTTYPE                    @"setting_sorttype"
#define SETTING_WEEKSTARTDAY                @"setting_weekstartday"


#define SETTING_STATE               @"state"
#define SETTING_DATETIME            @"dateTime"
#define SETTING_UUID                @"uuid"

//transaction
#pragma mark Transaction

#define TRANSACTION_AMOUNT                     @"trans_amount"
#define TRANSACTION_DATETIME                   @"trans_datetime"
#define TRANSACTION_ISCLEAR                    @"trans_isclear"
#define TRANSACTION_NOTES                      @"trans_notes"
#define TRANSACTION_RECURRINGTYPE              @"trans_recurringtype"
#define TRANSACTION_TYPE                       @"trans_type"
#define TRANSACTION_TRANSACTIONSTRING           @"trans_string"

#define TRANSACTION_PAYEE                       @"trans_payee"
#define TRANSACTION_INCOMEACCOUNT               @"trans_incomeaccount"
#define TRANSACTION_EXPENSEACCOUNT              @"trans_expenseaccount"
#define TRANSACTION_CATEGORY                    @"trans_category"
#define TRANSACTION_CHILDTRANSACTION            @"trans_childtransaction"
#define TRANSACTION_PARTRANSACTION              @"trans_partransaction"

#define TRANSACTION_BILLRULE                    @"trans_billrule"
#define TRANSACTION_BILLITEM                    @"trans_billitem"



#define TRANSACTION_STATE                       @"state"
#define TRANSACTION_DATETIME_SYNC               @"dateTime_sync"
#define TRANSACTION_UUID                       @"uuid"

@interface DropboxSyncTableDefine : NSObject

@end
