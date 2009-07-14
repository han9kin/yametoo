/*
 *  NSError+MEAdditions.m
 *  me2DAY
 *
 *  Created by han9kin on 09. 07. 02.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "NSError+MEAdditions.h"
#import "MEClient.h"


@implementation NSError (MEAdditions)


- (NSString *)localizedDescriptionMe2DAY
{
    if ([[self domain] isEqualToString:NSURLErrorDomain])
    {
        switch ([self code])
        {
            case NSURLErrorTimedOut:
                return NSLocalizedString(@"network timed out", @"");

            case NSURLErrorCannotFindHost:
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorDNSLookupFailed:
                return NSLocalizedString(@"cannot connect to server", @"");

            case NSURLErrorNetworkConnectionLost:
                return NSLocalizedString(@"network connection failed", @"");

            case NSURLErrorNotConnectedToInternet:
                return NSLocalizedString(@"no internet connection", @"");

            default:
                return [self localizedDescription];
        }
    }
    else if ([[self domain] isEqualToString:MEClientErrorDomain])
    {
        return [self localizedFailureReason];
    }
    else
    {
        return [self localizedDescription];
    }
}


@end
