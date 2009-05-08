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


#pragma mark -
#pragma mark properties


@synthesize borderColor = mBorderColor;
@synthesize delegate    = mDelegate;


#pragma mark -


- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];

    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }

    return self;
}


- (void)drawRect:(CGRect)aRect
{
    CGRect sRect = [self bounds];

    if (mBorderColor)
    {
        [mBorderColor set];
        UIRectFrame(sRect);

        sRect.origin.x    += 1;
        sRect.origin.y    += 1;
        sRect.size.width  -= 2;
        sRect.size.height -= 2;
    }

    [mImage drawInRect:sRect];
}


- (void)dealloc
{
    [mURL release];
    [mImage release];
    [mBorderColor release];

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
        if (aError)
        {
            NSLog(@"MEImageView image load error: %@ for url: %@", aError, aKey);
        }
        else
        {
            if (mImage != aImage)
            {
                [mImage release];
                mImage = [aImage retain];

                [mDelegate imageView:self didLoadImage:mImage];

                [self setNeedsDisplay];
            }
        }
    }
}


@end
