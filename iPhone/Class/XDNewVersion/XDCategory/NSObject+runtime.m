//
//  NSObject+runtime.m
//  PocketExpense
//
//  Created by 晓东项 on 2019/2/26.
//

#import "NSObject+runtime.h"
#import <objc/runtime.h>

@implementation NSObject (runtime)

-(NSMutableDictionary *)dicWithItem{
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        
        if (propertyValue) {
            [props setValue:propertyValue forKey:propertyName];
        }else{
            [props setValue:[NSNull null] forKey:propertyName];
        }
    }
    free(properties);
    return props;
}

@end
