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
#import "MEAttributedString.h"
#import "MEAttributedLabel.h"
#import "MEImageView.h"
#import "METableViewCellFactory.h"
#import "MEPostBodyView.h"
#import "MEAddCommentViewController.h"
#import "MERoundBackView.h"
#import "MELinkTableViewCell.h"


@interface MEReplyViewController (Privates)

- (void)getComments;

@end


@implementation MEReplyViewController (Privates)


- (void)getComments
{
    MEClient *sClient = [MEClientStore currentClient];
    [sClient getCommentsWithPostID:[mPost postID] delegate:self];
//    [sClient getCommentsWithPostID:@"http://me2day.net/killk/2009/04/08#15:22:32" delegate:self];
}


@end


@implementation MEReplyViewController


#pragma mark -
#pragma mark properties


@synthesize post = mPost;


#pragma mark -


- (void)dealloc
{
    [mNaviBar release];
    [mContainerView release];
    [mIconView release];
    [mPostBodyView release];
    [mPostScrollView release];
    [mTableView release];
    [mReplyButtonItem release];

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
    NSString         *sNickname = [[mPost author] nickname];
    UINavigationItem *sTopItem  = [mNaviBar topItem];
    NSString         *sTitleStr = [NSString stringWithFormat:NSLocalizedString(@"%@'s Post", @""), sNickname];

    [super viewDidLoad];

    mComments = [[NSMutableArray alloc] init];

    [sTopItem        setTitle:sTitleStr];
    [mIconView       setBorderColor:[UIColor lightGrayColor]];
    [mIconView       setImageWithURL:[mPost iconURL]];
    [mPostBodyView   setShowsPostDate:YES];
    [mPostBodyView   setPost:mPost];
    [mPostBodyView   sizeToFit];

    [mPostScrollView setContentSize:[mPostBodyView frame].size];
    [mTableView      setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mTableView      setRowHeight:1000.0];

    CGFloat sHeight = [mPostBodyView frame].size.height + kPostCellBodyPadding * 2;
    [mContainerView setFrame:CGRectMake(0, 0, 320, sHeight)];
    [mTableView setTableHeaderView:mContainerView];

    [mReplyButtonItem setEnabled:![mPost isCommentClosed]];
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    [self getComments];
}


#pragma mark -
#pragma mark Actions


- (IBAction)addCommentButtonTapped:(id)aSender
{
    MEAddCommentViewController *sViewController;

    sViewController = [[MEAddCommentViewController alloc] initWithNibName:@"AddCommentViewController" bundle:nil];
    [sViewController setPost:mPost];
    [self presentModalViewController:sViewController animated:YES];
    [sViewController release];
}


- (IBAction)closeButtonTapped:(id)aSender
{
    [[self parentViewController] dismissModalViewControllerAnimated:NO];
}


#pragma mark -
#pragma mark MEClient Delegate


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


@end
