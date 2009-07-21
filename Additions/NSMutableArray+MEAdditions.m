/*
 *  NSMutableArray+MEAdditions.m
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 21.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "NSMutableArray+MEAdditions.h"


@implementation NSMutableArray (MEAdditions)

- (void)moveObjectAtIndex:(NSUInteger)aFromIndex toIndex:(NSUInteger)aToIndex
{
    if (aFromIndex != aToIndex)
    {
        id sObject = [self objectAtIndex:aFromIndex];

        if (aFromIndex < aToIndex)
        {
            aToIndex--;
        }

        [sObject retain];
        [self removeObjectAtIndex:aFromIndex];
        [self insertObject:sObject atIndex:aToIndex];
        [sObject release];
    }
}

@end
