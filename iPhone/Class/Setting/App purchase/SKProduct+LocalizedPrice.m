//
//  SKProduct+LocalizedPrice.m
//  VectorScanner
//
//  Created by Tommy Zhuang on 8/27/12.
//  Copyright (c) 2012 Tommy Zhuang. All rights reserved.
//

#import "SKProduct+LocalizedPrice.h"

@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    return formattedString;
    
    
    
//    NSNumberFormatter *numberFmt =[[NSNumberFormatter alloc] init];
//    [numberFmt setFormatterBehavior:NSNumberFormatterBehavior10_4];
//    
//    [numberFmt setNumberStyle:NSNumberFormatterCurrencyStyle];
//    [numberFmt setLocale:l];
//    [numberFmt setMaximumFractionDigits:2];
//    // [adBtn setTitle:[numberFmt stringFromNumber:[NSNumber numberWithDouble:p]] forState:UIControlStateNormal];
//    
//    priceLabel.text=[numberFmt stringFromNumber:[NSNumber numberWithDouble:p]];
//    AppDelegate *app = [[UIApplication sharedApplication] delegate];
//    [app._settingsValue setValue:[numberFmt stringFromNumber:[NSNumber numberWithDouble:p]] forKey:@"PurchasePirce"];
//    [VScanEngine saveSettingPlistFile: app._settingsValue];
//    [numberFmt release];
}


@end
