/*
 *  NSURL+MEAdditions.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSURL+MEAdditions.h"


@implementation NSURL (MEAdditions)

+ (NSURL *)URLWithUnescapedString:(NSString *)aString
{
    return [NSURL URLWithString:[aString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
