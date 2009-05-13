/*
 *  MEImageCache.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 20.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEImageCache.h"


static NSMutableDictionary *gCachedImages = nil;


@implementation MEImageCache

+ (void)initialize
{
    if (!gCachedImages)
    {
        gCachedImages = [[NSMutableDictionary alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
}

+ (void)didReceiveMemoryWarning:(NSNotification *)aNotification
{
    [gCachedImages removeAllObjects];
}


+ (void)createDirectoryForCachePath:(NSString *)aPath
{
    NSFileManager *sFileManager;
    NSString      *sDir;
    NSError       *sError;
    BOOL           sIsDir;

    sFileManager = [NSFileManager defaultManager];
    sDir         = [aPath stringByDeletingLastPathComponent];

    if ([sFileManager fileExistsAtPath:sDir isDirectory:&sIsDir])
    {
        if (!sIsDir)
        {
            NSLog(@"mkdir error: file already exists at %@", sDir);
            return;
        }
    }
    else
    {
        if (![sFileManager createDirectoryAtPath:sDir withIntermediateDirectories:YES attributes:nil error:&sError])
        {
            NSLog(@"mkdir error: %@", sError);
            return;
        }
    }
}

+ (NSString *)cachePathWithURL:(NSURL *)aURL
{
    static NSString *sCacheDir = nil;

    if (!sCacheDir)
    {
        NSArray *sDirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

        sCacheDir = [[sDirs objectAtIndex:0] retain];
    }

    if (aURL)
    {
        NSString *sPath = sCacheDir;

        if ([aURL host])
        {
            sPath = [sPath stringByAppendingPathComponent:[aURL host]];
        }
        if ([aURL port])
        {
            sPath = [sPath stringByAppendingPathComponent:[[aURL port] stringValue]];
        }

        return [sPath stringByAppendingPathComponent:[aURL path]];
    }
    else
    {
        return sCacheDir;
    }
}


+ (UIImage *)imageForURL:(NSURL *)aURL
{
    UIImage *sImage;

    sImage = [gCachedImages objectForKey:aURL];

    if (!sImage)
    {
        sImage = [UIImage imageWithContentsOfFile:[self cachePathWithURL:aURL]];

        if (sImage)
        {
            [gCachedImages setObject:sImage forKey:aURL];
        }
    }

    return sImage;
}

+ (void)storeImage:(UIImage *)aImage data:(NSData *)aData forURL:(NSURL *)aURL
{
    [gCachedImages setObject:aImage forKey:aURL];

    if (aData)
    {
        NSString *sCachePath = [self cachePathWithURL:aURL];

        [self createDirectoryForCachePath:sCachePath];
        [aData writeToFile:sCachePath atomically:YES];
    }
}

+ (void)removeCachedImagesInMemory
{
    [gCachedImages removeAllObjects];
}

+ (void)removeCachedImagesInDisk
{
    [[NSFileManager defaultManager] removeItemAtPath:[self cachePathWithURL:nil] error:NULL];
}

@end
