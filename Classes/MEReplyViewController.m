/*
 *  MEReplyViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 30.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIAlertView+MEAdditions.h"
#import "MEReplyViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEPost.h"
#import "MEUser.h"
#import "MEComment.h"
#import "MELink.h"
#import "MEAttributedString.h"
#import "MEAttributedLabel.h"
#import "MEImageView.h"
#import "METableViewCellFactory.h"
#import "MEPostBodyView.h"
#import "MEAddCommentViewController.h"
#import "MEVisitsViewController.h"
#import "MERoundBackView.h"
#import "MELinkTableViewCell.h"


@interface MEReplyViewController (Privates)
@end


@implementation MEReplyViewController (Privates)


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
    [[mNaviBar topItem] setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@'s Post", @""), [[mPost author] nickname]]];

    [mIconView setImageWithURL:[mPost iconURL]];
    [mPostBodyView setPost:mPost];
    [mPostBodyView sizeToFit];
    [mPostScrollView setContentSize:[mPostBodyView frame].size];
    [mContainerView setFrame:CGRectMake(0, 0, 320, [mPostBodyView frame].size.height + kPostCellBodyPadding * 2)];

    [mTableView setTableHeaderView:mContainerView];

    [mActionButtonItem setEnabled:YES];
}


- (void)addComment
{
    MEAddCommentViewController *sViewController;

    sViewController = [[MEAddCommentViewController alloc] initWithNibName:@"AddCommentViewController" bundle:nil];
    [sViewController setPost:mPost];
    [self presentModalViewController:sViewController animated:YES];
    [sViewController release];
}


- (void)addMetoo
{
    MEClient *sClient = [MEClientStore currentClient];
    [sClient metooWithPostID:[mPost postID] delegate:self];
}


@end


@implementation MEReplyViewController


#pragma mark -


- (id)initWithPost:(MEPost *)aPost
{
    self = [super initWithNibName:@"MEReplyViewController" bundle:nil];

    if (self)
    {
        mPost     = [aPost retain];
        mComments = [[NSMutableArray alloc] init];
    }

    return self;
}


- (id)initWithPostID:(NSString *)aPostID
{
    self = [super initWithNibName:@"MEReplyViewController" bundle:nil];

    if (self)
    {
        mPostID   = [aPostID copy];
        mComments = [[NSMutableArray alloc] init];
    }

    return self;
}


- (void)dealloc
{
    [mNaviBar release];
    [mContainerView release];
    [mIconView release];
    [mPostBodyView release];
    [mPostScrollView release];
    [mTableView release];
    [mActionButtonItem release];

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

    [mIconView setBorderColor:[UIColor lightGrayColor]];
    [mPostBodyView setShowsPostDate:YES];

    [mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mTableView setRowHeight:1000.0];

    if (mPost && ![mTableView tableHeaderView])
    {
        [self showPost];
    }
    else
    {
        [mActionButtonItem setEnabled:NO];
    }
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    if (mPost)
    {
        [self getComments];
    }
    else
    {
        [self getPost];
    }
}


#pragma mark -
#pragma mark Actions


- (IBAction)actionButtonTapped:(id)aSender
{
    UIActionSheet *sActionSheet = nil;
    BOOL           sIsCommentClosed = [mPost isCommentClosed];

    if (!sIsCommentClosed)
    {
        sActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"To This Post", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"Add Metoo", nil), NSLocalizedString(@"Add Comment", nil), nil];
        mAddMetooIndex   = 0;
        mAddCommentIndex = 1;
        mCancelIndex     = 2;
    }
    else
    {
        sActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"To This Post", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"Add Metoo", nil), nil];
        mAddMetooIndex   = 0;
        mAddCommentIndex = -1;
        mCancelIndex     = 1;
    }

    [sActionSheet showInView:[[self view] window]];
    [sActionSheet release];
}


- (IBAction)closeButtonTapped:(id)aSender
{
    [[self navigationController] popViewControllerAnimated:YES];
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
        [mTableView reloadData];
    }
}


- (void)client:(MEClient *)aClient didMetooWithError:(NSError *)aError;
{
    if (aError)
    {
        [UIAlertView showError:aError];
    }
}


#pragma mark -
#pragma mark TableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
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
            sCell    = [METableViewCellFactory commentCellForTableView:aTableView];

            [sCell setComment:sComment isOwners:(([sComment author] == [mPost author]) ? YES : NO)];
            [sCell setCommentBackgroundColor:sColor];
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
            CGSize              sSize;
            CGFloat             sHeight;

            sHeight       = 10;
            sSize         = [sCommentStr sizeForWidth:kCommentBodyWidth];
            sSize.height += 14;
            sHeight      += (sSize.height > kIconImageSize) ? sSize.height : kIconImageSize;
            sHeight      += 10;

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

    [[MEVisitsViewController sharedController] visitLink:sLink];
    [aTableView deselectRowAtIndexPath:aIndexPath animated:YES];
}


#pragma mark -
#pragma mark UIActionSheet Delegate


- (void)actionSheet:(UIActionSheet *)aActionSheet didDismissWithButtonIndex:(NSInteger)aButtonIndex
{
    if (aButtonIndex == mAddCommentIndex)
    {
        [self addComment];
    }
    else if (aButtonIndex == mAddMetooIndex)
    {
        [self addMetoo];
    }
    else if (aButtonIndex == mCancelIndex)
    {

    }
}


@end
