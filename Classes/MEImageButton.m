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


@dynamic    borderColor;
@synthesize userInfo = mUserInfo;


#pragma mark -


- (void)initSelf
{
    [self setClearsContextBeforeDrawing:NO];

    mImageView = [[UIImageView alloc] initWithImage:nil];
    [mImageView setFrame:[self bounds]];
    [self addSubview:mImageView];
    [mImageView release];
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        [self initSelf];
    }

    return self;
}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];

    if (self)
    {
        [self initSelf];
    }

    return self;
}

- (void)dealloc
{
    [mURL release];
    [mBorderColor release];
    [mUserInfo release];
    [super dealloc];
}


- (void)setFrame:(CGRect)aRect
{
    [super setFrame:aRect];

    CGRect sRect = [self bounds];

    if (mBorderColor)
    {
        sRect.origin.x    += 1;
        sRect.origin.y    += 1;
        sRect.size.width  -= 2;
        sRect.size.height -= 2;

        [mImageView setFrame:sRect];
    }
    else
    {
        [mImageView setFrame:sRect];
    }
}

- (void)setBackgroundColor:(UIColor *)aColor
{
    [super setBackgroundColor:aColor];
    [mImageView setBackgroundColor:aColor];
}

- (void)setContentMode:(UIViewContentMode)aContentMode
{
    [mImageView setContentMode:aContentMode];
}

- (void)drawRect:(CGRect)aRect
{
    CGRect sRect = [self bounds];

    [[UIColor whiteColor] set];
    UIRectFill(sRect);

    if (mBorderColor)
    {
        [mBorderColor set];
        UIRectFrame(sRect);
    }
}


- (UIColor *)borderColor
{
    return mBorderColor;
}

- (void)setBorderColor:(UIColor *)aColor
{
    if (mBorderColor != aColor)
    {
        CGRect sRect = [self bounds];

        [mBorderColor release];
        mBorderColor = [aColor retain];

        if (aColor)
        {
            sRect.origin.x    += 1;
            sRect.origin.y    += 1;
            sRect.size.width  -= 2;
            sRect.size.height -= 2;

            [mImageView setFrame:sRect];
        }
        else
        {
            [mImageView setFrame:sRect];
        }

        [self setNeedsDisplay];
    }
}


#pragma mark -
#pragma mark Instance Methods


- (void)setImageWithURL:(NSURL *)aURL
{
    if (mURL != aURL)
    {
        [mImageView setImage:nil];

        [mURL release];
        mURL = [aURL retain];

        if (mURL)
        {
            [[MEClientStore anyClient] loadImageWithURL:mURL key:mURL delegate:self];
        }
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
            [mImageView setImage:aImage];

            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}


@end
