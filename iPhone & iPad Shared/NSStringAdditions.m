//
//  UIImage(iPhone6).m
//  PocketExpense
//
//  Created by humingjing on 14/10/30.
//
//

#import "NSStringAdditions.h"

@implementation NSString (StringAdditions)


+ (NSString *)customImageName:(NSString *)name
{
 
    if ([UIScreen mainScreen].bounds.size.width == IPHONE6_WITH)
    {
        name = [NSString stringWithFormat:@"iphone6_%@",name];
    }
    return name;
}



@end
