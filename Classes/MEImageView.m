/*
 *  MEImageView.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 21.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEImageView.h"
#import "MEClientStore.h"
#import "MEClient.h"


@implementation MEImageView


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {

    }

    return self;
}


- (void)drawRect:(CGRect)aRect
{
    [[UIColor whiteColor] set];
    UIRectFill(aRect);
    [mImage drawInRect:[self bounds]];
}


- (void)dealloc
{
    [mImage release];
    [mKey   release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setImageWithURL:(NSURL *)aURL
{
    [mImage autorelease];
    mImage = nil;
    [self setNeedsDisplay];
    
    [mKey autorelease];
    mKey = [[aURL description] retain];
    
    MEClient *sClient = [MEClientStore currentClient];
    [sClient loadImageWithURL:aURL key:mKey shouldCache:YES delegate:self];
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didLoadImage:(UIImage *)aImage key:(NSString *)aKey error:(NSError *)aError
{
    if ([mKey isEqualToString:aKey])
    {
        [mImage autorelease];
        mImage = [aImage retain];
        
        [self setNeedsDisplay];
    }
}


@end
