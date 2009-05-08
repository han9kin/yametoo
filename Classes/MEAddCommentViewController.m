/*
 *  MEAddCommentViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIAlertView+MEAdditions.h"
#import "MEAddCommentViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEPost.h"


@implementation MEAddCommentViewController


@synthesize post = mPost;


#pragma mark -


- (void)dealloc
{
    [mTextView release];
    
    [mPost     release];

    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [mTextView setText:@""];
    [mTextView becomeFirstResponder];
}


#pragma mark -
#pragma mark actions


- (IBAction)closeButtonTapped:(id)aSender
{
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
}


- (IBAction)postButtonTapped:(id)aSender
{
    NSString *sComment = [mTextView text];

    if ([sComment length] > 0)
    {
        [[MEClientStore currentClient] createCommentWithPostID:[mPost postID] body:sComment delegate:self];
    }
}


#pragma mark -
#pragma mark MEClient Delegate


- (void)client:(MEClient *)aClient didCreateCommentWithError:(NSError *)aError
{
    if (aError)
    {
        [UIAlertView showError:aError];
    }
    else
    {
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }
}


@end
