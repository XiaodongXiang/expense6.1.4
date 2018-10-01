//
//  BHI_Utility.h
//
//  Created by Joe Jia on 7/5/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO



#pragma mark -
#pragma mark General Extensions
@interface BHI_Utility : NSObject

+(NSURL*)urlFromSetting;
+(NSString*)getMessageFromError:(NSError*)error;
+(NSNumber*)getMusicItemIdFromString:(NSString*)string;
+(NSString*)getStringFromMusicItemId:(NSNumber*)number;

@end



#pragma mark UIImage Extensions
@interface UIImage (BHI_Extensions)

+(UIImage*)imageByScalingAndCroppingForSize:(UIImage*)selectedImage withTargetSize:(CGSize)size;
+(UIImage*)imageByZoomingFromImage:(UIImage*)selectedImage withTargetSize:(CGSize)size;
+(UIImage*)imageFromMaskImage:(UIImage*)img withColor:(CGColorRef)colorref;

@end










