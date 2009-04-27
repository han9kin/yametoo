/*
 *  MEMediaView.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 27.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEMediaView.h"
#import "MEDrawingFunctions.h"
#import "MEImageView.h"


@implementation MEMediaView


#pragma mark -
#pragma mark properties


@dynamic photoURL;


#pragma mark -
#pragma mark alloc / init


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
        
        mImageView = [[MEImageView alloc] initWithFrame:CGRectMake(20, 80, 280, 280)];
        [self addSubview:mImageView];
    }

    return self;
}


- (void)dealloc
{
    [mPhotoURL  release];
    [mImageView release];
    
    [super dealloc];
}


#pragma mark -


- (void)drawRect:(CGRect)aRect
{
    [[UIColor blackColor] set];
    MERoundRectFill(CGRectMake(5, 65, 310, 360), 5);
    
    [[UIColor whiteColor] set];
    MERoundRectFill(CGRectMake(6, 66, 308, 358), 5);
    
    [[UIColor grayColor] set];
    UIRectFrame(CGRectMake(19, 79, 282, 282));
}


- (void)touchesEnded:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    [self removeFromSuperview];
}


#pragma mark -


- (void)setPhotoURL:(NSURL *)aPhotoURL
{
    [mPhotoURL autorelease];
    mPhotoURL = [aPhotoURL retain];
    
    [mImageView setImageWithURL:mPhotoURL];
}


@end
