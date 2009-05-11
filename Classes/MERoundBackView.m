/*
 *  MEPostBackView.m
 *  yametoo
 *
 *  Created by cgkim on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MERoundBackView.h"
#import "MEDrawingFunctions.h"


@implementation MERoundBackView


#pragma mark -
#pragma mark properties


@synthesize fillColor = mFillColor;


#pragma mark -


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    
    if (self)
    {
        mFillColor = [[UIColor whiteColor] retain];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        mFillColor = [[UIColor whiteColor] retain];
    }

    return self;
}


- (void)dealloc
{
    [mFillColor release];
    
    [super dealloc];
}


#pragma mark -


- (void)drawRect:(CGRect)aRect
{
    CGRect sRect = [self bounds];
    CGRect sBoxRect = sRect;
    
    sBoxRect.origin.x    += 3.5;
    sBoxRect.origin.y    += 3.5;
    sBoxRect.size.width  -= 7;
    sBoxRect.size.height -= 6;
    
    [mFillColor set];
    MERoundRectFill(sBoxRect, 10.0);
    
    [[UIColor lightGrayColor] set];
    MERoundRectStroke(sBoxRect, 10.0);
}


#pragma mark -


@end
