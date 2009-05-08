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
    NSLog(@"MEReplyViewController dealloc");

    [mPost     release];
    [mComments release];

    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    NSString         *sNickname = [[mPost author] nickname];
    UINavigationItem *sTopItem  = [mNaviBar topItem];
    NSString         *sTitleStr = [NSString stringWithFormat:NSLocalizedString(@"%@님의 글", nil), sNickname];

    [super viewDidLoad];

    mComments = [[NSMutableArray alloc] init];

    [sTopItem        setTitle:sTitleStr];
    [mIconView       setBorderColor:[UIColor lightGrayColor]];
    [mIconView       setImageWithURL:[mPost iconURL]];
    [mPostBodyView   setPost:mPost];
    [mPostBodyView   sizeToFit];

    [mPostScrollView setContentSize:[mPostBodyView frame].size];
    [mTableView      setRowHeight:1000.0];

    CGFloat sHeight = [mPostBodyView frame].size.height + kPostCellBodyPadding * 2;
    [mContainerView setFrame:CGRectMake(0, 0, 320, sHeight)];
    [mTableView setTableHeaderView:mContainerView];
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    return [mComments count];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sResult  = nil;
    MEComment       *sComment = [mComments objectAtIndex:[aIndexPath row]];

    sResult = [METableViewCellFactory commentCellForTableView:aTableView];

    [sResult setComment:sComment isOwners:(([sComment author] == [mPost author]) ? YES : NO)];

    return sResult;
}


#pragma mark -
#pragma mark TableView Delegate


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    CGFloat             sResult     = 0;
    MEComment          *sComment    = [mComments objectAtIndex:[aIndexPath row]];
    MEAttributedString *sCommentStr = [sComment body];
    CGSize              sSize;

    sResult  = 10;
    sSize    = [sCommentStr sizeForWidth:kCommentBodyWidth];
    sResult += (sSize.height > kIconImageSize) ? sSize.height : kIconImageSize;
    sResult += 10;

    return sResult;
}


@end
