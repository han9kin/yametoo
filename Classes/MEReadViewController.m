/*
 *  MEReadViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 30.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIAlertView+MEAdditions.h"
#import "MEReadViewController.h"
#import "MEListViewController.h"
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
#import "MEPost.h"
#import "MEUser.h"
#import "MEComment.h"
#import "MELink.h"


@interface MEReadViewController (Privates)
@end


@implementation MEReadViewController (Privates)


- (void)setupToolbarItemsWithMetooEnabled:(BOOL)aMetooEnabled
{
    if ([self toolbarItems])
    {
        UIBarButtonItem *sItem;

        for (sItem in [self toolbarItems])
        {
            if ([sItem action] == @selector(metoo))
            {
                [sItem setEnabled:aMetooEnabled];
            }

            if ([sItem action] == @selector(reply))
            {
                [sItem setEnabled:YES];
            }
        }
    }
    else
    {
        NSMutableArray  *sItems = [NSMutableArray array];
        UIBarButtonItem *sItem;

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"metoo", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(metoo)];
        [sItem setEnabled:aMetooEnabled];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"reply", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(reply)];
        [sItem setEnabled:NO];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        [sItems addObject:sItem];
        [sItem release];

        sItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", @"") style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(showSettings)];
        [sItems addObject:sItem];
        [sItem release];

        [self setToolbarItems:sItems];
    }
}


- (void)getPost
{
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

    [self setupToolbarItemsWithMetooEnabled:![[[mPost author] userID] isEqualToString:[[MEClientStore currentClient] userID]]];
}


@end


@implementation MEReadViewController


@synthesize headerView   = mHeaderView;
@synthesize iconButton   = mIconButton;
@synthesize postBodyView = mPostBodyView;
@synthesize tableView    = mTableView;


#pragma mark -


- (id)initWithPost:(MEPost *)aPost
{
    self = [super initWithNibName:@"ReadView" bundle:nil];

    if (self)
    {
        mPost     = [aPost retain];
        mComments = [[NSMutableArray alloc] init];

        [self setupToolbarItemsWithMetooEnabled:NO];
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

        [self setupToolbarItemsWithMetooEnabled:NO];
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


- (IBAction)metoo
{
    [[MEClientStore currentClient] metooWithPostID:[mPost postID] delegate:self];

    [self setupToolbarItemsWithMetooEnabled:NO];
}


- (IBAction)reply
{
    MEReplyViewController *sViewController;

    sViewController = [[MEReplyViewController alloc] initWithPost:mPost];
    [[self navigationController] pushViewController:sViewController animated:YES];
    [sViewController release];
}


#pragma mark -
#pragma mark MEClient Delegate


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

    [self setupToolbarItemsWithMetooEnabled:YES];
}


#pragma mark -
#pragma mark TableView DataSource


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
#pragma mark TableView Delegate


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
        if (sRow)
        {
            sLink = [[[mComments objectAtIndex:(sSection - 1)] links] objectAtIndex:(sRow - 1)];
        }
        else
        {
            sLink = nil;
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


@end
