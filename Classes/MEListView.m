/*
 *  MEListView.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSNull+NilObject.h"
#import "MEListView.h"
#import "METableViewCellFactory.h"
#import "MEPostTableViewCell.h"
#import "MEListHeadView.h"
#import "MEImageButton.h"
#import "MEPostBodyView.h"
#import "MEPost.h"
#import "MEUser.h"
#import "MEAttributedLabel.h"
#import "MEAttributedString.h"


#define kPostBodyWidth  250
#define kTimeStrHeight  13.0


@implementation MEListView


#pragma mark -
#pragma mark properties


@synthesize dataSource = mDataSource;
@synthesize delegate   = mDelegate;


#pragma mark -


- (void)initSelf
{
    mSectionTitleCache = [[NSMutableArray alloc] init];
    mCellHeightCache   = [[NSMutableDictionary alloc] init];

    mTableView = [[UITableView alloc] initWithFrame:[self bounds] style:UITableViewStylePlain];
    [mTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
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
        [self initSelf];
    }

    return self;
}


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        [self initSelf];
    }

    return self;
}


- (void)dealloc
{
    [mSectionTitleCache release];
    [mCellHeightCache release];
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setAuthor:(MEUser *)aUser
{
    if (aUser)
    {
        MEListHeadView *sHeaderView = (MEListHeadView *)[mTableView tableHeaderView];

        if (!sHeaderView)
        {
            sHeaderView = [[MEListHeadView alloc] initWithFrame:CGRectMake(0, 0, [self bounds].size.width, kListHeadViewHeight)];
            [sHeaderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [mTableView setTableHeaderView:sHeaderView];
            [sHeaderView release];
        }

        [sHeaderView setUser:aUser];
    }
    else
    {
        if ([mTableView tableHeaderView])
        {
            [mTableView setTableHeaderView:nil];
        }
    }
}


- (void)setShowsPostAuthor:(BOOL)aShowsPostAuthor
{
    mShowsPostAuthor = aShowsPostAuthor;
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


- (NSIndexPath *)indexPathForTopVisiblePost
{
    return [mTableView indexPathForRowAtPoint:[mTableView contentOffset]];
}

- (void)scrollToPostAtIndexPath:(NSIndexPath *)aIndexPath atScrollPosition:(UITableViewScrollPosition)aScrollPosition animated:(BOOL)aAnimated
{
    [mTableView scrollToRowAtIndexPath:aIndexPath atScrollPosition:aScrollPosition animated:aAnimated];
}

- (void)invalidateData
{
    [mCellHeightCache removeAllObjects];
}


- (void)reloadData
{
    NSInteger i;

    mSectionCount = [mDataSource numberOfSectionsInListView:self];

    [mSectionTitleCache removeAllObjects];

    for (i = 0; i < mSectionCount; i++)
    {
        NSString *sTitle = [mDataSource listView:self titleForSection:i];

        if (sTitle)
        {
            [mSectionTitleCache addObject:sTitle];
        }
        else
        {
            [mSectionTitleCache addObject:[NSNull null]];
        }
    }

    [mTableView reloadData];
}


#pragma mark -
#pragma mark actions


- (void)faceImageButtonTapped:(id)aSender
{
    if ([mDelegate respondsToSelector:@selector(listView:didTapUserInfoButtonForUser:)])
    {
        MEUser *sUser = [(MEImageButton *)aSender userInfo];

        if (sUser)
        {
            [mDelegate listView:self didTapUserInfoButtonForUser:sUser];
        }
    }
}


- (void)iconImageButtonTapped:(id)aSender
{
    if ([mDelegate respondsToSelector:@selector(listView:didTapPostIconButtonForPost:)])
    {
        MEPost *sPost = [(MEImageButton *)aSender userInfo];

        if (sPost)
        {
            [mDelegate listView:self didTapPostIconButtonForPost:sPost];
        }
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
    NSString *sTitle;

    if (aSection < mSectionCount)
    {
        sTitle = [mSectionTitleCache objectAtIndex:aSection];

        if (![sTitle isNotNull])
        {
            sTitle = nil;
        }
    }
    else
    {
        sTitle = nil;
    }

    return sTitle;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    if (aSection < mSectionCount)
    {
        return [mDataSource listView:self numberOfPostsInSection:aSection];
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
        MEPost *sPost = [mDataSource listView:self postAtIndexPath:aIndexPath];

        if (mShowsPostAuthor)
        {
            sCell = [MEPostTableViewCell cellWithAuthorForTableView:aTableView withTarget:self];
        }
        else
        {
            sCell = [MEPostTableViewCell cellForTableView:aTableView withTarget:self];
        }

        [(MEPostTableViewCell *)sCell setPost:sPost];
    }
    else
    {
        sCell = [METableViewCellFactory defaultCellForTableView:aTableView];

        [[sCell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
        [[sCell textLabel] setTextAlignment:UITextAlignmentCenter];
        [[sCell textLabel] setText:NSLocalizedString(@"Fetch more...", @"")];
    }

    return sCell;
}


#pragma mark -
#pragma mark TableView Delegate


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    CGFloat sHeight;

    if ([aIndexPath section] < mSectionCount)
    {
        MEPost   *sPost         = [mDataSource listView:self postAtIndexPath:aIndexPath];
        NSNumber *sCachedHeight = [mCellHeightCache objectForKey:[sPost postID]];

        if (sCachedHeight)
        {
            sHeight = [sCachedHeight floatValue];
        }
        else
        {
            CGFloat sWidth = [self bounds].size.width;

            if (mShowsPostAuthor && (sWidth > 400))
            {
                sHeight = [MEPostBodyView heightWithPost:sPost forWidth:([self bounds].size.width - kPostCellBodyLeftPadding - kPostCellIconPadding)];
            }
            else
            {
                sHeight = [MEPostBodyView heightWithPost:sPost forWidth:([self bounds].size.width - kPostCellBodyLeftPadding)];
            }

            sHeight += kPostCellBodyTopPadding * 2;

            if (mShowsPostAuthor && ([self bounds].size.width < 400))
            {
                sHeight  = (sHeight < 115) ? 115 : sHeight;
            }
            else
            {
                sHeight = (sHeight < 65) ? 65 : sHeight;
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
        if ([mDelegate respondsToSelector:@selector(listView:didSelectPostAtIndexPath:)])
        {
            [mDelegate listView:self didSelectPostAtIndexPath:aIndexPath];
        }
    }
    else
    {
        if ([mDelegate respondsToSelector:@selector(listViewDidTapFetchMoreButton:)])
        {
            [mDelegate listViewDidTapFetchMoreButton:self];
        }

        [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];
    }
}


@end
