/*
 *  NSDate+MEAdditions.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 12.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


extern NSString *METodayDidChangeNotification;


@interface NSDate (MEAdditions)

+ (NSDate *)dateFromISO8601:(NSString *)aDateString;

- (NSString *)localizedDateString;
- (NSString *)localizedTimeString;
- (NSString *)localizedDateTimeString;

@end
