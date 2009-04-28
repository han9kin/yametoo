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
#import "MEMediaView.h"
#import "MEPost.h"
#import "MEUser.h"
#import "MEAttributedLabel.h"
#import "MEAttributedString.h"
#import "MEUserInfoViewController.h"
#import "MEActionPopupViewController.h"


#define kPostBodyWidth  250
#define kTimeStrHeight  13.0


@implementation MEReaderView


- (void)initializeVariables
{
    mPostArray      = [[NSMutableArray alloc] init];
    mCellHeightDict = [[NSMutableDictionary alloc] init];
}


- (void)initializeViews
{
    CGRect            sBounds   = [self bounds];
    MEReaderHeadView *sHeadView = [MEReaderHeadView readerHeadView];

    [sHeadView setDelegate:self];

    mTableView = [[UITableView alloc] initWithFrame:sBounds style:UITableViewStylePlain];
    [mTableView setDataSource:self];
    [mTableView setDelegate:self];
    [mTableView setTableHeaderView:sHeadView];
    [mTableView setDelaysContentTouches:YES];
//    [mTableView setCanCancelContentTouches:YES];
    
    mMediaView = [[MEMediaView alloc] initWithFrame:CGRectZero];

    [self addSubview:mTableView];
}


#pragma mark -
#pragma mark init/dealloc


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


- (void)dealloc
{
    [mUser           release];
    
    [mPostArray      release];
    [mTableView      release];
    [mCellHeightDict release];

    [super dealloc];
}


#pragma mark -


- (void)drawRect:(CGRect)aRect
{
    // Drawing code
}


#pragma mark -
#pragma mark Instance Methods


- (void)setDelegate:(id)aDelegate
{
    mDelegate = aDelegate;
}


- (void)setUser:(MEUser *)aUser
{
    MEReaderHeadView *sHeaderView;
    
    [mUser autorelease];
    mUser = [aUser retain];

    sHeaderView = (MEReaderHeadView *)[mTableView tableHeaderView];
    [sHeaderView setNickname:[aUser nickname]];
    [sHeaderView setFaceImageURL:[aUser faceImageURL]];
}


- (void)setHiddenPostButton:(BOOL)aFlag
{
    MEReaderHeadView *sHeaderView;

    sHeaderView = (MEReaderHeadView *)[mTableView tableHeaderView];
    [sHeaderView setHiddenPostButton:aFlag];
}


- (void)addPost:(MEPost *)aPost
{
    NSDate          *sDate        = [aPost pubDate];
    NSDateFormatter *sFormatter   = [[[NSDateFormatter alloc] init] autorelease];
    NSString        *sPostDateStr;
    NSString        *sDateStr;
    NSMutableArray  *sPostsOfDay;
    BOOL             sIsAdded = NO;

    [sFormatter setDateStyle:kCFDateFormatterShortStyle];
    sPostDateStr = [sFormatter stringFromDate:sDate];

    for (sPostsOfDay in mPostArray)
    {
        if ([sPostsOfDay count] != 0)
        {
            MEPost *sPost = [sPostsOfDay objectAtIndex:0];
            sDateStr = [sFormatter stringFromDate:[sPost pubDate]];
            if ([sDateStr isEqualToString:sPostDateStr])
            {
                [sPostsOfDay addObject:aPost];
                sIsAdded = YES;
            }
        }
    }

    if (!sIsAdded)
    {
        sPostsOfDay = [NSMutableArray array];
        [sPostsOfDay addObject:aPost];
        [mPostArray addObject:sPostsOfDay];
    }

    [mTableView reloadData];
}


- (void)addPosts:(NSArray *)aPostArray
{
    MEPost          *sPost;
    NSDateFormatter *sFormatter = [[NSDateFormatter alloc] init];

    [sFormatter setDateStyle:kCFDateFormatterShortStyle];

    for (sPost in aPostArray)
    {
        NSString       *sPostDateStr = [sFormatter stringFromDate:[sPost pubDate]];
        NSMutableArray *sPostsOfDay;
        BOOL            sIsAdded = NO;

        for (sPostsOfDay in mPostArray)
        {
            MEPost   *sTitlePost = [sPostsOfDay lastObject];
            NSString *sDateStr   = [sFormatter stringFromDate:[sTitlePost pubDate]];

            if ([sDateStr isEqualToString:sPostDateStr])
            {
                [sPostsOfDay addObject:sPost];
                sIsAdded = YES;
                break;
            }
        }

        if (!sIsAdded)
        {
            sPostsOfDay = [NSMutableArray array];
            [sPostsOfDay addObject:sPost];
            [mPostArray addObject:sPostsOfDay];
        }
    }

    [sFormatter release];
    [mTableView reloadData];
}


