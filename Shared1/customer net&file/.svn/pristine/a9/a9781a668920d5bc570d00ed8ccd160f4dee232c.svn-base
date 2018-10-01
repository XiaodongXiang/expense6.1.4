//
//  Http.m
//  NetServersTest
//
//  Created by BHI_H02 on 6/21/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "Http.h"

@interface Http(NSObject)

- (void)displayInfoUpdate:(NSNotification *) notification;
-(void)display:(NSString*)string;

@end


@implementation Http
@synthesize delegate;


-(id)initWithServer;
{
	NSString *root = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
	
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:root]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoUpdate:) name:@"LocalhostAdressesResolved" object:nil];
	[localhostAddresses performSelectorInBackground:@selector(list) withObject:nil];
	NSError *error;
	if(![httpServer start:&error])
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
	
	[self displayInfoUpdate:nil];
	
	return self;
}
-(void)display:(NSString*)string
{
	[self.delegate displayInfo:string];
}
- (void)displayInfoUpdate:(NSNotification *) notification
{
	NSLog(@"displayInfoUpdate:");
	
	if(notification)
	{
		[addresses release];
		addresses = [[notification object] copy];
		NSLog(@"addresses: %@", addresses);
	}
	
	if(addresses == nil)
	{
		return;
	}
	
	NSString *info;
	//UInt16 port = [httpServer port];
	
	NSString *localIP = nil;
	
	localIP = [addresses objectForKey:@"en0"];
	
	if (!localIP)
	{
		localIP = [addresses objectForKey:@"en1"];
	}
	
	if (!localIP)
		info = @"Wifi: No Connection!\n";
	else
		info = [NSString stringWithFormat:@"http://%@:%d\n", localIP, 50001];
	
	[self display:info];
}
-(void)stop
{
	[httpServer release];
}

@end
