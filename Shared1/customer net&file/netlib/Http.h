//
//  Http.h
//  NetServersTest
//
//  Created by BHI_H02 on 6/21/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "ZipArchive.h"
#import "localhostAddresses.h"

@protocol HttpDelegate;

//---------新定义的一个类，用来存储地址，数据的
@interface Http : NSObject{
	id<HttpDelegate>	delegate;
	
    //网络服务器
	HTTPServer *httpServer;
	NSDictionary *addresses;
	//存储数据的
	NSData*		  mailZipData;
}

@property (nonatomic, retain)	id<HttpDelegate>	delegate;


-(id)initWithServer;
-(void)stop;
//-(void)createZipFile;
@end
@protocol HttpDelegate <NSObject>

-(void)displayInfo:(NSString*)info;
//-(void)setServerPort:(UInt16)port;
//-(void)uploadFinished;

@end
