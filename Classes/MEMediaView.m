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
#import "MERoundBackView.h"


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

    mImageRect = CGRectMake(15, 20, 280, 280);
    
    mBackView = [[MERoundBackView alloc] initWithFrame:CGRectMake(5, 65, 310, 360)];
    [mBackView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:mBackView];
    [mBackView release];

    mIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [mIndicator setCenter:CGPointMake(160, 240)];
    [mIndicator setHidesWhenStopped:YES];
    [self addSubview:mIndicator];
    [mIndicator release];

    mImageView = [[MEImageView alloc] initWithFrame:CGRectZero];
    [mImageView setBorderColor:[UIColor grayColor]];
    [mImageView setDelegate:self];
    [mBackView addSubview:mImageView];
    [mImageView release];

    sButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sButton setFrame:CGRectMake(220, 312, 70, 30)];
    [sButton setTitle:NSLocalizedString(@"Close", nil) forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [mBackView addSubview:sButton];
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

}


#pragma mark -
#pragma mark Instance Methods


- (void)imageViewShowAnimation
{
    CALayer *sLayer = [mBackView layer];
    
    CAKeyframeAnimation *sAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    [sAni setDelegate:self];
    [sAni setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [sAni setDuration:0.8];
    [sAni setValue:@"showAnimation" forKey:@"name"];
    
    NSMutableArray *sArray = [NSMutableArray array];
    [sArray addObject:[NSNumber numberWithFloat:0.0]];
    [sArray addObject:[NSNumber numberWithFloat:1.15]];
    [sArray addObject:[NSNumber numberWithFloat:1.07]];        
    [sArray addObject:[NSNumber numberWithFloat:1.0]];
    [sArray addObject:[NSNumber numberWithFloat:1.07]];
    [sArray addObject:[NSNumber numberWithFloat:1.03]];
    [sArray addObject:[NSNumber numberWithFloat:1.0]];
    sAni.values = sArray;
    
    [sLayer addAnimation:sAni forKey:@"showAni"];
}


- (void)imageViewHideAnimation
{
    CALayer *sLayer = [mBackView layer];
    CAKeyframeAnimation *sAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    [sAni setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [sAni setDelegate:self];
    [sAni setDuration:0.30];
    [sAni setValue:@"hideAnimation" forKey:@"name"];

    NSMutableArray *sArray = [NSMutableArray array];
    [sArray addObject:[NSNumber numberWithFloat:1.05]];
    [sArray addObject:[NSNumber numberWithFloat:1.06]];        
    [sArray addObject:[NSNumber numberWithFloat:1.07]];
    [sArray addObject:[NSNumber numberWithFloat:0.53]];    
    [sArray addObject:[NSNumber numberWithFloat:0.01]];
    [sAni setValues:sArray];
    
    [sLayer addAnimation:sAni forKey:@"hideAni"];
}


- (void)setPhotoURL:(NSURL *)aPhotoURL
{
    [mPhotoURL autorelease];
    mPhotoURL = [aPhotoURL retain];

    [mIndicator startAnimating];
    [mImageView setImageWithURL:mPhotoURL];
    
    [self imageViewShowAnimation];
}


- (void)animationDidStop:(CAAnimation *)aAnimation finished:(BOOL)aFlag
{
    NSString *sName = [aAnimation valueForKey:@"name"];
    
    if ([sName isEqualToString:@"showAnimation"])
    {
    }
    else if ([sName isEqualToString:@"hideAnimation"])
    {
        [self  removeFromSuperview];        
        [mImageView setFrame:CGRectZero];
        [mImageView setImageWithURL:nil];
    }
}


#pragma mark -
#pragma mark Actions


- (IBAction)closeButtonTapped:(id)aSender
{
    [self imageViewHideAnimation];
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
