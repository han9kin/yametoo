/*
 *  MEReachability.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 15.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface MEReachability : NSObject
{

}

+ (BOOL)isInternetAvailable;
+ (BOOL)isInternetAvailableViaCarrierDataNetwork;
+ (BOOL)isInternetAvailableViaWiFiNetwork;

@end
