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
    mCellHeightDict = [[NSMutableDictionary alloc] init];
}


- (void)initializeViews
{
    CGRect sBounds = [self bounds];

    mTableView = [[UITableView alloc] initWithFrame:sBounds style:UITableViewStylePlain];
    [mTableView setDataSource:self];
    [mTableView setDelegate:self];
    [mTableView setDelaysContentTouches:YES];
//    [mTableView setCanCancelContentTouches:YES];

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
    [mCellHeightDict release];
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setHiddenPostButton:(BOOL)aFlag
{
    MEReaderHeadView *sHeaderView;

    sHeaderView = (MEReaderHeadView *)[mTableView tableHeaderView];
    [sHeaderView setHiddenPostButton:aFlag];
}


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
        [mCellHeightDict removeAllObjects];
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
        MEUser      *sAuthor    = [[sImageView userInfo] objectForKey:@"author"];

        [mDelegate readerView:self didTapUserInfoButtonForUser:sAuthor];
    }
}


- (void)iconImageViewTapped:(id)aSender
{
    if ([mDelegate respondsToSelector:@selector(readerView:didTapPostIconButtonForPost:)])
    {
        MEImageView *sImageView = (MEImageView *)aSender;
        MEPost      *sPost      = [[sImageView userInfo] objectForKey:@"post"];

        [mDelegate readerView:self didTapPostIconButtonForPost:sPost];
    }
}


#pragma mark -
#pragma mark TableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return [mDataSource numberOfSectionsInReaderView:self];
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    return [mDataSource readerView:self titleForSection:aSection];
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    return [mDataSource readerView:self numberOfPostsInSection:aSection];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sResult;
    UILabel         *sLabel;
    MEImageView     *sImageView;
    MEPostBodyView  *sBodyView;
    MEPost          *sPost;

    sPost = [mDataSource readerView:self postAtIndexPath:aIndexPath];

    if (mShowsPostAuthor)
    {
        sResult = [METableViewCellFactory postCellWithAuthorForTableView:aTableView];

        sImageView = (MEImageView *)[[sResult contentView] viewWithTag:kPostCellFaceImageViewTag];
        [sImageView addTarget:self action:@selector(faceImageViewTapped:) forControlEvents:UIControlEventTouchUpInside];
        [[sImageView userInfo] setValue:[sPost author] forKey:@"author"];
        [sImageView setImageWithURL:[[sPost author] faceImageURL]];

        sLabel = (UILabel *)[[sResult contentView] viewWithTag:kPostCellAuthorNameLabelTag];
        [sLabel setText:[[sPost author] nickname]];
    }
    else
    {
        sResult = [METableViewCellFactory postCellForTableView:aTableView];
    }

    sImageView = (MEImageView *)[[sResult contentView] viewWithTag:kPostCellIconImageViewTag];
    [sImageView addTarget:self action:@selector(iconImageViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[sImageView userInfo] setValue:sPost forKey:@"post"];
    [sImageView setImageWithURL:[sPost iconURL]];

    sBodyView = (MEPostBodyView *)[[sResult contentView] viewWithTag:kPostCellBodyViewTag];
    [sBodyView setPost:sPost];

    return sResult;
}


#pragma mark -
#pragma mark TableView Delegate


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    CGFloat   sResult = 0;
    MEPost   *sPost   = [mDataSource readerView:self postAtIndexPath:aIndexPath];
    NSNumber *sHeight = [mCellHeightDict objectForKey:[sPost postID]];

    if (sHeight)
    {
        sResult = [sHeight floatValue];
    }
    else
    {
        sResult = [MEPostBodyView heightWithPost:sPost] + kPostCellBodyPadding * 2;

        if (mShowsPostAuthor)
        {
            sResult += 20;
            sResult  = (sResult < 115) ? 115 : sResult;
        }
        else
        {
            sResult  = (sResult < 70) ? 70 : sResult;
        }

        [mCellHeightDict setObject:[NSNumber numberWithFloat:sResult] forKey:[sPost postID]];
    }

    return sResult;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    if ([mDelegate respondsToSelector:@selector(readerView:didSelectPostAtIndexPath:)])
    {
        [mDelegate readerView:self didSelectPostAtIndexPath:aIndexPath];
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
