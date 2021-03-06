/*
 *  MEReadViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 30.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "UIAlertView+MEAdditions.h"
#import "MEReadViewController.h"
#import "MEListViewController.h"
#import "MEWriteViewController.h"
#import "MEReplyViewController.h"
#import "MEPhotoViewController.h"
#import "MEWebViewController.h"
#import "MEAttributedString.h"
#import "MEAttributedLabel.h"
#import "MEImageView.h"
#import "MEImageButton.h"
#import "MEPostBodyView.h"
#import "MEPostTableViewCell.h"
#import "MECommentTableViewCell.h"
#import "MELinkTableViewCell.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MESettings.h"
#import "MEPost.h"
#import "MEUser.h"
#import "MEComment.h"
#import "MELink.h"
#import "MEBookmark.h"


static NSDictionary *gActions = nil;


@interface MEReadViewController (Privates)
@end


@implementation MEReadViewController (Privates)


- (BOOL)canBookmark
{
    MEBookmark *sBookmark;
    BOOL        sResult;

    sBookmark = [[MEBookmark alloc] initWithPostID:mPostID];
    sResult   = ![[MESettings bookmarks] containsObject:sBookmark];

    [sBookmark release];

    return sResult;
}


- (void)setupNavigationItem
{
    mReloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getPost)];
    [mReloadButton setEnabled:NO];
    [[self navigationItem] setRightBarButtonItem:mReloadButton];
    [mReloadButton release];
}


- (void)setMetooToolbarItemEnabled:(BOOL)aEnabled
{
    UIBarButtonItem *sItem;

    for (sItem in [self toolbarItems])
    {
        if ([sItem action] == @selector(metoo))
        {
            [sItem setEnabled:aEnabled];
        }
    }
}

- (void)setupToolbarItems
{
    if ([self toolbarItems])
    {
        UIBarButtonItem *sItem;

        for (sItem in [self toolbarItems])
        {
            if ([sItem action] == @selector(addBookmark))
            {
                [sItem setEnabled:[self canBookmark]];
            }

            if ([sItem action] == @selector(composePost))
            {
                [sItem setEnabled:YES];
            }

            if ([sItem action] == @selector(composeReply))
            {
                [sItem setEnabled:YES];
            }
        }
    }
    else
    {
        NSMutableArray  *sItems = [NSMutableArray array];
        UIBarButtonItem *sItem;

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

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composePost)];
        [sItem setEnabled:NO];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(composeReply)];
        [sItem setEnabled:NO];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"metoo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(metoo)];
        [sItem setImageInsets:UIEdgeInsetsMake(2, 0, -2, 0)];
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


- (void)getPost
{
    [mReloadButton setEnabled:NO];
    [[MEClientStore currentClient] getPostWithPostID:mPostID delegate:self];
}

- (void)getComments
{
    [[MEClientStore currentClient] getCommentsWithPostID:[mPost postID] delegate:self];
}


- (void)showPost
{
    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@'s Post", @""), [[mPost author] nickname]]];

    if ([mPost photoURL])
    {
        [mIconButton addTarget:self action:@selector(iconButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }

    [mIconButton setImageWithURL:[mPost iconURL]];
    [mPostBodyView setPost:mPost];

    [mPostBodyView sizeToFit];
    [mHeaderView setFrame:CGRectMake(0, 0, [mHeaderView frame].size.width, [mPostBodyView frame].size.height + kPostCellBodyTopPadding * 2 + 2)];

    [mTableView setTableHeaderView:mHeaderView];

    [self setupToolbarItems];
    [self setMetooToolbarItemEnabled:![[[mPost author] userID] isEqualToString:[[MEClientStore currentClient] userID]]];
}


@end


@implementation MEReadViewController


@synthesize headerView   = mHeaderView;
@synthesize iconButton   = mIconButton;
@synthesize postBodyView = mPostBodyView;
@synthesize tableView    = mTableView;


#pragma mark -


+ (void)initialize
{
    if (!gActions)
    {
        gActions = [[NSDictionary alloc] initWithObjectsAndKeys:@"write", NSLocalizedString(@"write", @""), @"writeCall", NSLocalizedString(@"writeCall", @""), @"pingback", NSLocalizedString(@"pingback", @""), @"reply", NSLocalizedString(@"reply", @""), @"replyCall", NSLocalizedString(@"replyCall", @""), nil];
    }
}


#pragma mark -


- (id)initWithPost:(MEPost *)aPost
{
    self = [super initWithNibName:@"ReadView" bundle:nil];

    if (self)
    {
        mPostID   = [[aPost postID] copy];
        mPost     = [aPost retain];
        mComments = [[NSMutableArray alloc] init];

        [self setupNavigationItem];
        [self setupToolbarItems];
    }

    return self;
}

- (id)initWithPostID:(NSString *)aPostID
{
    self = [super initWithNibName:@"ReadView" bundle:nil];

    if (self)
    {
        mPostID   = [aPostID copy];
        mComments = [[NSMutableArray alloc] init];

        [self setupToolbarItems];
        [self setupNavigationItem];
    }

    return self;
}

- (void)dealloc
{
    [mPostID release];
    [mPost release];
    [mComments release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [mIconButton setBorderColor:[UIColor lightGrayColor]];
    [mPostBodyView setBackgroundColor:[UIColor clearColor]];
    [mPostBodyView setShowsPostDate:YES];

    [mTableView setTableHeaderView:mHeaderView];
    [mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mTableView setRowHeight:1000.0];

    if (mPost)
    {
        [self showPost];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    mHeaderView   = nil;
    mIconButton   = nil;
    mPostBodyView = nil;
    mTableView    = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [mTableView deselectRowAtIndexPath:[mTableView indexPathForSelectedRow] animated:YES];

    [self setupToolbarItems];

    if (mPost)
    {
        [self getComments];
    }
    else
    {
        [self getPost];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [mTableView reloadData];
}


#pragma mark -
#pragma mark Actions


- (void)faceImageButtonTapped:(id)aSender
{
    MEUser           *sUser;
    UIViewController *sViewController;

    sUser           = [(MEImageButton *)aSender userInfo];
    sViewController = [[MEListViewController alloc] initWithUser:sUser scope:kMEClientGetPostsScopeAll];

    [[self navigationController] pushViewController:sViewController animated:YES];
    [sViewController release];
}


- (void)iconButtonTapped:(id)aSender
{
    UIViewController *sViewController;
    NSURL            *sPhotoURL;

    sPhotoURL = [mPost photoURL];

    if (sPhotoURL)
    {
        sViewController = [[MEPhotoViewController alloc] initWithPost:mPost];
        [self presentModalViewController:sViewController animated:YES];
        [sViewController release];
    }
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

    sViewController = [[MEWriteViewController alloc] initWithCallUserID:[[mPost author] userID]];
    [self presentModalViewController:sViewController animated:YES];
    [sViewController release];
}

- (void)pingback
{
    UIViewController *sViewController;

    sViewController = [[MEWriteViewController alloc] initWithPingbackLink:[mPost permLink]];
    [self presentModalViewController:sViewController animated:YES];
    [sViewController release];
}

- (void)reply
{
    MEReplyViewController *sViewController;

    sViewController = [[MEReplyViewController alloc] initWithPostID:[mPost postID]];
    [self presentModalViewController:sViewController animated:YES];
    [sViewController release];
}

- (void)replyCall
{
    MEReplyViewController *sViewController;
    NSIndexPath           *sIndexPath;

    sIndexPath = [mTableView indexPathForSelectedRow];

    if (sIndexPath)
    {
        NSString *sUserID = [[[mComments objectAtIndex:([sIndexPath section] - 1)] author] userID];

        sViewController = [[MEReplyViewController alloc] initWithPostID:[mPost postID] callUserID:sUserID];
        [self presentModalViewController:sViewController animated:YES];
        [sViewController release];
    }
    else
    {
        sViewController = [[MEReplyViewController alloc] initWithPostID:[mPost postID] callUserID:[[mPost author] userID]];
        [self presentModalViewController:sViewController animated:YES];
        [sViewController release];
    }
}


- (void)addBookmark
{
    NSMutableArray *sBookmarks;
    MEBookmark     *sBookmark;

    sBookmarks = [[MESettings bookmarks] mutableCopy];
    sBookmark = [[MEBookmark alloc] initWithPost:mPost];

    if (![sBookmarks containsObject:sBookmark])
    {
        [sBookmarks insertObject:sBookmark atIndex:0];
    }

    [MESettings setBookmarks:sBookmarks];
    [sBookmarks release];

    [self setupToolbarItems];
}


- (void)composePost
{
    UIActionSheet *sActionSheet;

    sActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"write", @""), NSLocalizedString(@"writeCall", @""), NSLocalizedString(@"pingback", @""), nil];

    [sActionSheet showFromToolbar:[[self navigationController] toolbar]];
    [sActionSheet release];
}


- (void)composeReply
{
    if ([[[mPost author] userID] isEqualToString:[[MEClientStore currentClient] userID]])
    {
        [self reply];
    }
    else
    {
        UIActionSheet *sActionSheet;

        sActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"replyCall", @""), NSLocalizedString(@"reply", @""), nil];

        [sActionSheet showFromToolbar:[[self navigationController] toolbar]];
        [sActionSheet release];
    }
}


- (void)metoo
{
    [[MEClientStore currentClient] metooWithPostID:[mPost postID] delegate:self];

    [self setMetooToolbarItemEnabled:NO];
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPosts:(NSArray *)aPosts error:(NSError *)aError
{
    if (aError)
    {
        [UIAlertView showError:aError];
    }
    else
    {
        mPost = [[aPosts objectAtIndex:0] retain];

        [self showPost];
        [self getComments];
    }
}


- (void)client:(MEClient *)aClient didGetComments:(NSArray *)aComments error:(NSError *)aError
{
    [mReloadButton setEnabled:YES];

    if (aError)
    {
        [UIAlertView showError:aError];
    }
    else
    {
        [mComments removeAllObjects];
        [mComments addObjectsFromArray:aComments];
        [mPost setCommentsCount:[mComments count]];
        [mTableView reloadData];
    }
}


- (void)client:(MEClient *)aClient didMetooWithError:(NSError *)aError;
{
    if (aError)
    {
        [UIAlertView showError:aError];
    }
    else
    {
        [UIAlertView showAlert:NSLocalizedString(@"metoo success", @"")];
        [mPost setMetooCount:([mPost metooCount] + 1)];
    }

    [self setMetooToolbarItemEnabled:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    [mHeaderView setFrame:CGRectMake(0, 0, [mHeaderView frame].size.width, [mPostBodyView frame].size.height + kPostCellBodyTopPadding * 2 + 2)];

    [mTableView setTableHeaderView:mHeaderView];

    return [mComments count] + 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    if (aSection)
    {
        return [[[mComments objectAtIndex:(aSection - 1)] links] count] + 1;
    }
    else
    {
        return [[mPost links] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sCell;
    NSUInteger       sSection = [aIndexPath section];
    NSUInteger       sRow     = [aIndexPath row];

    if (sSection)
    {
        MEComment  *sComment;

        sSection -= 1;
        sComment  = [mComments objectAtIndex:sSection];

        if (sRow)
        {
            sCell = [MELinkTableViewCell cellForTableView:aTableView];

            [(MELinkTableViewCell *)sCell setLink:[[sComment links] objectAtIndex:(sRow - 1)]];
        }
        else
        {
            UIColor *sColor;

            sColor   = ((sSection % 2) == 1) ? [UIColor whiteColor] : [UIColor colorWithWhite:0.95 alpha:1.0];
            sCell    = [MECommentTableViewCell cellForTableView:aTableView withTarget:self];

            [(MECommentTableViewCell *)sCell setComment:sComment];
            [[sCell contentView] setBackgroundColor:sColor];

            if ([[[sComment author] userID] isEqualToString:[[MEClientStore currentClient] userID]])
            {
                [sCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            else
            {
                [sCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            }
        }
    }
    else
    {
        sCell = [MELinkTableViewCell cellForTableView:aTableView];

        [(MELinkTableViewCell *)sCell setLink:[[mPost links] objectAtIndex:sRow]];
    }

    return sCell;
}


#pragma mark -
#pragma mark UITableViewDelegate


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    NSUInteger sSection = [aIndexPath section];

    if (sSection)
    {
        if ([aIndexPath row])
        {
            return 35;
        }
        else
        {
            MEComment          *sComment    = [mComments objectAtIndex:(sSection - 1)];
            MEAttributedString *sCommentStr = [sComment body];
            CGFloat             sHeight;

            sHeight = [sCommentStr sizeForWidth:([aTableView bounds].size.width - kCommentBodyLeftPadding)].height + 14;
            sHeight = ((sHeight > kIconImageSize) ? sHeight : kIconImageSize) + 14;

            return sHeight;
        }
    }
    else
    {
        return 35;
    }
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    MELink     *sLink;
    NSUInteger  sSection = [aIndexPath section];
    NSUInteger  sRow     = [aIndexPath row];

    if (sSection)
    {
        MEComment *sComment = [mComments objectAtIndex:(sSection - 1)];

        if (sRow)
        {
            sLink = [[sComment links] objectAtIndex:(sRow - 1)];
        }
        else
        {
            sLink = nil;

            if (![[[sComment author] userID] isEqualToString:[[MEClientStore currentClient] userID]])
            {
                UIActionSheet *sActionSheet;

                sActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"replyCall", @""), nil];

                [sActionSheet showFromToolbar:[[self navigationController] toolbar]];
                [sActionSheet release];
            }
        }
    }
    else
    {
        sLink = [[mPost links] objectAtIndex:sRow];
    }

    if (sLink)
    {
        UIViewController *sViewController;

        switch ([sLink type])
        {
            case kMELinkTypeMe2DAY:
                sViewController = [[MEListViewController alloc] initWithUserID:[sLink url] scope:kMEClientGetPostsScopeAll];
                break;

            case kMELinkTypePost:
                sViewController = [[MEReadViewController alloc] initWithPostID:[sLink url]];
                break;

            case kMELinkTypeOther:
                sViewController = [[MEWebViewController alloc] initWithURL:[sLink url]];
                break;

            default:
                sViewController = nil;
                break;
        }

        [[self navigationController] pushViewController:sViewController animated:YES];
        [sViewController release];
    }
}


#pragma mark -
#pragma mark UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)aActionSheet didDismissWithButtonIndex:(NSInteger)aButtonIndex
{
    if (aButtonIndex == [aActionSheet cancelButtonIndex])
    {
        [mTableView deselectRowAtIndexPath:[mTableView indexPathForSelectedRow] animated:YES];
    }
    else
    {
        SEL sSelector = NSSelectorFromString([gActions objectForKey:[aActionSheet buttonTitleAtIndex:aButtonIndex]]);

        if (sSelector)
        {
            [self performSelector:sSelector];
        }
    }
}


@end
