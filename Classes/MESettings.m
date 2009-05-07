/*
 *  MESettings.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 06.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MESettings.h"


static NSString *kFetchIntervalKey     = @"fetchInterval";
static NSString *kInitialFetchCountKey = @"initialFetchCount";
static NSString *kMoreFetchCountKey    = @"moreFetchCount";


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

@end
