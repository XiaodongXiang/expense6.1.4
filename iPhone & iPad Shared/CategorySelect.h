//
//  CategorySelect.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-11.
//
//

#import <Foundation/Foundation.h>
#import "Category.h"

typedef enum {
    noneType =0, //默认的什么类型都不是
	parentWithChild = 1,//有子类的父类
	childOnly =2,//只是子类
	parentNoChild =3 //没有子类的父类
 	
}CategoryPCType;

@interface CategorySelect : NSObject{
    Category *category;
 	BOOL isSelect;
    double amount;
    NSString *memo;
    CategoryPCType pcType;
    NSString *cateName;
    
    
}
@property (nonatomic, strong) Category *category;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) double amount;
@property (nonatomic, strong)  NSString *memo;
@property (nonatomic, assign) CategoryPCType pcType;
@property (nonatomic, strong) NSString *cateName;
@end
