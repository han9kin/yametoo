/*
 *  MEReaderViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIAlertView+MEAdditions.h"
#import "UIViewController+MEAdditions.h"
#import "MEReaderViewController.h"
#import "MEUserInfoViewController.h"
#import "MEPostViewController.h"
#import "MEReplyViewController.h"
#import "MEMediaView.h"
#import "MESettings.h"
#import "MEClientStore.h"
#import "MEPost.h"


static NSComparisonResult compareSectionByPubDate(NSArray *sPosts1, NSArray *sPosts2, void *aContext)
{
    return [[[sPosts2 lastObject] pubDate] compare:[[sPosts1 lastObject] pubDate]];
}

static NSComparisonResult comparePostByPubDate(MEPost *sPost1, MEPost *sPost2, void *aContext)
{
    return [[sPost2 pubDate] compare:[sPost1 pubDate]];
}


@interface MEReaderViewController (Private)
@end

@implementation MEReaderViewController (Private)


- (MEPost *)postForIndexPath:(NSIndexPath *)aIndexPath
{
    MEPost  *sResult     = nil;
    NSArray *sPostsOfDay;

    if ([mPosts count] > [aIndexPath section])
    {
        sPostsOfDay = [mPosts objectAtIndex:[aIndexPath section]];

        if ([sPostsOfDay count] > [aIndexPath row])
        {
            sResult = [sPostsOfDay objectAtIndex:[aIndexPath row]];
        }
    }

    return sResult;
}


- (NSDate *)dateOfSection:(NSInteger)aSection
{
    if ([mPosts count] > aSection)
    {
        return [[[mPosts objectAtIndex:aSection] lastObject] pubDate];
    }
    else
    {
        return nil;
    }
}


- (void)addPosts:(NSArray *)aPostArray
{
    NSDateFormatter *sFormatter = [[NSDateFormatter alloc] init];
    NSMutableArray  *sPostsOfDay;
    MEPost          *sPost;

    [sFormatter setDateStyle:kCFDateFormatterShortStyle];

    for (sPost in aPostArray)
    {
        NSString       *sPostDateStr = [sFormatter stringFromDate:[sPost pubDate]];
        BOOL            sIsAdded = NO;

        for (sPostsOfDay in mPosts)
        {
            MEPost   *sTitlePost = [sPostsOfDay lastObject];
            NSString *sDateStr   = [sFormatter stringFromDate:[sTitlePost pubDate]];

            if ([sDateStr isEqualToString:sPostDateStr])
            {
                NSUInteger sIndex = [sPostsOfDay indexOfObject:sPost];

                if (sIndex == NSNotFound)
                {
                    [sPostsOfDay addObject:sPost];
                }
                else
                {
                    [sPostsOfDay replaceObjectAtIndex:sIndex withObject:sPost];
                }

                sIsAdded = YES;
                break;
            }
        }

        if (!sIsAdded)
        {
            sPostsOfDay = [NSMutableArray array];
            [sPostsOfDay addObject:sPost];
            [mPosts addObject:sPostsOfDay];
        }
    }

    for (sPostsOfDay in mPosts)
    {
        [sPostsOfDay sortUsingFunction:comparePostByPubDate context:NULL];
    }

    [mPosts sortUsingFunction:compareSectionByPubDate context:NULL];

    [sFormatter release];
    [mReaderView reloadData];
}

@end


@implementation MEReaderViewController


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        mPosts = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChange:) name:MEClientStoreCurrentUserDidChangeNotification object:nil];
    }

    return self;
}

- (id)initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBundle
{
    self = [super initWithNibName:aNibName bundle:aBundle];

    if (self)
    {
        mPosts = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChange:) name:MEClientStoreCurrentUserDidChangeNotification object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [mMediaView release];
    [mUser release];
    [mPosts release];

    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}


- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView  *sView;

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

    mReaderView = nil;
    mMediaView  = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    MEClient *sClient;
    NSString *sUserID;

    sClient = [MEClientStore currentClient];
    sUserID = [sClient userID];

    if (mType == kMEReaderViewControllerTypeMyMetoo)
    {
        [mTitleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%@'s me2day", @""), sUserID]];
        [sClient getPersonWithUserID:sUserID delegate:self];
    }
    else if (mType == kMEReaderViewControllerTypeMyFriends)
    {
        [mTitleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%@'s friends", @""), sUserID]];
    }

    [sClient getPostsWithUserID:sUserID scope:mScope offset:0 count:[MESettings initialFetchCount] delegate:self];

    if (mOffset == 0)
    {
        mOffset = [MESettings initialFetchCount];
    }

    if ([MESettings fetchInterval] > 0)
    {
        mTimer = [NSTimer scheduledTimerWithTimeInterval:([MESettings fetchInterval] * 60) target:self selector:@selector(fetchTimerFired:) userInfo:nil repeats:YES];
    }
}

- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];

    [mTimer invalidate];
    mTimer = nil;
}


- (MEReaderViewControllerType)type
{
    return mType;
}


- (void)setType:(MEReaderViewControllerType)aType
{
    mType = aType;

    if (mType == kMEReaderViewControllerTypeMyMetoo)
    {
        mScope = kMEClientGetPostsScopeAll;
    }
    else if (mType == kMEReaderViewControllerTypeMyFriends)
    {
        mScope = kMEClientGetPostsScopeFriendAll;
    }
    else
    {
        NSAssert(0, @"invalid type");
    }
}


- (void)fetchTimerFired:(NSTimer *)aTimer
{
    MEClient *sClient;
    NSString *sUserID;

    sClient = [MEClientStore currentClient];
    sUserID = [sClient userID];

    [sClient getPostsWithUserID:sUserID scope:mScope offset:0 count:[MESettings initialFetchCount] delegate:self];
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
    if (aError)
    {
        [UIAlertView showError:aError];
    }
    else
    {
        [self addPosts:aPosts];
    }
}


#pragma mark -
#pragma mark MEReaderViewDataSource


- (MEUser *)authorOfPostsInReaderView:(MEReaderView *)aReaderView
{
    return mUser;
}


- (NSInteger)numberOfSectionsInReaderView:(MEReaderView *)aReaderView
{
    return [mPosts count];
}


- (NSString *)readerView:(MEReaderView *)aReaderView titleForSection:(NSInteger)aSection
{
    static NSDateFormatter *sFormatter = nil;

    if (!sFormatter)
    {
        sFormatter = [[NSDateFormatter alloc] init];
        [sFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
        [sFormatter setDateFormat:@"d LLL y"];
    }

    return [[sFormatter stringFromDate:[self dateOfSection:aSection]] uppercaseString];
}


- (NSInteger)readerView:(MEReaderView *)aReaderView numberOfPostsInSection:(NSInteger)aSection
{
    if (aSection < [mPosts count])
    {
        return [[mPosts objectAtIndex:aSection] count];
    }
    else
    {
        return 0;
    }
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


- (void)readerViewDidTapFetchMoreButton:(MEReaderView *)aReaderView
{
    MEClient *sClient = [MEClientStore currentClient];
    NSString *sUserID = [sClient userID];

    [sClient getPostsWithUserID:sUserID scope:mScope offset:mOffset count:[MESettings moreFetchCount] delegate:self];

    mOffset += [MESettings moreFetchCount];
}


- (void)readerView:(MEReaderView *)aReaderView didTapUserInfoButtonForUser:(MEUser *)aUser
{
    MEUserInfoViewController *sUserInfoViewController = [[MEUserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    [sUserInfoViewController setUser:aUser];
    [[self view] addSubview:[sUserInfoViewController view]];
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
//    [[self view] addSubview:[sReplyViewController view]];
    [self presentModalViewController:sReplyViewController animated:NO];
    [sReplyViewController release];
}


#pragma mark -
#pragma mark MEClientStore Notifications


- (void)currentUserDidChange:(NSNotification *)aNotification
{
    [mUser release];
    mUser = nil;

    [mPosts removeAllObjects];
}


@end
