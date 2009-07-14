/*
 *  MEListHeadView.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEListHeadView.h"
#import "MEImageView.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"


#define kFaceImageViewWidth   44
#define kFaceImageViewHeight  44


@implementation MEListHeadView


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:0.58 green:0.64 blue:0.73 alpha:1.0]];

        mFaceImageView = [[MEImageView alloc] initWithFrame:CGRectMake(7, 7, kFaceImageViewWidth + 2, kFaceImageViewHeight + 2)];
        [mFaceImageView setBorderColor:[UIColor lightGrayColor]];
        [self addSubview:mFaceImageView];
        [mFaceImageView release];

        mUserIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, aFrame.size.width - 80, 20)];
        [mUserIDLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [mUserIDLabel setBackgroundColor:[UIColor clearColor]];
        [mUserIDLabel setTextColor:[UIColor whiteColor]];
        [mUserIDLabel setShadowColor:[UIColor darkGrayColor]];
        [mUserIDLabel setShadowOffset:CGSizeMake(0, 1)];
        [mUserIDLabel setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:14.0]];
        [self addSubview:mUserIDLabel];
        [mUserIDLabel release];

        mUserDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, aFrame.size.width - 80, 20)];
        [mUserDescLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [mUserDescLabel setBackgroundColor:[UIColor clearColor]];
        [mUserDescLabel setTextColor:[UIColor whiteColor]];
        [mUserDescLabel setShadowColor:[UIColor darkGrayColor]];
        [mUserDescLabel setShadowOffset:CGSizeMake(0, 1)];
        [mUserDescLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self addSubview:mUserDescLabel];
        [mUserDescLabel release];
    }

    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Method


- (void)setUser:(MEUser *)aUser
{
    [mFaceImageView setImageWithURL:[aUser faceImageURL]];
    [mUserIDLabel setText:[aUser userID]];
    [mUserDescLabel setText:[aUser userDescription]];
}


@end
