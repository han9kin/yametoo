/*
 *  NSMutableData+MEAdditions.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 11.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSMutableData+MEAdditions.h"


@implementation NSMutableData (MEAdditions)

- (void)appendUTF8String:(NSString *)aString
{
    [self appendData:[aString dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
