/*
 *  MECommentTableViewCell.m
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 09.
 *  Copyright 2009 NHN. All rights reserved.
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
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    mFaceImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(9, 9, kIconImageSize + 2, kIconImageSize + 2)];
    [mFaceImageButton setBorderColor:[UIColor lightGrayColor]];
    [mFaceImageButton addTarget:aTarget action:@selector(faceImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self contentView] addSubview:mFaceImageButton];
    [mFaceImageButton release];

    mBodyLabel = [[MEAttributedLabel alloc] initWithFrame:CGRectZero];
    [mBodyLabel setBackgroundColor:[UIColor clearColor]];
    [[self contentView] addSubview:mBodyLabel];
    [mBodyLabel release];

    mAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 41, kIconImageSize + 2, 14)];
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
        sCell = [[[self alloc] initWithFrame:CGRectZero reuseIdentifier:@"Comment"] autorelease];

        [sCell setupWithTarget:aTarget];
    }

    return sCell;
}


- (void)setComment:(MEComment *)aComment
{
    CGRect  sBodyFrame;
    CGFloat sCellHeight;

    [mFaceImageButton setImageWithURL:[[aComment author] faceImageURL]];
    [mFaceImageButton setUserInfo:[aComment author]];

    [mBodyLabel setFrame:CGRectMake(70, 10, kCommentBodyWidth, 0)];
    [mBodyLabel setAttributedText:[aComment body]];
    [mBodyLabel sizeToFit];

    sBodyFrame  = [mBodyLabel frame];
    sBodyFrame.size.height += 14;

    sCellHeight = 10;
    sCellHeight += (sBodyFrame.size.height > kIconImageSize) ? sBodyFrame.size.height : kIconImageSize;
    sCellHeight += 10;

    [mDateLabel setFrame:CGRectMake(sBodyFrame.origin.x + 40, sCellHeight - 20, 200, 14)];
    [mDateLabel setText:[[aComment pubDate] localizedDateTimeString]];
    [mAuthorLabel setText:[[aComment author] nickname]];
}


@end
