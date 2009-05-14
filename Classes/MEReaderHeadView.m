/*
 *  MEReaderHeadView.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEReaderHeadView.h"
#import "MEImageView.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"


#define kReaderHeadViewHeight 70
#define kFaceImageViewWidth   50
#define kFaceImageViewHeight  50
#define kNickButtonWidth      152
#define kNickButtonHeight     45
#define kPostButtonWidth      90
#define kPostButtonHeight     35


@implementation MEReaderHeadView


- (id)initWithFrame:(CGRect)aFrame
{
    CGRect sFrame;

    self = [super initWithFrame:aFrame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];

        {
            mFaceImageView = [[MEImageView alloc] initWithFrame:CGRectMake(7, 10, kFaceImageViewWidth, kFaceImageViewHeight)];
            [mFaceImageView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1.0]];

            [self addSubview:mFaceImageView];
            [mFaceImageView release];
        }

        {
            sFrame.size.width  = kNickButtonWidth;
            sFrame.size.height = kNickButtonHeight;
            sFrame.origin.x    = 65;
            sFrame.origin.y    = (int)((aFrame.size.height - sFrame.size.height) / 2);
            mUserDescLabel = [[UILabel alloc] initWithFrame:sFrame];
            [mUserDescLabel setFont:[UIFont systemFontOfSize:14]];
            [mUserDescLabel setNumberOfLines:2];
            [self addSubview:mUserDescLabel];
            [mUserDescLabel release];
        }

        {
            mNewPostButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [mNewPostButton setTitle:NSLocalizedString(@"New Post", nil) forState:UIControlStateNormal];
            [mNewPostButton addTarget:self action:@selector(newPostButtonTapped) forControlEvents:UIControlEventTouchUpInside];

            sFrame.size.width  = kPostButtonWidth;
            sFrame.size.height = kPostButtonHeight;
            sFrame.origin.x    = 225;
            sFrame.origin.y    = (int)((aFrame.size.height - sFrame.size.height ) / 2);
            [mNewPostButton setFrame:sFrame];

            [self addSubview:mNewPostButton];
        }
    }

    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark Class Method


+ (MEReaderHeadView *)readerHeadView
{
    return [[[MEReaderHeadView alloc] initWithFrame:CGRectMake(0, 0, 320, kReaderHeadViewHeight)] autorelease];
}


#pragma mark -
#pragma mark Instance Method


- (void)setDelegate:(id)aDelegate
{
    mDelegate = aDelegate;
}


- (void)setUserID:(NSString *)aUserID
{
    [mFaceImageView setImageWithURL:nil];
    [mUserDescLabel setText:nil];

    [[MEClientStore currentClient] getPersonWithUserID:aUserID delegate:self];
}


#pragma mark -
#pragma mark Actions


- (void)newPostButtonTapped
{
    if ([mDelegate respondsToSelector:@selector(newPostButtonTapped:)])
    {
        [mDelegate newPostButtonTapped:self];
    }
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    if (aUser)
    {
        [mFaceImageView setImageWithURL:[aUser faceImageURL]];
        [mUserDescLabel setText:[aUser userDescription]];
    }
}


@end
