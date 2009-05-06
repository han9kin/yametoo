/*
 *  MESettings.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 06.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MESettings.h"


static NSString *kInitialFetchCountKey = @"initialFetchCount";
static NSString *kMoreFetchCountKey    = @"moreFetchCount";


@implementation MESettings

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
