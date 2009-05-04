/*
 *  MEReplyViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 30.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

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


- (void)viewDidLoad
{
    NSString         *sNickname = [[mPost author] nickname];
    UINavigationItem *sTopItem  = [mNaviBar topItem];
    NSString         *sTitleStr = [NSString stringWithFormat:NSLocalizedString(@"%@님의 글", nil), sNickname];
    
    [super viewDidLoad];

    mComments = [[NSMutableArray alloc] init];
    
    [sTopItem        setTitle:sTitleStr];
    [mIconView       setImageWithURL:[mPost iconURL]];
    [mPostBodyView   setPost:mPost];
    [mPostBodyView   layoutIfNeeded];
    [mPostScrollView setContentSize:[mPostBodyView frame].size];
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    [self getComments];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    NSLog(@"MEReplyViewController dealloc");

    [mPost     release];
    [mComments release];

    [super dealloc];
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
//    [[self view] removeFromSuperview];
//    [self autorelease];
}


#pragma mark -
#pragma mark MEClient Delegate


- (void)client:(MEClient *)aClient didGetComments:(NSArray *)aComments error:(NSError *)aError
{
    if (!aError)
    {
        [mComments removeAllObjects];
        [mComments addObjectsFromArray:aComments];
        [mTableView reloadData];
    }
    else
    {

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


#define kCommentTextWidth   240
#define kFaceImageSize      44


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell    *sResult    = nil;
    MEAttributedLabel  *sBodyLabel;
    UIView             *sFrame;
    MEImageView        *sImageView;
    MEComment          *sComment   = [mComments objectAtIndex:[aIndexPath row]];
    MEAttributedString *sBody      = [sComment body];
    MEUser             *sUser      = [sComment author];
    NSURL              *sFaceImage = [sUser faceImageURL];
    MEUser             *sPostOwner = [mPost author];
    BOOL                sIsSameUser;
    CGRect              sTextRect;
    CGRect              sImageRect;
    CGRect              sFrameRect;

    sIsSameUser = (sUser == sPostOwner) ? YES : NO;

    sResult    = [METableViewCellFactory commentCellForTableView:aTableView];
    sBodyLabel = (MEAttributedLabel *)[[sResult contentView] viewWithTag:kCommentCellBodyLabelTag];
    sImageView = (MEImageView *)[[sResult contentView] viewWithTag:kCommentCellFaceImageViewTag];
    sFrame     = (UIView *)[[sResult contentView] viewWithTag:kCommentCellFrameViewTag];

    if (sIsSameUser)
    {
        sTextRect  = CGRectMake(10, 10, kCommentTextWidth, 0);
        sImageRect = CGRectMake(266, 10, kFaceImageSize, kFaceImageSize);
    }
    else
    {
        sTextRect = CGRectMake(70, 10, kCommentTextWidth, 0);
        sImageRect = CGRectMake(10, 10, kFaceImageSize, kFaceImageSize);
    }

    [sBodyLabel setFrame:sTextRect];
    [sBodyLabel setAttributedText:sBody];
    [sBodyLabel sizeToFit];

    [sImageView setFrame:sImageRect];
    [sImageView setImageWithURL:sFaceImage];

    sFrameRect = sImageRect;
    sFrameRect.origin.x    -= 1;
    sFrameRect.origin.y    -= 1;
    sFrameRect.size.width  += 2;
    sFrameRect.size.height += 2;
    [sFrame setFrame:sFrameRect];

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
    sSize    = [sCommentStr sizeForWidth:240];
    sResult += (sSize.height > kFaceImageSize) ? sSize.height : kFaceImageSize;
    sResult += 10;

    return sResult;
}


@end
