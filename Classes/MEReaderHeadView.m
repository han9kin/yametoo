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
            [mNewPostButton addTarget:self action:@selector(newPostButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

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


- (void)drawRect:(CGRect)aRect
{

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


- (void)setUserDescription:(NSString *)aUserDescription
{
    [mUserDescLabel setText:aUserDescription];
}


- (void)setFaceImageURL:(NSURL *)aFaceImageURL
{
    [mFaceImageView setImageWithURL:aFaceImageURL];
}


#pragma mark -
#pragma mark Actions


- (IBAction)newPostButtonTapped:(id)aSender
{
    if ([mDelegate respondsToSelector:@selector(newPostButtonTapped:)])
    {
        [mDelegate newPostButtonTapped:self];
    }
}


@end
