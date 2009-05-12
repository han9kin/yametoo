/*
 *  NSDate+MEAdditions.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 12.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface NSDate (MEAdditions)

+ (NSDate *)dateFromISO8601:(NSString *)aDateString;

@end
