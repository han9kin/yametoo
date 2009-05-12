/*
 *  NSDate+MEAdditions.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 12.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSDate+MEAdditions.h"


@implementation NSDate (MEAdditions)

+ (NSDate *)dateFromISO8601:(NSString *)aDateString
{
    static NSDateFormatter *sDateFormatterTZD  = nil;
    static NSDateFormatter *sDateFormatterGMT = nil;

    if (!sDateFormatterTZD)
    {
        sDateFormatterTZD = [[NSDateFormatter alloc] init];
        [sDateFormatterTZD setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    }

    if (!sDateFormatterGMT)
    {
        sDateFormatterGMT = [[NSDateFormatter alloc] init];
        [sDateFormatterGMT setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [sDateFormatterGMT setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }

    if ([aDateString hasSuffix:@"Z"])
    {
        return [sDateFormatterGMT dateFromString:aDateString];
    }
    else
    {
        return [sDateFormatterTZD dateFromString:aDateString];
    }
}

@end
