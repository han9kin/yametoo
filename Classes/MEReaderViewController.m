/*
 *  MEReaderViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSDate+MEAdditions.h"
#import "UIAlertView+MEAdditions.h"
#import "UIViewController+MEAdditions.h"
#import "MEReaderViewController.h"
#import "MEUserInfoViewController.h"
#import "MEPostViewController.h"
#import "MEReplyViewController.h"
#import "MEMediaView.h"
#import "MESettings.h"
#import "MEPost.h"


#define kUpdateFetchCount 10


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
    return [[mPosts objectAtIndex:[aIndexPath section]] objectAtIndex:[aIndexPath row]];
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


- (void)addPosts:(NSArray *)aPosts
{
    static NSDateFormatter *sFormatter = nil;

    NSMutableArray *sPostsOfDay;
    MEPost         *sPost;
    BOOL            sHaveNewPost = NO;
    BOOL            sUpdated     = NO;

    if (!sFormatter)
    {
        sFormatter = [[NSDateFormatter alloc] init];
        [sFormatter setDateStyle:kCFDateFormatterShortStyle];
    }

    if (![mPosts count])
    {
        sUpdated = YES;
    }

    for (sPost in aPosts)
    {
        NSString *sPostDateStr = [sFormatter stringFromDate:[sPost pubDate]];
        BOOL      sAdded       = NO;

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

                    if ([[sPost pubDate] laterDate:mLastestDate] != mLastestDate)
                    {
                        [mLastestDate release];
                        mLastestDate = [[sPost pubDate] retain];
                        sHaveNewPost = YES;
                    }
                }
                else
                {
                    [sPostsOfDay replaceObjectAtIndex:sIndex withObject:sPost];
                    sUpdated = YES;
                }

                sAdded = YES;
                break;
            }
        }

        if (!sAdded)
        {
            sPostsOfDay = [NSMutableArray array];
            [sPostsOfDay addObject:sPost];
            [mPosts addObject:sPostsOfDay];
        }
    }

    mMoreOffset = 0;

    for (sPostsOfDay in mPosts)
    {
        mMoreOffset += [sPostsOfDay count];
        [sPostsOfDay sortUsingFunction:comparePostByPubDate context:NULL];
    }

    [mPosts sortUsingFunction:compareSectionByPubDate context:NULL];

    if (sHaveNewPost && !sUpdated)
    {
        mUpdateOffset += kUpdateFetchCount;
        [self fetchFromOffset:mUpdateOffset count:kUpdateFetchCount];
    }

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
    }

    return self;
}

- (id)initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBundle
{
    self = [super initWithNibName:aNibName bundle:aBundle];

    if (self)
    {
        mPosts = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)dealloc
{
    [mTimer invalidate];
    [mMediaView release];
    [mTitle release];
    [mTitleUserID release];
    [mPosts release];
    [mLastestDate release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
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
//    [sView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.7 blue:0.7 alpha:1.0]];
    [sView setBackgroundColor:[UIColor lightGrayColor]];
    [[self view] addSubview:sView];
    [sView release];

    mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 25)];
    [mTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mTitleLabel setTextColor:[UIColor blackColor]];
    [mTitleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [sView addSubview:mTitleLabel];
    [mTitleLabel release];

    mReaderView = [[MEReaderView alloc] initWithFrame:CGRectMake(0, 25, 320, 386)];
    [mReaderView setTitleUserID:mTitleUserID];
    [mReaderView setDataSource:self];
    [mReaderView setDelegate:self];
    [[self view] addSubview:mReaderView];
    [mReaderView release];

    mMediaView = [[MEMediaView alloc] initWithFrame:CGRectZero];
    [mMediaView setFrame:CGRectMake(0, 0, 320, 480)];

    [self configureReaderView:mReaderView];
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

    [mTitleLabel setText:mTitle];

    if ([mPosts count])
    {
        mUpdateOffset = 0;
        [self fetchFromOffset:0 count:kUpdateFetchCount];
    }
    else
    {
        [self fetchFromOffset:0 count:[MESettings initialFetchCount]];
    }

    if ([MESettings fetchInterval] > 0)
    {
        mTimer = [NSTimer scheduledTimerWithTimeInterval:([MESettings fetchInterval] * 60) target:self selector:@selector(updateTimerFired:) userInfo:nil repeats:YES];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(todayDidChange:) name:METodayDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];

    [mTimer invalidate];
    mTimer = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:METodayDidChangeNotification object:nil];
}


- (void)setTitle:(NSString *)aTitle
{
    if (mTitle != aTitle)
    {
        [mTitle release];
        mTitle = [aTitle copy];
    }
}


- (void)setTitleUserID:(NSString *)aUserID
{
    if (![mTitleUserID isEqualToString:aUserID])
    {
        [mTitleUserID release];
        mTitleUserID = [aUserID copy];

        [mReaderView setTitleUserID:mTitleUserID];
    }
}

- (void)invalidateData
{
    [mPosts removeAllObjects];
    [mReaderView invalidateData];
    [mReaderView reloadData];
}

- (void)reloadData
{
    [mReaderView reloadData];
}


- (void)configureReaderView:(MEReaderView *)aReaderView
{
}

- (void)fetchFromOffset:(NSInteger)aOffset count:(NSInteger)aCount
{
}


- (void)updateTimerFired:(NSTimer *)aTimer
{
    mUpdateOffset = 0;
    [self fetchFromOffset:0 count:kUpdateFetchCount];
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPosts:(NSArray *)aPosts error:(NSError *)aError
{
    if (aError)
    {
        [UIAlertView showError:aError];
        [mReaderView reloadData];
    }
    else
    {
        [self addPosts:aPosts];
    }
}


#pragma mark -
#pragma mark MEReaderViewDataSource


- (NSInteger)numberOfSectionsInReaderView:(MEReaderView *)aReaderView
{
    return [mPosts count];
}


- (NSString *)readerView:(MEReaderView *)aReaderView titleForSection:(NSInteger)aSection
{
    return [[self dateOfSection:aSection] localizedDateString];
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
    [self fetchFromOffset:mMoreOffset count:[MESettings moreFetchCount]];
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
    [self presentModalViewController:sReplyViewController animated:NO];
    [sReplyViewController release];
}


#pragma mark -
#pragma mark Observing Notifications


- (void)todayDidChange:(NSNotification *)aNotification
{
    [mReaderView reloadData];
}


@end
