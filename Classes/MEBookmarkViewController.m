/*
 *  MEBookmarkViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 16.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MEBookmarkViewController.h"
#import "MEListViewController.h"
#import "MEReadViewController.h"
#import "METableViewCellFactory.h"
#import "MEBookmarkTableViewCell.h"
#import "MESettings.h"
#import "MEUser.h"
#import "MEBookmark.h"


@interface MEBookmarkViewController (Private)
@end

@implementation MEBookmarkViewController (Private)

- (void)layoutViews
{
    CGRect  sRect;
    CGFloat sHeight;

    [mNavigationBar sizeToFit];

    sRect   = [[self view] bounds];
    sHeight = [mNavigationBar frame].size.height;

    sRect.origin.y    += sHeight;
    sRect.size.height -= sHeight;

    [mTableView setFrame:sRect];
}

@end


@implementation MEBookmarkViewController

@synthesize navigationBar = mNavigationBar;
@synthesize closeButton   = mCloseButton;
@synthesize editButton    = mEditButton;
@synthesize tableView     = mTableView;


- (id)init
{
    self = [super initWithNibName:@"BookmarkView" bundle:nil];

    if (self)
    {
    }

    return self;
}

- (void)dealloc
{
    [mCloseButton release];
    [mEditButton release];
    [mSaveButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    /*
     *  do nothing
     */
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self layoutViews];

    mSaveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStyleDone target:self action:@selector(save)];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    [self layoutViews];
}


- (IBAction)close
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)edit
{
    [[mNavigationBar topItem] setLeftBarButtonItem:nil animated:YES];
    [[mNavigationBar topItem] setRightBarButtonItem:mSaveButton animated:YES];

    [mTableView setEditing:YES animated:YES];
}

- (IBAction)save
{
    [[mNavigationBar topItem] setLeftBarButtonItem:mCloseButton animated:YES];
    [[mNavigationBar topItem] setRightBarButtonItem:mEditButton animated:YES];

    [mTableView setEditing:NO animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    if (aSection)
    {
        return [[MESettings bookmarks] count];
    }
    else
    {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    static NSString *sDefaultTitle[] = {
        @"%@'s me2DAY",
        @"%@'s All Friends",
        @"%@'s Best Friends",
        @"%@'s Following Friends",
    };

    UITableViewCell *sCell;

    if ([aIndexPath section])
    {
        sCell = [MEBookmarkTableViewCell cellForTableView:mTableView];

        [(MEBookmarkTableViewCell *)sCell setBookmark:[[MESettings bookmarks] objectAtIndex:[aIndexPath row]]];
    }
    else
    {
        sCell = [METableViewCellFactory defaultCellForTableView:mTableView];

        [[sCell textLabel] setText:[NSString stringWithFormat:NSLocalizedString(sDefaultTitle[[aIndexPath row]], @""), [[MEUser currentUser] nickname]]];
    }

    return sCell;
}


- (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    return [aIndexPath section] ? YES : NO;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)aEditingStyle forRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    if (aEditingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *sBookmarks;

        sBookmarks = [[MESettings bookmarks] mutableCopy];
        [sBookmarks removeObjectAtIndex:[aIndexPath row]];
        [MESettings setBookmarks:sBookmarks];
        [sBookmarks release];

        [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:aIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (BOOL)tableView:(UITableView *)aTableView canMoveRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    return [aIndexPath section] ? YES : NO;
}

- (void)tableView:(UITableView *)aTableView moveRowAtIndexPath:(NSIndexPath *)aFromIndexPath toIndexPath:(NSIndexPath *)aToIndexPath
{
    NSMutableArray *sBookmarks;
    MEBookmark     *sBookmark;
    NSUInteger      sFromIndex;
    NSUInteger      sToIndex;

    sFromIndex = [aFromIndexPath row];
    sToIndex   = [aToIndexPath row];

    if (sFromIndex != sToIndex)
    {
        sBookmarks = [[MESettings bookmarks] mutableCopy];
        sBookmark  = [sBookmarks objectAtIndex:sFromIndex];

        [sBookmark retain];
        [sBookmarks removeObjectAtIndex:sFromIndex];
        [sBookmarks insertObject:sBookmark atIndex:sToIndex];
        [sBookmark release];

        [MESettings setBookmarks:sBookmarks];
        [sBookmarks release];
    }
}


#pragma mark -
#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    static MEClientGetPostsScope sScope[] = {
        kMEClientGetPostsScopeAll,
        kMEClientGetPostsScopeFriendAll,
        kMEClientGetPostsScopeFriendBest,
        kMEClientGetPostsScopeFriendFollowing,
    };

    UIViewController *sViewController;
    MEBookmark       *sBookmark;

    if ([aIndexPath section])
    {
        sBookmark = [[MESettings bookmarks] objectAtIndex:[aIndexPath row]];

        if ([sBookmark postID])
        {
            sViewController = [[MEReadViewController alloc] initWithPostID:[sBookmark postID]];
        }
        else
        {
            sViewController = [[MEListViewController alloc] initWithUserID:[sBookmark userID] scope:kMEClientGetPostsScopeAll];
        }
    }
    else
    {
        sViewController = [[MEListViewController alloc] initWithUser:[MEUser currentUser] scope:sScope[[aIndexPath row]]];
    }

    [(UINavigationController *)[self parentViewController] pushViewController:sViewController animated:NO];
    [self dismissModalViewControllerAnimated:YES];

    [sViewController release];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    if ([aIndexPath section])
    {
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
}

- (NSString *)tableView:(UITableView *)aTableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    return NSLocalizedString(@"Delete", @"");
}


- (NSIndexPath *)tableView:(UITableView *)aTableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)aIndexPath toProposedIndexPath:(NSIndexPath *)aProposedIndexPath
{
    if ([aProposedIndexPath section])
    {
        return aProposedIndexPath;
    }
    else
    {
        return [NSIndexPath indexPathForRow:0 inSection:1];
    }
}


@end
