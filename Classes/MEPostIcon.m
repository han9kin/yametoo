/*
 *  MEPostIcon.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 27.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSURL+MEAdditions.h"
#import "MEPostIcon.h"


@implementation MEPostIcon

@synthesize iconIndex       = mIconIndex;
@synthesize iconDescription = mIconDescription;
@synthesize iconURL         = mIconURL;


- (id)initWithDictionary:(NSDictionary *)aDict
{
    self = [super init];

    if (self)
    {
        mIconIndex       = [[aDict objectForKey:@"iconIndex"] integerValue];
        mIconDescription = [[aDict objectForKey:@"description"] retain];
        mIconURL         = [[NSURL alloc] initWithStringOrNil:[aDict objectForKey:@"url"]];
    }

    return self;
}

- (void)dealloc
{
    [mIconDescription release];
    [mIconURL release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p index=%d description=%@ url=%@>", NSStringFromClass([self class]), self, mIconIndex, mIconDescription, mIconURL];
}

@end
