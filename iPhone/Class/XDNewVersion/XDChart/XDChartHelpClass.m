//
//  XDChartHelpClass.m
//  PocketExpense
//
//  Created by 晓东 on 2018/6/6.
//

#import "XDChartHelpClass.h"

@interface XDChartHelpClass()
{
    dispatch_queue_t myQueue;
}
@end

@implementation XDChartHelpClass

+(XDChartHelpClass *)shareClass{
    static XDChartHelpClass* g_shareClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_shareClass = [[XDChartHelpClass alloc]init];
    });
    return g_shareClass;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        myQueue = dispatch_queue_create("MyQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

-(void)getChartTimeRange{
    
    dispatch_async(myQueue, ^{
        NSLog(@"[NSThread currentThread] ==  %@",[NSThread currentThread]);
        

    });
    
}

@end
