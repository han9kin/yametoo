/*
 *  MESettings.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 06.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface MESettings : NSObject
{

}

+ (NSInteger)initialFetchCount;
+ (void)setInitialFetchCount:(NSInteger)aCount;

+ (NSInteger)moreFetchCount;
+ (void)setMoreFetchCount:(NSInteger)aCount;

@end
