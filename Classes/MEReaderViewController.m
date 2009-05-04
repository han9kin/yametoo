/*
 *  MEReaderViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIViewController+MEAdditions.h"
#import "MEReaderViewController.h"
#import "MEUserInfoViewController.h"
#import "MEPostViewController.h"
#import "MEReplyViewController.h"
#import "MEMediaView.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEPost.h"


@interface MEReaderViewController (Private)
@end

@implementation MEReaderViewController (Private)


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
    [mReaderView reloadData];
}

@end


@implementation MEReaderViewController

@synthesize type = mType;


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        mPostArray = [[NSMutableArray alloc] init];
    }

    return self;
}

- (id)initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBundle
{
    self = [super initWithNibName:aNibName bundle:aBundle];

    if (self)
    {
        mPostArray = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)dealloc
{
    [mMediaView release];
    [mUser release];
    [mPostArray release];
    [super dealloc];
}


- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *sView;

    sView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    [sView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.7 blue:0.7 alpha:1.0]];
    [[self view] addSubview:sView];
    [sView release];

    mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 25)];
    [mTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mTitleLabel setTextColor:[UIColor blackColor]];
    [mTitleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [sView addSubview:mTitleLabel];
    [mTitleLabel release];

    mReaderView = [[MEReaderView alloc] initWithFrame:CGRectMake(0, 25, 320, 386)];
    [mReaderView setShowsPostAuthor:((mType == kMEReaderViewControllerTypeMyFriends) ? YES : NO)];
    [mReaderView setDataSource:self];
    [mReaderView setDelegate:self];
    [[self view] addSubview:mReaderView];
    [mReaderView release];

    mMediaView = [[MEMediaView alloc] initWithFrame:CGRectZero];
    [mMediaView setFrame:CGRectMake(0, 0, 320, 480)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [mMediaView release];

    mTitleLabel = nil;
    mReaderView = nil;
    mMediaView  = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    NSString              *sTitle;
    MEClient              *sClient;
    NSString              *sUserID;
    MEClientGetPostsScope  sScope;

    sClient = [MEClientStore currentClient];
    sUserID = [sClient userID];

    if (mType == kMEReaderViewControllerTypeMyMetoo)
    {
        sTitle = [NSString stringWithFormat:NSLocalizedString(@"%@'s me2day", @""), sUserID];
        sScope = kMEClientGetPostsScopeAll;
    }
    else if (mType == kMEReaderViewControllerTypeMyFriends)
    {
        sTitle = [NSString stringWithFormat:NSLocalizedString(@"%@'s friends", @""), sUserID];
        sScope = kMEClientGetPostsScopeFriendAll;
    }
    else
    {
        NSAssert(0, @"invalid type");
    }

    [mTitleLabel setText:sTitle];

    if (mType == kMEReaderViewControllerTypeMyMetoo)
    {
        [sClient getPersonWithUserID:sUserID delegate:self];
    }

    [sClient getPostsWithUserID:sUserID scope:sScope offset:0 count:30 delegate:self];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    MEClient *sClient = [MEClientStore currentClient];
    NSString *sUserID = [sClient userID];

    if ([sUserID isEqualToString:[aUser userID]] && (mUser != aUser))
    {
        [mUser release];
        mUser = [aUser retain];

        [mReaderView reloadData];
    }
}


- (void)client:(MEClient *)aClient didGetPosts:(NSArray *)aPosts error:(NSError *)aError
{
    [mPostArray removeAllObjects];
    [self addPosts:aPosts];
}


#pragma mark -
#pragma mark MEReaderViewDataSource


- (MEUser *)authorOfPostsInReaderView:(MEReaderView *)aReaderView
{
    return mUser;
}


- (NSInteger)numberOfSectionsInReaderView:(MEReaderView *)aReaderView
{
    NSInteger sResult;

    sResult = [mPostArray count];

    if (sResult == 0)
    {
        sResult = 1;
    }

    return sResult;
}


- (NSString *)readerView:(MEReaderView *)aReaderView titleForSection:(NSInteger)aSection
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


- (NSInteger)readerView:(MEReaderView *)aReaderView numberOfPostsInSection:(NSInteger)aSection
{
    NSInteger sResult = 0;

    if ([mPostArray count] > 0)
    {
        sResult = [[mPostArray objectAtIndex:aSection] count];
    }

    return sResult;
}


- (MEPost *)readerView:(MEReaderView *)aReaderView postAtIndexPath:(NSIndexPath *)aIndexPath
{
    return [self postForIndexPath:aIndexPath];
}


#pragma mark -
#pragma mark MEReaderViewDelegate


- (void)readerViewDidTapNewPostButton:(MEReaderView *)aReaderView
{
    UIViewController *sViewController;

    sViewController = [[MEPostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
    [self presentModalViewController:sViewController animated:YES];
    [sViewController release];
}


- (void)readerView:(MEReaderView *)aReaderView didTapUserInfoButtonForUser:(MEUser *)aUser
{
    MEUserInfoViewController *sUserInfoViewController = [[MEUserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    [sUserInfoViewController setUser:aUser];
    [[[self view] window] addSubview:[sUserInfoViewController view]];
}


- (void)readerView:(MEReaderView *)aReaderView didTapPostIconButtonForPost:(MEPost *)aPost
{
    NSURL *sPhotoURL = [aPost photoURL];

    if (sPhotoURL)
    {
        [mMediaView setPhotoURL:sPhotoURL];
        [[[self view] window] addSubview:mMediaView];
    }
}


- (void)readerView:(MEReaderView *)aReaderView didSelectPostAtIndexPath:(NSIndexPath *)aIndexPath
{
    MEReplyViewController *sReplyViewController;
    MEPost                *sPost;

    [aReaderView deselectPostAtIndexPath:aIndexPath animated:YES];

    sPost = [self postForIndexPath:aIndexPath];

    sReplyViewController = [[MEReplyViewController alloc] initWithNibName:@"MEReplyViewController" bundle:nil];
    [sReplyViewController setPost:sPost];
    [[[self view] window] addSubview:[sReplyViewController view]];
}


@end
