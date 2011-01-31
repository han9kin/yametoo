/*
 *  MECommentTableViewCell.m
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 09.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "NSDate+MEAdditions.h"
#import "MECommentTableViewCell.h"
#import "MEImageButton.h"
#import "MEAttributedLabel.h"
#import "MEComment.h"
#import "MEUser.h"


@implementation MECommentTableViewCell


- (void)setupWithTarget:(id)aTarget
{
    mFaceImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, 7, kIconImageSize + 2, kIconImageSize + 2)];
    [mFaceImageButton setBorderColor:[UIColor lightGrayColor]];
    [mFaceImageButton addTarget:aTarget action:@selector(faceImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self contentView] addSubview:mFaceImageButton];
    [mFaceImageButton release];

    mBodyLabel = [[MEAttributedLabel alloc] initWithFrame:CGRectMake(60, 7, [[self contentView] bounds].size.width - kCommentBodyLeftPadding, 0)];
    [mBodyLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [mBodyLabel setBackgroundColor:[UIColor clearColor]];
    [[self contentView] addSubview:mBodyLabel];
    [mBodyLabel release];

    mAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 7 + 32, kIconImageSize + 2, 14)];
    [mAuthorLabel setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.7]];
    [mAuthorLabel setFont:[UIFont systemFontOfSize:9]];
    [mAuthorLabel setTextColor:[UIColor whiteColor]];
    [mAuthorLabel setTextAlignment:UITextAlignmentCenter];
    [[self contentView] addSubview:mAuthorLabel];
    [mAuthorLabel release];

    mDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [mDateLabel setFont:[UIFont systemFontOfSize:10]];
    [mDateLabel setTextAlignment:UITextAlignmentRight];
    [mDateLabel setTextColor:[UIColor colorWithWhite:0.6 alpha:1.0]];
    [mDateLabel setBackgroundColor:[UIColor clearColor]];
    [[self contentView] addSubview:mDateLabel];
    [mDateLabel release];
}


+ (MECommentTableViewCell *)cellForTableView:(UITableView *)aTableView withTarget:(id)aTarget
{
    MECommentTableViewCell *sCell;

    sCell = (MECommentTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"Comment"];

    if (!sCell)
    {
        sCell = [[[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Comment"] autorelease];

        [sCell setupWithTarget:aTarget];
    }

    return sCell;
}


- (void)layoutSubviews
{
    CGFloat sWidth;
    CGFloat sHeight;

    sWidth = [[self contentView] bounds].size.width;

    [mBodyLabel setFrame:CGRectMake(60, 7, sWidth - kCommentBodyLeftPadding, 0)];
    [mBodyLabel sizeToFit];

    sHeight = [mBodyLabel frame].size.height + 14;
    sHeight = ((sHeight > kIconImageSize) ? sHeight : kIconImageSize);

    [mDateLabel setFrame:CGRectMake(60, sHeight - 4, sWidth - kCommentBodyLeftPadding, 14)];

    [super layoutSubviews];
}


- (void)setComment:(MEComment *)aComment
{
    [mFaceImageButton setImageWithURL:[[aComment author] faceImageURL]];
    [mFaceImageButton setUserInfo:[aComment author]];

    [mBodyLabel setAttributedText:[aComment body]];
    [mDateLabel setText:[[aComment pubDate] localizedDateTimeString]];
    [mAuthorLabel setText:[[aComment author] nickname]];
}


@end
