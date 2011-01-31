/*
 *  MEReachability.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 15.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>
#import "MEReachability.h"


typedef enum MEReachabilityStatus
{
    kNotReachable,
    kReachableViaCarrierDataNetwork,
    kReachableViaWiFiNetwork,
} MEReachabilityStatus;


@implementation MEReachability


+ (BOOL)isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags)aFlags
{
    BOOL sReachable;
    BOOL sWWAN;
    BOOL sConnectionRequired;

    sReachable = aFlags & kSCNetworkReachabilityFlagsReachable;
    sWWAN      = aFlags & kSCNetworkReachabilityFlagsIsWWAN;

    if (sWWAN)
    {
        sConnectionRequired = NO;
    }
    else
    {
        sConnectionRequired = aFlags & kSCNetworkReachabilityFlagsConnectionRequired;
    }

    return (sReachable && !sConnectionRequired) ? YES : NO;
}


+ (BOOL)getNetworkReachabilityFlags:(SCNetworkReachabilityFlags *)aFlags
{
    static SCNetworkReachabilityRef sDefaultRouteReachability = NULL;

    Boolean sRet;

    if (!sDefaultRouteReachability)
    {
        struct sockaddr_in sAddr;

        bzero(&sAddr, sizeof(sAddr));

        sAddr.sin_len    = sizeof(sAddr);
        sAddr.sin_family = AF_INET;

        sDefaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&sAddr);
    }

    sRet = SCNetworkReachabilityGetFlags(sDefaultRouteReachability, aFlags);

    if (sRet)
    {
        return [self isReachableWithoutRequiringConnection:*aFlags];
    }
    else
    {
        return NO;
    }
}


+ (MEReachabilityStatus)internetConnectionStatus
{
    SCNetworkReachabilityFlags sFlags;
    BOOL                       sReachable;

    sReachable = [self getNetworkReachabilityFlags:&sFlags];

    if (sReachable)
    {
        if (sFlags & kSCNetworkReachabilityFlagsIsDirect)
        {
            return kNotReachable;
        }
        else if (sFlags & kSCNetworkReachabilityFlagsIsWWAN)
        {
            return kReachableViaCarrierDataNetwork;
        }

        return kReachableViaWiFiNetwork;
    }

    return kNotReachable;
}


+ (BOOL)isInternetAvailable
{
    return ([self internetConnectionStatus] == kNotReachable) ? NO : YES;
}


+ (BOOL)isInternetAvailableViaCarrierDataNetwork
{
    return ([self internetConnectionStatus] == kReachableViaCarrierDataNetwork) ? YES : NO;
}


+ (BOOL)isInternetAvailableViaWiFiNetwork
{
    return ([self internetConnectionStatus] == kReachableViaWiFiNetwork) ? YES : NO;
}


@end
