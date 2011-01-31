/*
 *  MEImageCache.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 20.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface MEImageCache : NSObject
{
    NSMutableDictionary *mCachedImages;
}

+ (UIImage *)imageForURL:(NSURL *)aURL;
+ (void)storeImage:(UIImage *)aImage data:(NSData *)aData forURL:(NSURL *)aURL;

+ (void)removeCachedImagesInMemory;
+ (void)removeCachedImagesInDisk;

@end
