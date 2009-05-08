/*
 *  MEHighlightableImageView.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 08.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEHighlightableImageView.h"


@implementation MEHighlightableImageView

@dynamic normalImage;
@dynamic highlightedImage;
@dynamic highlighted;


- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];

    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }

    return self;
}

- (void)dealloc
{
    [mNormalImage release];
    [mHighlightedImage release];
    [super dealloc];
}


- (void)drawRect:(CGRect)aRect
{
    if (mHighlighted && mHighlightedImage)
    {
        [mHighlightedImage drawInRect:[self bounds]];
    }
    else
    {
        [mNormalImage drawInRect:[self bounds]];
    }
}


- (UIImage *)normalImage
{
    return mNormalImage;
}

- (void)setNormalImage:(UIImage *)aImage
{
    if (mNormalImage != aImage)
    {
        [mNormalImage release];
        mNormalImage = [aImage retain];

        if (!mHighlighted)
        {
            [self setNeedsDisplay];
        }
    }
}


- (UIImage *)highlightedImage
{
    return mHighlightedImage;
}

- (void)setHighlightedImage:(UIImage *)aImage
{
    if (mHighlightedImage != aImage)
    {
        [mHighlightedImage release];
        mHighlightedImage = [aImage retain];

        if (mHighlighted)
        {
            [self setNeedsDisplay];
        }
    }
}


- (BOOL)isHighlighted
{
    return mHighlighted;
}

- (void)setHighlighted:(BOOL)aHighlighted
{
    mHighlighted = aHighlighted;

    [self setNeedsDisplay];
}


@end
