//
//  AccountSelect.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-22.
//
//

#import <Foundation/Foundation.h>

#import "Accounts.h"

@interface AccountSelect : NSObject{
    Accounts *account;
    BOOL      isSelected;
}

@property(nonatomic,strong)Accounts *account;
@property(nonatomic,assign)BOOL      isSelected;
@end
