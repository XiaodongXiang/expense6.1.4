//
//  SKProduct+LocalizedPrice.h
//  VectorScanner
//
//  Created by Tommy Zhuang on 8/27/12.
//  Copyright (c) 2012 Tommy Zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end