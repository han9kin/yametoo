/*
 *  MEImageButton.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 08.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEImageButton.h"
#import "MEClientStore.h"
#import "MEClient.h"


@implementation MEImageButton


#pragma mark -
#pragma mark properties


@synthesize borderColor = mBorderColor;
@synthesize userInfo    = mUserInfo;


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
    [mUserInfo release];

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
            NSLog(@"MEImageButton image load error: %@ for url: %@", aError, aKey);
        }
        else
        {
            if (mImage != aImage)
            {
                [mImage release];
                mImage = [aImage retain];

                [self setNeedsDisplay];
            }
        }
    }
}


@end
