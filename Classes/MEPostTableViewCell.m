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
    mPostImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding - 1, kIconImageSize + 2, kIconImageSize + 2)];
    [mPostImageButton setBorderColor:[UIColor lightGrayColor]];
    [mPostImageButton addTarget:aTarget action:@selector(iconImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self contentView] addSubview:mPostImageButton];
    [mPostImageButton release];

    mBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding, 0, 0)];
    [mBodyView setBackgroundColor:[UIColor whiteColor]];
    [[self contentView] addSubview:mBodyView];
    [mBodyView release];
}

- (void)setupWithAuthorAndTarget:(id)aTarget
{
    mFaceImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding - 1, kIconImageSize + 2, kIconImageSize + 2)];
    [mFaceImageButton setBorderColor:[UIColor lightGrayColor]];
    [mFaceImageButton addTarget:aTarget action:@selector(faceImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self contentView] addSubview:mFaceImageButton];
    [mFaceImageButton release];

    mPostImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding + 49, kIconImageSize + 2, kIconImageSize + 2)];
    [mPostImageButton setBorderColor:[UIColor lightGrayColor]];
    [mPostImageButton addTarget:aTarget action:@selector(iconImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self contentView] addSubview:mPostImageButton];
    [mPostImageButton release];

    mAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding, 250, 15)];
    [mAuthorLabel setBackgroundColor:[UIColor whiteColor]];
    [mAuthorLabel setFont:[UIFont systemFontOfSize:12.0]];
    [mAuthorLabel setTextColor:[UIColor darkGrayColor]];
    [mAuthorLabel setHighlightedTextColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [[self contentView] addSubview:mAuthorLabel];
    [mAuthorLabel release];

    mBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding + 20, 0, 0)];
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
        sCell = [[[self alloc] initWithFrame:CGRectZero reuseIdentifier:@"Post"] autorelease];

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
        sCell = [[[self alloc] initWithFrame:CGRectZero reuseIdentifier:@"PostWithAuthor"] autorelease];

        [sCell setupWithAuthorAndTarget:aTarget];
    }

    return sCell;
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
