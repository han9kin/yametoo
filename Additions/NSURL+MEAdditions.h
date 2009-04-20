/*
 *  NSURL+MEAdditions.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface NSURL (MEAdditions)

+ (NSURL *)URLWithUnescapedString:(NSString *)aString;

+ (id)URLWithStringOrNil:(NSString *)aURLString;
- (id)initWithStringOrNil:(NSString *)aURLString;

@end