- (void)removeAllPosts
{
    [mPostArray      removeAllObjects];
    [mCellHeightDict removeAllObjects];
}


- (MEPost *)postForIndexPath:(NSIndexPath *)aIndexPath
{
    MEPost  *sResult = nil;
    NSArray *sPostArrayOfDay;

    if ([mPostArray count] > [aIndexPath section])
    {
        sPostArrayOfDay = [mPostArray objectAtIndex:[aIndexPath section]];
        if ([sPostArrayOfDay count] > [aIndexPath row])
        {
            sResult = [sPostArrayOfDay objectAtIndex:[aIndexPath row]];
        }
    }

    return sResult;
}


- (MEPost *)postForPostID:(NSString *)aPostID
{
    MEPost *sResult = nil;
    MEPost *sPost;
    NSArray *sArray;
    
    for (sArray in mPostArray)
    {
        for (sPost in sArray)
        {
            if ([[sPost postID] isEqualToString:aPostID])
            {
                sResult = sPost;
                break;
            }
        }
    }
    
    return sResult;
}


- (MEPost *)titlePostForSection:(NSInteger)aSection
{
    MEPost  *sResult = nil;
    NSArray *sPostArrayOfDay;

    if ([mPostArray count] > aSection)
    {
        sPostArrayOfDay = [mPostArray objectAtIndex:aSection];
        if ([sPostArrayOfDay count] > 0)
        {
            sResult = [sPostArrayOfDay objectAtIndex:0];
        }
    }

    return sResult;
}


#pragma mark -
#pragma mark actions


- (IBAction)imageViewTapped:(id)aSender
{
    MEImageView *sImageView = (MEImageView *)aSender;
    NSString    *sPostID    = [[sImageView userInfo] objectForKey:@"postID"];
    MEPost      *sPost      = [self postForPostID:sPostID];
    NSURL       *sPhotoURL  = [sPost photoURL];

    if (sPhotoURL)
    {
        [mMediaView setPhotoURL:sPhotoURL];
        [mMediaView setFrame:CGRectMake(0, 0, 320, 480)];
        [[self window] addSubview:mMediaView];
    }
}


