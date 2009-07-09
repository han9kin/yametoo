/*
 *  MEListViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSDate+MEAdditions.h"
#import "UIAlertView+MEAdditions.h"
#import "UIViewController+MEAdditions.h"
#import "MEListView.h"
#import "MEListViewController.h"
#import "MEPostViewController.h"
#import "MEReadViewController.h"
#import "MEVisitsViewController.h"
#import "MEMediaView.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MESettings.h"
#import "MEPost.h"
#import "MEUser.h"
#import "MELink.h"


#define kUpdateFetchCount 10


static NSComparisonResult compareSectionByPubDate(NSArray *sPosts1, NSArray *sPosts2, void *aContext)
{
    return [[[sPosts2 lastObject] pubDate] compare:[[sPosts1 lastObject] pubDate]];
}

static NSComparisonResult comparePostByPubDate(MEPost *sPost1, MEPost *sPost2, void *aContext)
{
    return [[sPost2 pubDate] compare:[sPost1 pubDate]];
}


@interface MEListViewController (Private)
@end

@implementation MEListViewController (Private)


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

    if (sHaveNewPost && !sUpdated && [MESettings couldImplicitFetch])
    {
        mUpdateOffset += kUpdateFetchCount;
        [self fetchFromOffset:mUpdateOffset count:kUpdateFetchCount];
    }

    [mListView reloadData];
}

@end


@implementation MEListViewController


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

    mMediaView = nil;

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

    UIView *sView;
    CGRect  sRect;

    sRect = [[self view] bounds];

    sView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sRect.size.width, 25)];
    [sView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [sView setBackgroundColor:[UIColor lightGrayColor]];
    [[self view] addSubview:sView];
    [sView release];

    mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, sRect.size.width - 20, 25)];
    [mTitleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [mTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mTitleLabel setTextColor:[UIColor blackColor]];
    [mTitleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [mTitleLabel setText:mTitle];
    [sView addSubview:mTitleLabel];
    [mTitleLabel release];

    mListView = [[MEListView alloc] initWithFrame:CGRectMake(0, 25, sRect.size.width, sRect.size.height - 25)];
    [mListView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [mListView setTitleUserID:mTitleUserID];
    [mListView setDataSource:self];
    [mListView setDelegate:self];
    [[self view] addSubview:mListView];
    [mListView release];

    mMediaView = [[MEMediaView alloc] initWithFrame:CGRectZero];
    [mMediaView setFrame:CGRectMake(0, 0, 320, 480)];

    [self configureListView:mListView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [mMediaView release];

    mTitleLabel = nil;
    mListView = nil;
    mMediaView  = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    if ([mPosts count])
    {
        if ([MESettings couldImplicitFetch])
        {
            mUpdateOffset = 0;
            [self fetchFromOffset:0 count:kUpdateFetchCount];
        }
    }
    else
    {
        [self fetchFromOffset:0 count:[MESettings initialFetchCount]];
    }

    [mListView deselectPostAtIndexPath:[mListView indexPathForSelectedPost] animated:YES];

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

        [mTitleLabel setText:mTitle];
    }
}


- (void)setTitleUserID:(NSString *)aUserID
{
    if (![mTitleUserID isEqualToString:aUserID])
    {
        [mTitleUserID release];
        mTitleUserID = [aUserID copy];

        [mListView setTitleUserID:mTitleUserID];
    }
}

- (void)invalidateData
{
    [mPosts removeAllObjects];
    [mListView invalidateData];
    [mListView reloadData];
}

- (void)reloadData
{
    [mListView reloadData];
}


- (void)configureListView:(MEListView *)aListView
{
}

- (void)fetchFromOffset:(NSInteger)aOffset count:(NSInteger)aCount
{
}


- (void)updateTimerFired:(NSTimer *)aTimer
{
    if ([MESettings couldImplicitFetch])
    {
        mUpdateOffset = 0;
        [self fetchFromOffset:0 count:kUpdateFetchCount];
    }
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPosts:(NSArray *)aPosts error:(NSError *)aError
{
    if (aError)
    {
        [UIAlertView showError:aError];
        [mListView reloadData];
    }
    else
    {
        [self addPosts:aPosts];
    }
}


#pragma mark -
#pragma mark MEListViewDataSource


- (NSInteger)numberOfSectionsInListView:(MEListView *)aListView
{
    return [mPosts count];
}


- (NSString *)listView:(MEListView *)aListView titleForSection:(NSInteger)aSection
{
    return [[self dateOfSection:aSection] localizedDateString];
}


- (NSInteger)listView:(MEListView *)aListView numberOfPostsInSection:(NSInteger)aSection
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


- (MEPost *)listView:(MEListView *)aListView postAtIndexPath:(NSIndexPath *)aIndexPath
{
    return [self postForIndexPath:aIndexPath];
}


#pragma mark -
#pragma mark MEListViewDelegate


- (void)listViewDidTapNewPostButton:(MEListView *)aListView
{
    UIViewController *sViewController;

    sViewController = [[MEPostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
    [self presentModalViewController:sViewController animated:YES];
    [sViewController release];
}


- (void)listViewDidTapFetchMoreButton:(MEListView *)aListView
{
    [self fetchFromOffset:mMoreOffset count:[MESettings moreFetchCount]];
}


- (void)listView:(MEListView *)aListView didTapUserInfoButtonForUser:(MEUser *)aUser
{
    UIActionSheet *sActionSheet;

    sActionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Dear %@", @""), [aUser nickname]] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Visit me2DAY", @""), nil];

    [sActionSheet showInView:[[self view] window]];
    [sActionSheet release];

    mTappedUser = aUser;
}


- (void)listView:(MEListView *)aListView didTapPostIconButtonForPost:(MEPost *)aPost
{
    NSURL *sPhotoURL = [aPost photoURL];

    if (sPhotoURL)
    {
        [mMediaView setPhotoURL:sPhotoURL];
        [[[self view] window] addSubview:mMediaView];
    }
}


- (void)listView:(MEListView *)aListView didSelectPostAtIndexPath:(NSIndexPath *)aIndexPath
{
    MEReadViewController *sReadViewController;

    sReadViewController = [[MEReadViewController alloc] initWithPost:[self postForIndexPath:aIndexPath]];
    [[self navigationController] pushViewController:sReadViewController animated:YES];
    [sReadViewController release];
}


#pragma mark -
#pragma mark UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)aActionSheet didDismissWithButtonIndex:(NSInteger)aButtonIndex
{
    if (mTappedUser && (aButtonIndex != [aActionSheet cancelButtonIndex]))
    {
        MELink *sLink;

        sLink = [(MELink *)[MELink alloc] initWithUser:mTappedUser];
        [[MEVisitsViewController sharedController] visitLink:sLink];
        [sLink release];
    }

    mTappedUser = nil;
}


#pragma mark -
#pragma mark Observing Notifications


- (void)todayDidChange:(NSNotification *)aNotification
{
    [mListView reloadData];
}


@end
