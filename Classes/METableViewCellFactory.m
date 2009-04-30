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

        sFrameView = [[[UIImageView alloc] initWithFrame:CGRectMake(29, 9, 52, 52)] autorelease];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        [sFrameView setTag:kLoginUserCellFrameViewTag];

        sFaceImageView = [[[MEImageView alloc] initWithFrame:CGRectMake(30, 10, 50, 50)] autorelease];
        [sFaceImageView setTag:kLoginUserCellFaceImageViewTag];

        sUserIDLabel = [[[UILabel alloc] initWithFrame:CGRectMake(90, 20, 180, 30)] autorelease];
        [sUserIDLabel setTag:kLoginUserCellUserIDLabelTag];
        [sUserIDLabel setFont:[UIFont boldSystemFontOfSize:17.0]];

        [[sResult contentView] addSubview:sFrameView];
        [[sResult contentView] addSubview:sFaceImageView];
        [[sResult contentView] addSubview:sUserIDLabel];

//    [[sResult contentView] setBackgroundColor:[UIColor lightGrayColor]];
//    [sFaceImageView setBackgroundColor:[UIColor redColor]];
//    [sUserIDLabel setBackgroundColor:[UIColor lightGrayColor]];
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
        [sImageView setTag:kPostCellImageViewTag];
        [[sResult contentView] addSubview:sImageView];
        [sImageView release];

        sBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding, 250, 0)];
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
