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
    [mIndicator setHidesWhenStopped:YES];
    [self addSubview:mIndicator];
    [mIndicator release];

    mImageView = [[MEImageView alloc] initWithFrame:CGRectZero];
    [mImageView setBorderColor:[UIColor grayColor]];
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

    [mIndicator startAnimating];
    [mImageView setImageWithURL:mPhotoURL];
}


#pragma mark -
#pragma mark Actions


- (IBAction)closeButtonTapped:(id)aSender
{
    [mImageView setFrame:CGRectZero];
    [mImageView setImageWithURL:nil];

    [self removeFromSuperview];
}


#pragma mark -
#pragma mark MEImageViewDelegate


- (void)imageView:(MEImageView *)aImageView didLoadImage:(UIImage *)aImage
{
    CGSize sSize = [aImage size];
    CGRect sRect;

    if (sSize.width > sSize.height)
    {
        sRect.size.width  = mImageRect.size.width;
        sRect.size.height = sRect.size.width * sSize.height / sSize.width;
        sRect.origin.x    = mImageRect.origin.x;
        sRect.origin.y    = mImageRect.origin.y + (mImageRect.size.height - sRect.size.height) / 2;
    }
    else if (sSize.width < sSize.height)
    {
        sRect.size.height = mImageRect.size.height;
        sRect.size.width  = sRect.size.height * sSize.width / sSize.height;
        sRect.origin.x    = mImageRect.origin.x + (mImageRect.size.width - sRect.size.width) / 2;
        sRect.origin.y    = mImageRect.origin.y;
    }
    else
    {
        sRect = mImageRect;
    }

    sRect.origin.x    -= 1;
    sRect.origin.y    -= 1;
    sRect.size.width  += 2;
    sRect.size.height += 2;

    [mIndicator stopAnimating];
    [mImageView setFrame:sRect];
}


@end
