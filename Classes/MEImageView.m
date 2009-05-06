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


@synthesize delegate = mDelegate;
@synthesize userInfo = mUserInfo;


#pragma mark -


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        mUserInfo = [[NSMutableDictionary alloc] init];
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
    [mURL      release];
    [mImage    release];
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
            NSLog(@"MEImageView image load error: %@ for url: %@", aError, aKey);
        }
        else
        {
            if (mImage != aImage)
            {
                [mImage release];
                mImage = [aImage retain];

                [mDelegate imageView:self imageDidLoad:mImage];

                [self setNeedsDisplay];
            }
        }
    }
}


@end