#pragma mark -
#pragma mark TableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    NSInteger sResult;

    sResult = [mPostArray count];
    if (sResult == 0)
    {
        sResult = 1;
    }

    return sResult;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    static NSDateFormatter *sFormatter = nil;

    NSString *sResult = nil;
    MEPost   *sTitlePost;

    if (!sFormatter)
    {
        sFormatter = [[NSDateFormatter alloc] init];
        [sFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
        [sFormatter setDateFormat:@"d LLL y"];
    }

    sTitlePost = [self titlePostForSection:aSection];
    sResult    = [[sFormatter stringFromDate:[sTitlePost pubDate]] uppercaseString];

    return sResult;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    NSInteger sResult = 0;

    if ([mPostArray count] > 0)
    {
        sResult = [[mPostArray objectAtIndex:aSection] count];
    }

    return sResult;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell    *sResult = nil;
    MEAttributedLabel  *sBodyLabel;
    UILabel            *sTagsLabel;
    UILabel            *sTimeLabel;
    UILabel            *sReplyLabel;
    MEImageView        *sImageView;
    MEPost             *sPost = [self postForIndexPath:aIndexPath];
    MEAttributedString *sBody = [sPost body];
    NSString           *sTags = [sPost tagsString];
    NSString           *sTimeStr;
    CGSize              sSize;
    CGFloat             sYPos = 10;

    sResult     = [METableViewCellFactory postCellForTableView:aTableView];
    sBodyLabel  = (MEAttributedLabel *)[[sResult contentView] viewWithTag:kPostCellBodyLabelTag];
    sTagsLabel  = (UILabel *)[[sResult contentView] viewWithTag:kPostCellTagsLabelTag];
    sTimeLabel  = (UILabel *)[[sResult contentView] viewWithTag:kPostCellTimeLabelTag];
    sReplyLabel = (UILabel *)[[sResult contentView] viewWithTag:kPostCellReplyLabelTag];
    sImageView  = (MEImageView *)[[sResult contentView] viewWithTag:kPostCellImageViewTag];

    [sImageView addTarget:self action:@selector(imageViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[sImageView userInfo] setValue:[sPost postID] forKey:@"postID"];
    [sImageView setImageWithURL:[sPost iconURL]];

    [sBodyLabel setFrame:CGRectMake(60, sYPos, kPostBodyWidth, 0)];
    [sBodyLabel setAttributedText:sBody];
    [sBodyLabel sizeToFit];

    sSize  = [sBodyLabel frame].size;
    sYPos += (sSize.height + 5);

    if (![sTags isEqualToString:@""])
    {
        sSize = [sTags sizeWithFont:[sTagsLabel font]
                  constrainedToSize:CGSizeMake(kPostBodyWidth, 10000)
                      lineBreakMode:UILineBreakModeCharacterWrap];
        [sTagsLabel setText:sTags];
        [sTagsLabel setFrame:CGRectMake(60, sYPos, sSize.width, sSize.height)];
        [sTagsLabel setHidden:NO];

        sYPos += (sSize.height + 5);
    }
    else
    {
        [sTagsLabel setHidden:YES];
    }

    sTimeStr = [sPost pubTimeString];
    sSize.height = kTimeStrHeight;
    [sTimeLabel setText:sTimeStr];
    [sTimeLabel setFrame:CGRectMake(60, sYPos, 100, sSize.height)];

    [sReplyLabel setText:[NSString stringWithFormat:@"댓글 (%d)", [sPost commentsCount]]];
    [sReplyLabel setFrame:CGRectMake(210, sYPos, 100, sSize.height)];

    return sResult;
}


#pragma mark -
#pragma mark TableView Delegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    [aTableView deselectRowAtIndexPath:aIndexPath animated:YES];
    
    MEActionPopupViewController *sViewController = [[MEActionPopupViewController alloc] initWithNibName:@"ActionPopupViewController" bundle:nil];
    [[self window] addSubview:[sViewController view]];
}


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    CGFloat             sResult = 0;
    MEPost             *sPost   = [self postForIndexPath:aIndexPath];
    NSNumber           *sHeight = [mCellHeightDict objectForKey:[sPost postID]];
    MEAttributedString *sBody;
    NSString           *sTags;
    CGSize              sSize;

    if (sHeight)
    {
        sResult = [sHeight floatValue];
    }
    else
    {
        sBody = [sPost body];
        sTags = [sPost tagsString];

        sResult += 10;
        sSize    = [sBody sizeForWidth:kPostBodyWidth];
        sResult += (sSize.height + 5);

        if (![sTags isEqualToString:@""])
        {
            sSize    = [sTags sizeWithFont:[METableViewCellFactory fontForPostTag]
                         constrainedToSize:CGSizeMake(kPostBodyWidth, 10000)
                             lineBreakMode:UILineBreakModeCharacterWrap];
            sResult += (sSize.height + 5);
        }

        sResult += kTimeStrHeight;
        sResult += 10;
        sResult  = (sResult < 70) ? 70 : sResult;

        [mCellHeightDict setObject:[NSNumber numberWithFloat:sResult] forKey:[sPost postID]];
    }

    return sResult;
}


#pragma mark -
#pragma mark MEReaderHead Delegate


- (void)nicknameButtonTapped:(MEReaderHeadView *)aHeaderView;
{
    MEUserInfoViewController *sUserInfoViewController = [[MEUserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    [sUserInfoViewController setUser:mUser];
    [[self window] addSubview:[sUserInfoViewController view]];
}


- (void)newPostButtonTapped:(MEReaderHeadView *)aReaderHeadView
{
    if ([mDelegate respondsToSelector:@selector(newPostForReaderView:)])
    {
        [mDelegate newPostForReaderView:self];
    }
}


@end
