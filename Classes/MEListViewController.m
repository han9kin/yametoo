/*
 *  MEListViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 04.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "NSDate+MEAdditions.h"
#import "UIAlertView+MEAdditions.h"
#import "MEListViewController.h"
#import "MEReadViewController.h"
#import "MEWriteViewController.h"
#import "MEPhotoViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MESettings.h"
#import "MEPost.h"
#import "MEUser.h"
#import "MEBookmark.h"


#define kUpdateFetchCount 10


static NSDictionary *gActions = nil;


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


- (BOOL)canBookmark
{
    BOOL sResult;

    if ([mUserID isEqualToString:[[MEClientStore currentClient] userID]])
    {
        sResult = NO;
    }
    else
    {
        if (mScope == kMEClientGetPostsScopeAll)
        {
            MEBookmark *sBookmark = [[MEBookmark alloc] initWithUserID:mUserID];
            sResult = ![[MESettings bookmarks] containsObject:sBookmark];
            [sBookmark release];
        }
        else
        {
            sResult = NO;
        }
    }

    return sResult;
}

- (void)setupTitle
{
    NSString *sName;
    NSString *sTitle;

    if (mUser)
    {
        sName = [mUser nickname];
    }
    else
    {
        sName = mUserID;
    }

    switch (mScope)
    {
        case kMEClientGetPostsScopeAll:
            sTitle = sName;
            break;

        case kMEClientGetPostsScopeFriendAll:
            sTitle = [NSString stringWithFormat:NSLocalizedString(@"%@'s All Friends", @""), sName];
            break;

        case kMEClientGetPostsScopeFriendBest:
            sTitle = [NSString stringWithFormat:NSLocalizedString(@"%@'s Best Friends", @""), sName];
            break;

        case kMEClientGetPostsScopeFriendFollowing:
            sTitle = [NSString stringWithFormat:NSLocalizedString(@"%@'s Following Friends", @""), sName];
            break;

        default:
            sTitle = nil;
    }

    [self setTitle:sTitle];
}

- (void)setupNavigationItem
{
    mReloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
    [mReloadButton setEnabled:NO];
    [[self navigationItem] setRightBarButtonItem:mReloadButton];
    [mReloadButton release];
}

- (void)setupToolbarItems
{
    UIBarButtonItem *sItem;

    if ([self toolbarItems])
    {
        for (sItem in [self toolbarItems])
        {
            if ([sItem action] == @selector(addBookmark))
            {
                [sItem setEnabled:[self canBookmark]];
            }
        }
    }
    else
    {
        NSMutableArray  *sItems = [NSMutableArray array];

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:[[UIApplication sharedApplication] delegate] action:@selector(showBookmarkView)];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookmark)];
        [sItem setEnabled:[self canBookmark]];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose)];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStylePlain target:[[UIApplication sharedApplication] delegate] action:@selector(showSettings)];
        [sItem setImageInsets:UIEdgeInsetsMake(2, 0, -2, 0)];
        [sItems addObject:sItem];
        [sItem release];

        [self setToolbarItems:sItems];
    }
}


- (void)fetchFromOffset:(NSInteger)aOffset count:(NSInteger)aCount
{
    [mReloadButton setEnabled:NO];
    [[MEClientStore currentClient] getPostsWithUserID:mUserID scope:mScope offset:aOffset count:aCount delegate:self];
}


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

    [mListView invalidateData];
    [mListView reloadData];
}

@end


@implementation MEListViewController


@synthesize listView = mListView;


#pragma mark -


+ (void)initialize
{
    if (!gActions)
    {
        gActions = [[NSDictionary alloc] initWithObjectsAndKeys:@"write", NSLocalizedString(@"write", @""), @"writeCall", NSLocalizedString(@"writeCall", @""), nil];
    }
}


#pragma mark -


- (id)initWithUserID:(NSString *)aUserID scope:(MEClientGetPostsScope)aScope
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        mUserID = [aUserID copy];
        mScope  = aScope;
        mPosts  = [[NSMutableArray alloc] init];

        [self setupNavigationItem];
        [self setupToolbarItems];
    }

    return self;
}

- (id)initWithUser:(MEUser *)aUser scope:(MEClientGetPostsScope)aScope
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        mUserID = [[aUser userID] copy];
        mUser   = [aUser userDescription] ? [aUser retain] : nil;
        mScope  = aScope;
        mPosts  = [[NSMutableArray alloc] init];

        [self setupTitle];
        [self setupNavigationItem];
        [self setupToolbarItems];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [mUserID release];
    [mUser release];
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

    mMessageLabel = [[UILabel alloc] initWithFrame:[[self view] bounds]];
    [mMessageLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [mMessageLabel setTextAlignment:UITextAlignmentCenter];
    [mMessageLabel setNumberOfLines:0];
    [[self view] addSubview:mMessageLabel];
    [mMessageLabel release];

    mListView = [[MEListView alloc] initWithFrame:[[self view] bounds]];
    [mListView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [mListView setDataSource:self];
    [mListView setDelegate:self];
    [[self view] addSubview:mListView];
    [mListView release];

    if (mScope == kMEClientGetPostsScopeAll)
    {
        [mListView setAuthor:mUser];
        [mListView setShowsPostAuthor:NO];
    }
    else
    {
        [mListView setShowsPostAuthor:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    mMessageLabel = nil;
    mListView     = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [mListView deselectPostAtIndexPath:[mListView indexPathForSelectedPost] animated:YES];

    if ([mPosts count])
    {
        if ([MESettings couldImplicitFetch])
        {
            mUpdateOffset = 0;
            [self fetchFromOffset:0 count:kUpdateFetchCount];
        }
        else
        {
            [mListView invalidateData];
            [mListView reloadData];
        }
    }
    else
    {
        [self fetchFromOffset:0 count:[MESettings initialFetchCount]];
    }

    [self setupToolbarItems];

    if ([MESettings fetchInterval] > 0)
    {
        mTimer = [NSTimer scheduledTimerWithTimeInterval:([MESettings fetchInterval] * 60) target:self selector:@selector(updateTimerFired:) userInfo:nil repeats:YES];
    }

    if (!mUser)
    {
        [self setupTitle];
        [[MEClientStore currentClient] getPersonWithUserID:mUserID delegate:self];
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation duration:(NSTimeInterval)aDuration
{
    mIndexPath = [[mListView indexPathForTopVisiblePost] copy];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    [mListView invalidateData];
    [mListView reloadData];

    if (mIndexPath)
    {
        [mListView scrollToPostAtIndexPath:mIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [mIndexPath release];
    }
}


#pragma mark -
#pragma mark Actions


- (void)reload
{
    if (mTimer)
    {
        [mTimer invalidate];
        mTimer = [NSTimer scheduledTimerWithTimeInterval:([MESettings fetchInterval] * 60) target:self selector:@selector(updateTimerFired:) userInfo:nil repeats:YES];
    }

    mUpdateOffset = 0;
    [self fetchFromOffset:0 count:kUpdateFetchCount];
}


#pragma mark -
#pragma mark Toolbar Actions


- (void)addBookmark
{
    NSMutableArray *sBookmarks;
    MEBookmark     *sBookmark;

    sBookmarks = [[MESettings bookmarks] mutableCopy];
    sBookmark = [(MEBookmark *)[MEBookmark alloc] initWithUser:mUser];

    if (![sBookmarks containsObject:sBookmark])
    {
        [sBookmarks insertObject:sBookmark atIndex:0];
    }

    [MESettings setBookmarks:sBookmarks];
    [sBookmarks release];

    [self setupToolbarItems];
}

- (void)write
{
    UIViewController *sViewController;

    sViewController = [[MEWriteViewController alloc] init];
    [self presentModalViewController:sViewController animated:YES];
    [sViewController release];
}

- (void)writeCall
{
    UIViewController *sViewController;

    sViewController = [[MEWriteViewController alloc] initWithCallUserID:mUserID];
    [self presentModalViewController:sViewController animated:YES];
    [sViewController release];
}

- (void)compose
{
    if ((mScope == kMEClientGetPostsScopeAll) && ![mUserID isEqualToString:[[MEClientStore currentClient] userID]])
    {
        UIActionSheet *sActionSheet;

        sActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"write", @""), NSLocalizedString(@"writeCall", @""), nil];

        [sActionSheet showFromToolbar:[[self navigationController] toolbar]];
        [sActionSheet release];
    }
    else
    {
        [self write];
    }
}


#pragma mark -
#pragma mark NSTimer Events


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


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    if (aUser)
    {
        mUser = [aUser retain];

        [self setupTitle];
        [mListView setAuthor:aUser];
    }
}


- (void)client:(MEClient *)aClient didGetPosts:(NSArray *)aPosts error:(NSError *)aError
{
    [mReloadButton setEnabled:YES];

    if (aError)
    {
        [UIAlertView showError:aError];
        [mListView reloadData];
    }
    else
    {
        [self addPosts:aPosts];
    }

    if (([mPosts count] == 0) && (mScope != kMEClientGetPostsScopeAll))
    {
        [mListView setHidden:YES];

        switch (mScope)
        {
            case kMEClientGetPostsScopeFriendAll:
                [mMessageLabel setText:NSLocalizedString(@"No Friends Message", @"")];
                break;
            case kMEClientGetPostsScopeFriendBest:
                [mMessageLabel setText:NSLocalizedString(@"No Best Friends Message", @"")];
                break;
            case kMEClientGetPostsScopeFriendFollowing:
                [mMessageLabel setText:NSLocalizedString(@"No Following Friends Message", @"")];
                break;
            default:
                [mMessageLabel setText:NSLocalizedString(@"No Posts Message", @"")];
                break;
        }
    }
    else
    {
        [mListView setHidden:NO];
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


- (void)listViewDidTapFetchMoreButton:(MEListView *)aListView
{
    [self fetchFromOffset:mMoreOffset count:[MESettings moreFetchCount]];
}


- (void)listView:(MEListView *)aListView didTapUserInfoButtonForUser:(MEUser *)aUser
{
    UIViewController *sViewController;

    sViewController = [[MEListViewController alloc] initWithUser:aUser scope:kMEClientGetPostsScopeAll];
    [[self navigationController] pushViewController:sViewController animated:YES];
    [sViewController release];
}


- (void)listView:(MEListView *)aListView didTapPostIconButtonForPost:(MEPost *)aPost
{
    UIViewController *sViewController;
    NSURL            *sPhotoURL;

    sPhotoURL = [aPost photoURL];

    if (sPhotoURL)
    {
        sViewController = [[MEPhotoViewController alloc] initWithPost:aPost];
        [self presentModalViewController:sViewController animated:YES];
        [sViewController release];
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
    if (aButtonIndex != [aActionSheet cancelButtonIndex])
    {
        SEL sSelector = NSSelectorFromString([gActions objectForKey:[aActionSheet buttonTitleAtIndex:aButtonIndex]]);

        if (sSelector)
        {
            [self performSelector:sSelector];
        }
    }
}


#pragma mark -
#pragma mark Observing Notifications


- (void)todayDidChange:(NSNotification *)aNotification
{
    [mListView reloadData];
}


@end
