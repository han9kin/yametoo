/*
 *  MELink.m
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 04.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MELink.h"


@implementation MELink

@synthesize title     = mTitle;
@synthesize URLString = mURLString;
@dynamic    url;


- (void)dealloc
{
    [mTitle release];
    [mURLString release];
    [mDescription release];
    [super dealloc];
}


- (NSString *)urlDescription
{
    if (!mDescription)
    {
        mDescription = [mURLString retain];
    }

    return mDescription;
}


- (NSURL *)url
{
    return [NSURL URLWithString:mURLString];
}


- (void)appendTitle:(NSString *)aTitle
{
    [mTitle autorelease];
    mTitle = [[mTitle stringByAppendingString:aTitle] retain];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ => %@", mTitle, mURLString];
}


@end
