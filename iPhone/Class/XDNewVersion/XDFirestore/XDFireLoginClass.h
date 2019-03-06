//
//  XDFireLoginClass.h
//  PocketExpense
//
//  Created by 晓东项 on 2019/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDFireLoginClass : NSObject

+(XDFireLoginClass*)share;


-(void)sendEmail:(NSString*)email;
@end

NS_ASSUME_NONNULL_END
