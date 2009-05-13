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


- (void)initSelf
{
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
    [mNormalImage release];
    [mHighlightedImage release];
    [super dealloc];
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
            [mImageView setImage:aImage];
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
            [mImageView setImage:aImage];
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

    if (mHighlighted && mHighlightedImage)
    {
        [mImageView setImage:mHighlightedImage];
    }
    else
    {
        [mImageView setImage:mNormalImage];
    }
}


@end
