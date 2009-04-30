/*
 *  METableViewCellFactory.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "METableViewCellFactory.h"
#import "ObjCUtil.h"
#import "MEImageView.h"
#import "MEPostBodyView.h"
#import "MEAttributedLabel.h"


@implementation METableViewCellFactory


SYNTHESIZE_SINGLETON_CLASS(METableViewCellFactory, sharedFactory);


- (id)init
{
    self = [super init];
    if (self)
    {

    }

    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark - Class Methods


+ (UITableViewCell *)loginUserCellForTableView:(UITableView *)aTableView;
{
    UITableViewCell *sResult;
    MEImageView     *sFaceImageView;
    UIView          *sFrameView;
    UILabel         *sUserIDLabel;

    sResult = [aTableView dequeueReusableCellWithIdentifier:kTableLoginUserCellIdentifier];
    if (!sResult)
    {
        sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kTablePostCellIdentifier] autorelease];

        sFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(29, 9, 52, 52)];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        [sFrameView setTag:kLoginUserCellFrameViewTag];
        [[sResult contentView] addSubview:sFrameView];
        [sFrameView release];

        sFaceImageView = [[MEImageView alloc] initWithFrame:CGRectMake(30, 10, 50, 50)];
        [sFaceImageView setTag:kLoginUserCellFaceImageViewTag];
        [[sResult contentView] addSubview:sFaceImageView];
        [sFaceImageView release];

        sUserIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 180, 30)];
        [sUserIDLabel setTag:kLoginUserCellUserIDLabelTag];
        [sUserIDLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [sUserIDLabel setTextColor:[UIColor blackColor]];
        [sUserIDLabel setHighlightedTextColor:[UIColor whiteColor]];
        [[sResult contentView] addSubview:sUserIDLabel];
        [sUserIDLabel release];
    }

    return sResult;
}


+ (UITableViewCell *)addNewUserCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sResult;

    sResult = [aTableView dequeueReusableCellWithIdentifier:kTableAddNewUserCellIdentifier];
    if (!sResult)
    {
        sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kTableAddNewUserCellIdentifier] autorelease];
    }

    return sResult;
}


+ (UITableViewCell *)postCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sResult;
    UIView          *sFrameView;
    MEImageView     *sImageView;
    MEPostBodyView  *sBodyView;

    sResult = [aTableView dequeueReusableCellWithIdentifier:kTablePostCellIdentifier];

    if (!sResult)
    {
        sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kTablePostCellIdentifier] autorelease];

        sFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding - 1, 46, 46)];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        [[sResult contentView] addSubview:sFrameView];
        [sFrameView release];

        sImageView = [[MEImageView alloc] initWithFrame:CGRectMake(8, kPostCellBodyPadding, 44, 44)];
        [sImageView setTag:kPostCellIconImageViewTag];
        [[sResult contentView] addSubview:sImageView];
        [sImageView release];

        sBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding, 250, 0)];
        [sBodyView setTag:kPostCellBodyViewTag];
        [[sResult contentView] addSubview:sBodyView];
        [sBodyView release];
    }

    return sResult;
}


+ (UITableViewCell *)postCellWithAuthorForTableView:(UITableView *)aTableView
{
    UITableViewCell *sResult;
    UIView          *sFrameView;
    UILabel         *sLabel;
    MEImageView     *sImageView;
    MEPostBodyView  *sBodyView;

    sResult = [aTableView dequeueReusableCellWithIdentifier:kTablePostCellIdentifier];

    if (!sResult)
    {
        sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kTablePostCellIdentifier] autorelease];

        sFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding - 1, 46, 46)];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        [[sResult contentView] addSubview:sFrameView];
        [sFrameView release];

        sImageView = [[MEImageView alloc] initWithFrame:CGRectMake(8, kPostCellBodyPadding, 44, 44)];
        [sImageView setTag:kPostCellFaceImageViewTag];
        [[sResult contentView] addSubview:sImageView];
        [sImageView release];

        sFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding + 49, 46, 46)];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        [[sResult contentView] addSubview:sFrameView];
        [sFrameView release];

        sImageView = [[MEImageView alloc] initWithFrame:CGRectMake(8, kPostCellBodyPadding + 50, 44, 44)];
        [sImageView setTag:kPostCellIconImageViewTag];
        [[sResult contentView] addSubview:sImageView];
        [sImageView release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding, 250, 15)];
        [sLabel setTag:kPostCellAuthorNameLabelTag];
        [sLabel setFont:[UIFont systemFontOfSize:12.0]];
        [sLabel setTextColor:[UIColor darkGrayColor]];
        [sLabel setHighlightedTextColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        [[sResult contentView] addSubview:sLabel];
        [sLabel release];

        sBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding + 20, 250, 0)];
        [sBodyView setTag:kPostCellBodyViewTag];
        [[sResult contentView] addSubview:sBodyView];
        [sBodyView release];
    }

    return sResult;
}


+ (UITableViewCell *)commentCellForTableView:(UITableView *)aTableView
{
    UITableViewCell   *sResult = nil;
    UIView            *sFrameView;
    MEImageView       *sImageView;
    MEAttributedLabel *sBodyLabel;

    sResult = [aTableView dequeueReusableCellWithIdentifier:kTableCommentCellIdentifier];
    if (!sResult)
    {
        sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kTableCommentCellIdentifier] autorelease];

        sBodyLabel = [[MEAttributedLabel alloc] initWithFrame:CGRectZero];
        [sBodyLabel setTag:kCommentCellBodyLabelTag];
        [[sResult contentView] addSubview:sBodyLabel];
        [sBodyLabel release];

        sFrameView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [sFrameView setTag:kCommentCellFrameViewTag];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        [[sResult contentView] addSubview:sFrameView];
        [sFrameView release];

        sImageView = [[MEImageView alloc] initWithFrame:CGRectZero];
        [sImageView setTag:kCommentCellFaceImageViewTag];
        [[sResult contentView] addSubview:sImageView];
        [sImageView release];
    }

    return sResult;
}


@end
