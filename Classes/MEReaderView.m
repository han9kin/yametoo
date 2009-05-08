/*
 *  MEReaderView.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEReaderView.h"
#import "METableViewCellFactory.h"
#import "MEReaderHeadView.h"
#import "MEImageView.h"
#import "MEPostBodyView.h"
#import "MEMediaView.h"
#import "MEPost.h"
#import "MEUser.h"
#import "MEAttributedLabel.h"
#import "MEAttributedString.h"


#define kPostBodyWidth  250
#define kTimeStrHeight  13.0


@implementation MEReaderView


#pragma mark -
#pragma mark properties


@synthesize dataSource = mDataSource;
@synthesize delegate   = mDelegate;


#pragma mark -


- (void)initializeVariables
{
    mCellHeightCache = [[NSMutableDictionary alloc] init];
}


- (void)initializeViews
{
    CGRect sBounds = [self bounds];

    mTableView = [[UITableView alloc] initWithFrame:sBounds style:UITableViewStylePlain];
    [mTableView setRowHeight:1000];
    [mTableView setDataSource:self];
    [mTableView setDelegate:self];
    [mTableView setCanCancelContentTouches:YES];

    [self addSubview:mTableView];
    [mTableView release];
}


#pragma mark -
#pragma mark init/dealloc


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        [self initializeVariables];
        [self initializeViews];
    }

    return self;
}


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        [self initializeVariables];
        [self initializeViews];
    }

    return self;
}


- (void)dealloc
{
    [mCellHeightCache release];
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setShowsPostAuthor:(BOOL)aFlag
{
    mShowsPostAuthor = aFlag;
}


- (NSIndexPath *)indexPathForSelectedPost
{
    return [mTableView indexPathForSelectedRow];
}


- (void)selectPostAtIndexPath:(NSIndexPath *)aIndexPath animated:(BOOL)aAnimated scrollPosition:(UITableViewScrollPosition)aScrollPosition
{
    [mTableView selectRowAtIndexPath:aIndexPath animated:aAnimated scrollPosition:aScrollPosition];
}


- (void)deselectPostAtIndexPath:(NSIndexPath *)aIndexPath animated:(BOOL)aAnimated
{
    [mTableView deselectRowAtIndexPath:aIndexPath animated:aAnimated];
}


- (void)reloadData
{
    if ([mDataSource respondsToSelector:@selector(authorOfPostsInReaderView:)])
    {
        MEReaderHeadView *sHeaderView;
        MEUser           *sUser;

        sUser = [mDataSource authorOfPostsInReaderView:self];

        if (sUser)
        {
            sHeaderView = (MEReaderHeadView *)[mTableView tableHeaderView];

            if (!sHeaderView)
            {
                sHeaderView = [MEReaderHeadView readerHeadView];

                [sHeaderView setDelegate:self];
                [mTableView setTableHeaderView:sHeaderView];
            }

            [sHeaderView setNickname:[sUser nickname]];
            [sHeaderView setFaceImageURL:[sUser faceImageURL]];
        }
        else
        {
            [mTableView setTableHeaderView:nil];
        }
    }

    if (mDataSource)
    {
        mSectionCount = [mDataSource numberOfSectionsInReaderView:self];
        [mCellHeightCache removeAllObjects];
        [mTableView reloadData];
    }
}


#pragma mark -
#pragma mark actions


- (void)faceImageViewTapped:(id)aSender
{
    if ([mDelegate respondsToSelector:@selector(readerView:didTapUserInfoButtonForUser:)])
    {
        MEImageView *sImageView = (MEImageView *)aSender;
        MEUser      *sAuthor    = [sImageView userInfo];

        [mDelegate readerView:self didTapUserInfoButtonForUser:sAuthor];
    }
}


- (void)iconImageViewTapped:(id)aSender
{
    if ([mDelegate respondsToSelector:@selector(readerView:didTapPostIconButtonForPost:)])
    {
        MEImageView *sImageView = (MEImageView *)aSender;
        MEPost      *sPost      = [sImageView userInfo];

        [mDelegate readerView:self didTapPostIconButtonForPost:sPost];
    }
}


#pragma mark -
#pragma mark TableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return mSectionCount + 1;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    if (aSection < mSectionCount)
    {
        return [mDataSource readerView:self titleForSection:aSection];
    }
    else
    {
        return nil;
    }
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    if (aSection < mSectionCount)
    {
        return [mDataSource readerView:self numberOfPostsInSection:aSection];
    }
    else
    {
        return mSectionCount ? 1 : 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sCell;

    if ([aIndexPath section] < mSectionCount)
    {
        MEPost *sPost = [mDataSource readerView:self postAtIndexPath:aIndexPath];

        if (mShowsPostAuthor)
        {
            sCell = [METableViewCellFactory postCellWithAuthorForTableView:aTableView];
        }
        else
        {
            sCell = [METableViewCellFactory postCellForTableView:aTableView];
        }

        [sCell setPost:sPost withTarget:self];
    }
    else
    {
        sCell = [METableViewCellFactory defaultCellForTableView:aTableView];

        [sCell setFont:[UIFont systemFontOfSize:15.0]];
        [sCell setTextAlignment:UITextAlignmentCenter];
        [sCell setText:NSLocalizedString(@"Fetch more...", @"")];
    }

    return sCell;
}


#pragma mark -
#pragma mark TableView Delegate


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    CGFloat   sHeight;

    if ([aIndexPath section] < mSectionCount)
    {
        MEPost   *sPost;
        NSNumber *sCachedHeight;

        sPost         = [mDataSource readerView:self postAtIndexPath:aIndexPath];
        sCachedHeight = [mCellHeightCache objectForKey:[sPost postID]];

        if (sCachedHeight)
        {
            sHeight = [sCachedHeight floatValue];
        }
        else
        {
            sHeight = [MEPostBodyView heightWithPost:sPost] + kPostCellBodyPadding * 2;

            if (mShowsPostAuthor)
            {
                sHeight += 20;
                sHeight  = (sHeight < 115) ? 115 : sHeight;
            }
            else
            {
                sHeight  = (sHeight < 70) ? 70 : sHeight;
            }

            [mCellHeightCache setObject:[NSNumber numberWithFloat:sHeight] forKey:[sPost postID]];
        }
    }
    else
    {
        sHeight = 70;
    }

    return sHeight;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    if ([aIndexPath section] < mSectionCount)
    {
        if ([mDelegate respondsToSelector:@selector(readerView:didSelectPostAtIndexPath:)])
        {
            [mDelegate readerView:self didSelectPostAtIndexPath:aIndexPath];
        }
    }
    else
    {
        if ([mDelegate respondsToSelector:@selector(readerViewDidTapFetchMoreButton:)])
        {
            [mDelegate readerViewDidTapFetchMoreButton:self];
        }

        [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];
    }
}


#pragma mark -
#pragma mark MEReaderHead Delegate


- (void)nicknameButtonTapped:(MEReaderHeadView *)aHeaderView;
{
    if ([mDelegate respondsToSelector:@selector(readerView:didTapUserInfoButtonForUser:)])
    {
        [mDelegate readerView:self didTapUserInfoButtonForUser:[mDataSource authorOfPostsInReaderView:self]];
    }
}


- (void)newPostButtonTapped:(MEReaderHeadView *)aReaderHeadView
{
    if ([mDelegate respondsToSelector:@selector(readerViewDidTapNewPostButton:)])
    {
        [mDelegate readerViewDidTapNewPostButton:self];
    }
}


@end
