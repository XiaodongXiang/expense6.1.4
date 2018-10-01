//
//  BHI_Utility.m
//
//  Created by Joe Jia on 3/31/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "BHI_Utility.h"
#include <sys/types.h>
#include <sys/sysctl.h>


@implementation BHI_Utility

+(NSNumber*)getMusicItemIdFromString:(NSString*)string
{
	unsigned long long value = strtoull([string UTF8String], NULL, 0);
	NSNumber* musicId = [NSNumber numberWithUnsignedLongLong:value];

	return musicId;
}

+(NSString*)getStringFromMusicItemId:(NSNumber*)number
{
	unsigned long long value = [number unsignedLongLongValue];
	NSString* str = [NSString stringWithFormat:@"%llu", value];
	
	return str;
}

+(NSURL*)urlFromSetting
{
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *plistPath = [bundle pathForResource:
						   @"settings" ofType:@"plist"];
	NSDictionary* setting = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
	NSDictionary* pushNews = [setting objectForKey:@"PushNews"];
	NSString* urlStr = [pushNews objectForKey:@"URL"];
	NSURL* url = [NSURL URLWithString:urlStr];
	
	return url;
}

+(NSString*)getMessageFromError:(NSError*)error
{
	return @"error";
}


@end

@implementation UIImage (BHI_Extensions)

+(UIImage*)imageFromMaskImage:(UIImage*)img withColor:(CGColorRef)colorref
{
	UIGraphicsBeginImageContext(img.size);
	
	CGRect contextRect;
	contextRect.origin.x = 0.0f;
	contextRect.origin.y = 0.0f;
	contextRect.size = [img size];
	// Retrieve source image and begin image context
	CGSize itemImageSize = [img size];
	CGPoint itemImagePosition;
	itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
	itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) );
	
    UIGraphicsBeginImageContextWithOptions(img.size, NO, [UIScreen mainScreen].scale);
    
	CGContextRef c = UIGraphicsGetCurrentContext();
	// Setup shadow
	// Setup transparency layer and clip to mask
	//CGContextSetShadow(c, CGSizeMake(1, 1), 5);
	//CGContextSetShadowWithColor (c, CGSizeMake(0, 1), 2, [UIColor whiteColor].CGColor);// 11 
	CGContextSetBlendMode(c, kCGBlendModeMultiply);
	CGContextBeginTransparencyLayer(c, NULL);
	CGContextScaleCTM(c, 1.0, -1.0);
	CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [img CGImage]);
	// Fill and end the transparency layer
	
	CGContextSetFillColorWithColor(c, colorref);
	contextRect.size.height = -contextRect.size.height;
	contextRect.size.height -= 15;
	CGContextFillRect(c, contextRect);
	//	[[UIImage imageNamed:@"color-tag.png"] drawInRect:CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height)];
	
	CGContextEndTransparencyLayer(c);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;	
}
+(UIImage*)imageByScalingAndCroppingForSize:(UIImage*)selectedImage withTargetSize:(CGSize)size
{
	UIImage *newImage = nil;       
	CGSize imageSize = selectedImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = size.width;
	CGFloat targetHeight = size.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, size) == NO)
	{
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor > heightFactor)
			scaleFactor = widthFactor; // scale to fit height
		else
			scaleFactor = heightFactor; // scale to fit width
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
		else
			if (widthFactor < heightFactor)
			{
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
	}       
	
	UIGraphicsBeginImageContext(size); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[selectedImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil)
		NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}	

+(UIImage*)imageByZoomingFromImage:(UIImage*)selectedImage withTargetSize:(CGSize)size
{
	//°CGRect rect = CGRectMake(8+(8 + 70)*colIndex, 8+(8 + 70)*rowIndex, 70, 70);
	UIImage* image = selectedImage;
	
	if ((float)image.size.width/(float)image.size.height > (float)size.width/(float)size.height) 
	{
		float height = (size.width * image.size.height) / image.size.width ;
		size = CGSizeMake(size.width, height);
	}
	else 
	{			
		float width = (size.width * image.size.width) / image.size.height ;
		size = CGSizeMake(width, size.height);
	}
	UIGraphicsBeginImageContext(size); 
	[image drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModePlusDarker alpha:1];
	
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

@end





