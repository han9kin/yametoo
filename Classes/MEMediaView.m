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
#import "EXF.h"


@implementation MEMediaView


#pragma mark -
#pragma mark properties


@dynamic photoURL;


#pragma mark -
#pragma mark alloc / init


- (void)initializeVariables
{
    UIButton *sButton;

    [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];

    mImageRect = CGRectMake(20, 80, 280, 280);

    mIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [mIndicator setCenter:CGPointMake(160, 240)];
    [mIndicator setHidden:YES];
    [self addSubview:mIndicator];
    [mIndicator release];

    mFrameView = [[UIView alloc] initWithFrame:CGRectZero];
    [mFrameView setBackgroundColor:[UIColor grayColor]];
    [self addSubview:mFrameView];
    [mFrameView release];

    mImageView = [[MEImageView alloc] initWithFrame:CGRectZero];
    [mImageView setDelegate:self];
    [self addSubview:mImageView];
    [mImageView release];

    sButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sButton setFrame:CGRectMake(230, 380, 70, 30)];
    [sButton setTitle:NSLocalizedString(@"Close", nil) forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:sButton];
}


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        [self initializeVariables];
    }

    return self;
}


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        [self initializeVariables];
    }

    return self;
}


- (void)dealloc
{
    [mPhotoURL release];
    [super dealloc];
}


#pragma mark -


- (void)drawRect:(CGRect)aRect
{
    [[UIColor whiteColor] set];
    MERoundRectFill(CGRectMake(6, 66, 308, 358), 5);

    [[UIColor blackColor] set];
    MERoundRectStroke(CGRectMake(5, 65, 310, 360), 5);
}


#pragma mark -
#pragma mark Instance Methods


- (void)setPhotoURL:(NSURL *)aPhotoURL
{
    [mPhotoURL autorelease];
    mPhotoURL = [aPhotoURL retain];

    [mIndicator setHidden:NO];
    [mIndicator startAnimating];

    [mImageView setImageWithURL:mPhotoURL];
}


#pragma mark -
#pragma mark Actions


- (IBAction)closeButtonTapped:(id)aSender
{
    [mFrameView setFrame:CGRectZero];
    [mImageView setFrame:CGRectZero];
    [mImageView setImageWithURL:nil];

    [self removeFromSuperview];
}


#pragma mark -
#pragma mark MEImageViewDelegate


- (void)imageView:(MEImageView *)aImageView imageDidLoad:(UIImage *)aImage
{
    CGSize sSize = [aImage size];
    CGRect sImageRect;
    CGRect sFrameRect;

    [mIndicator stopAnimating];
    [mIndicator setHidden:YES];

    if (sSize.width > sSize.height)
    {
        sImageRect.size.width  = mImageRect.size.width;
        sImageRect.size.height = sImageRect.size.width * sSize.height / sSize.width;
        sImageRect.origin.x    = mImageRect.origin.x;
        sImageRect.origin.y    = mImageRect.origin.y + (mImageRect.size.height - sImageRect.size.height) / 2;
    }
    else if (sSize.width < sSize.height)
    {
        sImageRect.size.height = mImageRect.size.height;
        sImageRect.size.width  = sImageRect.size.height * sSize.width / sSize.height;
        sImageRect.origin.x    = mImageRect.origin.x + (mImageRect.size.width - sImageRect.size.width) / 2;
        sImageRect.origin.y    = mImageRect.origin.y;
    }
    else
    {
        sImageRect = mImageRect;
    }

    sFrameRect = sImageRect;
    sFrameRect.origin.x    -= 1;
    sFrameRect.origin.y    -= 1;
    sFrameRect.size.width  += 2;
    sFrameRect.size.height += 2;

    [mFrameView setFrame:sFrameRect];
    [mImageView setFrame:sImageRect];
}


@end
