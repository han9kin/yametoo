/*
 *  NSDate+MEAdditions.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 12.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSDate+MEAdditions.h"


#define kIntervalDay (60 * 60 * 24)


NSString *METodayDidChangeNotification = @"METodayDidChangeNotification";


static BOOL    gObservingNotification = NO;
static NSDate *gTodayMidnight         = nil;


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


+ (NSDate *)todayMidnight
{
    if (!gTodayMidnight)
    {
        NSCalendar       *sCalendar  = [NSCalendar currentCalendar];
        NSDateComponents *sDateComps = [sCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];

        gTodayMidnight = [[sCalendar dateFromComponents:sDateComps] retain];

        if (!gObservingNotification)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChange:) name:UIApplicationSignificantTimeChangeNotification object:nil];
            gObservingNotification = YES;
        }
    }

    return gTodayMidnight;
}

+ (void)significantTimeChange:(NSNotification *)aNotification
{
    [gTodayMidnight release];
    gTodayMidnight = nil;

    [[NSNotificationCenter defaultCenter] performSelector:@selector(postNotification:) withObject:[NSNotification notificationWithName:METodayDidChangeNotification object:nil] afterDelay:0];
}


- (NSString *)localizedDateString
{
    static NSDateFormatter *sFormatter = nil;

    if (!sFormatter)
    {
        sFormatter = [[NSDateFormatter alloc] init];
        [sFormatter setDateStyle:NSDateFormatterMediumStyle];
    }

    NSTimeInterval sInterval = [[NSDate todayMidnight] timeIntervalSinceDate:self];

    if (sInterval <= 0)
    {
        return NSLocalizedString(@"Today", @"");
    }
    else if (sInterval <= kIntervalDay)
    {
        return NSLocalizedString(@"Yesterday", @"");
    }
    else if (sInterval <= (kIntervalDay * 2))
    {
        return NSLocalizedString(@"2 Days Ago", @"");
    }
    else if (sInterval <= (kIntervalDay * 3))
    {
        return NSLocalizedString(@"3 Days Ago", @"");
    }
    else
    {
        return [sFormatter stringFromDate:self];
    }
}


- (NSString *)localizedTimeString
{
    static NSDateFormatter *sDateFormatter = nil;

    if (!sDateFormatter)
    {
        sDateFormatter = [[NSDateFormatter alloc] init];
        [sDateFormatter setLocale:[NSLocale currentLocale]];

        if ([[[NSLocale currentLocale] localeIdentifier] hasPrefix:@"ko"])
        {
            [sDateFormatter setDateFormat:NSLocalizedString(@"h':'mm a", @"")];
        }
        else
        {
            [sDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
    }

    return [sDateFormatter stringFromDate:self];
}


- (NSString *)localizedDateTimeString
{
    return [NSString stringWithFormat:@"%@ %@", [self localizedDateString], [self localizedTimeString]];
}


@end
