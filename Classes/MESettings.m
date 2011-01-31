/*
 *  MESettings.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 06.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "MESettings.h"
#import "MEReachability.h"
#import "MEClientStore.h"
#import "MEClient.h"


static NSString *kBookmarksKey         = @"bookmarks";
static NSString *kFetchIntervalKey     = @"fetchInterval";
static NSString *kInitialFetchCountKey = @"initialFetchCount";
static NSString *kMoreFetchCountKey    = @"moreFetchCount";
static NSString *kSaveToPhotosAlbum    = @"saveToPhotosAlbum";


static struct
{
    NSInteger  value;
    NSString  *shortDescription;
    NSString  *longDescription;
} kFetchIntervalDescription[] = {
    {  1, @"1 min",  @"Every 1 Minute"   },
    {  5, @"5 min",  @"Every 5 Minutes"  },
    { 10, @"10 min", @"Every 10 Minutes" },
    { 30, @"30 min", @"Every 30 Minutes" },
    { 60, @"Hourly", @"Hourly"           },
    {  0, @"Off",    @"Manually"         },
    {  0, nil,       nil                 }
};

static struct
{
    NSInteger  value;
    NSString  *description;
} kFetchCountDescription[] = {
    {10,  @"10 posts"  },
    {20,  @"20 posts"  },
    {30,  @"30 posts"  },
    {50,  @"50 posts"  },
    {100, @"100 posts" },
    {0,   nil          },
};


@implementation MESettings


+ (NSArray *)bookmarks
{
    NSData *sData;

    sData = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:kBookmarksKey] objectForKey:[[MEClientStore currentClient] userID]];

    return sData ? [NSKeyedUnarchiver unarchiveObjectWithData:sData] : [NSArray array];
}

+ (void)setBookmarks:(NSArray *)aBookmarks
{
    NSMutableDictionary *sBookmarks;

    sBookmarks = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:kBookmarksKey] mutableCopy];

    if (!sBookmarks)
    {
        sBookmarks = [[NSMutableDictionary alloc] init];
    }

    if (aBookmarks)
    {
        [sBookmarks setObject:[NSKeyedArchiver archivedDataWithRootObject:aBookmarks] forKey:[[MEClientStore currentClient] userID]];
    }
    else
    {
        [sBookmarks removeObjectForKey:[[MEClientStore currentClient] userID]];
    }

    [[NSUserDefaults standardUserDefaults] setObject:sBookmarks forKey:kBookmarksKey];

    [sBookmarks release];
}


+ (NSString *)shortDescriptionForFetchInterval:(NSInteger)aValue
{
    int i;

    for (i = 0; kFetchIntervalDescription[i].shortDescription; i++)
    {
        if (kFetchIntervalDescription[i].value == aValue)
        {
            return NSLocalizedString(kFetchIntervalDescription[i].shortDescription, @"");
        }
    }

    return nil;
}

+ (NSString *)longDescriptionForFetchInterval:(NSInteger)aValue
{
    int i;

    for (i = 0; kFetchIntervalDescription[i].longDescription; i++)
    {
        if (kFetchIntervalDescription[i].value == aValue)
        {
            return NSLocalizedString(kFetchIntervalDescription[i].longDescription, @"");
        }
    }

    return nil;
}

+ (NSString *)descriptionForFetchCount:(NSInteger)aValue
{
    int i;

    for (i = 0; kFetchCountDescription[i].description; i++)
    {
        if (kFetchCountDescription[i].value == aValue)
        {
            return NSLocalizedString(kFetchCountDescription[i].description, @"");
        }
    }

    return nil;
}


+ (BOOL)couldImplicitFetch
{
    return [MEReachability isInternetAvailable];
}


+ (NSInteger)fetchInterval
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kFetchIntervalKey];
}

+ (void)setFetchInterval:(NSInteger)aInterval
{
    [[NSUserDefaults standardUserDefaults] setInteger:aInterval forKey:kFetchIntervalKey];
}


+ (NSInteger)initialFetchCount
{
    NSInteger sResult = [[NSUserDefaults standardUserDefaults] integerForKey:kInitialFetchCountKey];

    return sResult ? sResult : 30;
}

+ (void)setInitialFetchCount:(NSInteger)aCount
{
    [[NSUserDefaults standardUserDefaults] setInteger:aCount forKey:kInitialFetchCountKey];
}


+ (NSInteger)moreFetchCount
{
    NSInteger sResult = [[NSUserDefaults standardUserDefaults] integerForKey:kMoreFetchCountKey];

    return sResult ? sResult : 30;
}

+ (void)setMoreFetchCount:(NSInteger)aCount
{
    [[NSUserDefaults standardUserDefaults] setInteger:aCount forKey:kMoreFetchCountKey];
}


+ (BOOL)saveToPhotosAlbum
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSaveToPhotosAlbum];
}

+ (void)setSaveToPhotosAlbum:(BOOL)aSaveToPhotosAlbum
{
    [[NSUserDefaults standardUserDefaults] setBool:aSaveToPhotosAlbum forKey:kSaveToPhotosAlbum];
}


@end
