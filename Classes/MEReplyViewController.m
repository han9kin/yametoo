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
    [super viewDidLoad];
    
    mComments = [[NSMutableArray alloc] init];
    
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


- (IBAction)closeButtonTapped:(id)aSender
{
    [[self view] removeFromSuperview];
    [self autorelease];
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


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell    *sResult    = nil;
    MEAttributedLabel  *sBodyLabel;
    MEImageView        *sImageView;
    MEComment          *sComment   = [mComments objectAtIndex:[aIndexPath row]];
    MEAttributedString *sBody      = [sComment body];
    MEUser             *sUser      = [sComment author];
    NSURL              *sFaceImage = [sUser faceImageURL];
    
    sResult    = [METableViewCellFactory commentCellForTableView:aTableView];
    sBodyLabel = (MEAttributedLabel *)[[sResult contentView] viewWithTag:kCommentCellBodyLabelTag];
    sImageView = (MEImageView *)[[sResult contentView] viewWithTag:kCommentCellFaceImageViewTag];
    
    [sBodyLabel setFrame:CGRectMake(70, 10, 240, 0)];
    [sBodyLabel setAttributedText:sBody];
    [sBodyLabel sizeToFit];
    
    NSLog(@"sImageView = %@", sImageView);
    [sImageView setFrame:CGRectMake(10, 10, 44, 44)];
    [sImageView setImageWithURL:sFaceImage];

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
    sResult += (sSize.height > 44) ? sSize.height : 44;
    sResult += 10;
    
    return sResult;
}


@end
