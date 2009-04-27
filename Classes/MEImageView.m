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
    [mURL   release];
    [mImage release];

    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setImageWithURL:(NSURL *)aURL
{
    if (mURL != aURL)
    {
        [mImage release];
        mImage = nil;

        [mURL release];
        mURL = [aURL retain];

        if (mURL)
        {
            [[MEClientStore anyClient] loadImageWithURL:mURL key:mURL delegate:self];
        }

        [self setNeedsDisplay];
    }
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didLoadImage:(UIImage *)aImage key:(id)aKey error:(NSError *)aError
{
    if ([mURL isEqual:aKey])
    {
        if (mImage != aImage)
        {
            [mImage release];
            mImage = [aImage retain];

            [self setNeedsDisplay];
        }
    }
}


@end
