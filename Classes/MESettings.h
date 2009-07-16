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

+ (NSArray *)bookmarks;
+ (void)setBookmarks:(NSArray *)aBookmarks;

+ (NSString *)shortDescriptionForFetchInterval:(NSInteger)aValue;
+ (NSString *)longDescriptionForFetchInterval:(NSInteger)aValue;
+ (NSString *)descriptionForFetchCount:(NSInteger)aValue;

+ (NSInteger)fetchInterval;
+ (void)setFetchInterval:(NSInteger)aInterval;

+ (BOOL)couldImplicitFetch;

+ (NSInteger)initialFetchCount;
+ (void)setInitialFetchCount:(NSInteger)aCount;

+ (NSInteger)moreFetchCount;
+ (void)setMoreFetchCount:(NSInteger)aCount;

@end
