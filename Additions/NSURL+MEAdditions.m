/*
 *  NSURL+MEAdditions.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 15.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "NSURL+MEAdditions.h"


@implementation NSURL (MEAdditions)

+ (NSURL *)URLWithUnescapedString:(NSString *)aString
{
    return [NSURL URLWithString:[aString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (id)URLWithStringOrNil:(NSString *)aURLString
{
    if ([aURLString length])
    {
        return [self URLWithString:aURLString];
    }
    else
    {
        return nil;
    }
}

- (id)initWithStringOrNil:(NSString *)aURLString
{
    if ([aURLString length])
    {
        return [self initWithString:aURLString];
    }
    else
    {
        [self release];
        return nil;
    }
}

@end
