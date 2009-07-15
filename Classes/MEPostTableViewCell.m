/*
 *  MEPostTableViewCell.m
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 09.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MEPostTableViewCell.h"
#import "MEImageButton.h"
#import "MEPostBodyView.h"
#import "MEPost.h"
#import "MEUser.h"


@implementation MEPostTableViewCell


- (void)setupWithoutAuthorAndTarget:(id)aTarget
{
    mPostImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, kPostCellBodyTopPadding, kIconImageSize + 2, kIconImageSize + 2)];
    [mPostImageButton setBorderColor:[UIColor lightGrayColor]];
    [mPostImageButton addTarget:aTarget action:@selector(iconImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self contentView] addSubview:mPostImageButton];
    [mPostImageButton release];

    mBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyTopPadding, [self bounds].size.width - kPostCellBodyLeftPadding, 0)];
    [mBodyView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [mBodyView setBackgroundColor:[UIColor whiteColor]];
    [[self contentView] addSubview:mBodyView];
    [mBodyView release];
}

- (void)setupWithAuthorAndTarget:(id)aTarget
{
    mFaceImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, kPostCellBodyTopPadding, kIconImageSize + 2, kIconImageSize + 2)];
    [mFaceImageButton setBorderColor:[UIColor lightGrayColor]];
    [mFaceImageButton addTarget:aTarget action:@selector(faceImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self contentView] addSubview:mFaceImageButton];
    [mFaceImageButton release];

    mPostImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, kPostCellBodyTopPadding + 50, kIconImageSize + 2, kIconImageSize + 2)];
    [mPostImageButton setBorderColor:[UIColor lightGrayColor]];
    [mPostImageButton addTarget:aTarget action:@selector(iconImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self contentView] addSubview:mPostImageButton];
    [mPostImageButton release];

    mAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, kPostCellBodyTopPadding + 32, kIconImageSize + 2, 14)];
    [mAuthorLabel setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.7]];
    [mAuthorLabel setFont:[UIFont systemFontOfSize:9]];
    [mAuthorLabel setTextColor:[UIColor whiteColor]];
    [mAuthorLabel setTextAlignment:UITextAlignmentCenter];
    [[self contentView] addSubview:mAuthorLabel];
    [mAuthorLabel release];

    mBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyTopPadding, [self bounds].size.width - kPostCellBodyLeftPadding, 0)];
    [mBodyView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [mBodyView setBackgroundColor:[UIColor whiteColor]];
    [[self contentView] addSubview:mBodyView];
    [mBodyView release];
}


+ (MEPostTableViewCell *)cellForTableView:(UITableView *)aTableView withTarget:(id)aTarget
{
    MEPostTableViewCell *sCell;

    sCell = (MEPostTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"Post"];

    if (!sCell)
    {
        sCell = [[[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Post"] autorelease];

        [sCell setupWithoutAuthorAndTarget:aTarget];
    }

    return sCell;
}


+ (MEPostTableViewCell *)cellWithAuthorForTableView:(UITableView *)aTableView withTarget:(id)aTarget
{
    MEPostTableViewCell *sCell;

    sCell = (MEPostTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"PostWithAuthor"];

    if (!sCell)
    {
        sCell = [[[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostWithAuthor"] autorelease];

        [sCell setupWithAuthorAndTarget:aTarget];
    }

    return sCell;
}


- (void)layoutSubviews
{
    if (mFaceImageButton)
    {
        CGRect sRect = [self bounds];

        if (sRect.size.width > 400)
        {
            [mPostImageButton setFrame:CGRectMake(7 + kPostCellIconPadding, kPostCellBodyTopPadding, kIconImageSize + 2, kIconImageSize + 2)];
            [mBodyView setFrame:CGRectMake(60 + kPostCellIconPadding, kPostCellBodyTopPadding, sRect.size.width - kPostCellBodyLeftPadding - kPostCellIconPadding, 0)];
        }
        else
        {
            [mPostImageButton setFrame:CGRectMake(7, kPostCellBodyTopPadding + kPostCellIconPadding, kIconImageSize + 2, kIconImageSize + 2)];
            [mBodyView setFrame:CGRectMake(60, kPostCellBodyTopPadding, sRect.size.width - kPostCellBodyLeftPadding, 0)];
        }
    }

    [super layoutSubviews];
}


- (void)setPost:(MEPost *)aPost
{
    [mAuthorLabel setText:[[aPost author] nickname]];

    [mFaceImageButton setUserInfo:[aPost author]];
    [mFaceImageButton setImageWithURL:[[aPost author] faceImageURL]];

    [mPostImageButton setUserInfo:aPost];
    [mPostImageButton setImageWithURL:[aPost iconURL]];

    [mBodyView setPost:aPost];
}


@end
