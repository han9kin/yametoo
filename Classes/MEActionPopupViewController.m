/*
 *  MEActionPopupViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEActionPopupViewController.h"


@implementation MEActionPopupViewController


#pragma mark -


@synthesize postID = mPostID;


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setDelegate:(id)aDelegate
{
    mDelegate = aDelegate;
}


#pragma mark -
#pragma mark Actions


- (IBAction)showRepliesButtonTapped:(id)aSender
{
    if ([mDelegate respondsToSelector:@selector(actionPopupViewController:buttonTapped:)])
    {
        [mDelegate actionPopupViewController:self buttonTapped:kActionPopupViewShowRepliesButton];
    }
}


- (IBAction)postReplyButtonTapped:(id)aSender
{
    if ([mDelegate respondsToSelector:@selector(actionPopupViewController:buttonTapped:)])
    {
        [mDelegate actionPopupViewController:self buttonTapped:kActionPopupViewPostReplyButton];
    }
}


- (IBAction)showPhotoButtonTapped:(id)aSender
{
    if ([mDelegate respondsToSelector:@selector(actionPopupViewController:buttonTapped:)])
    {
        [mDelegate actionPopupViewController:self buttonTapped:kActionPopupViewShowPhotoButton];
    }
}


- (IBAction)cancelButtonTapped:(id)aSender
{
    if ([mDelegate respondsToSelector:@selector(actionPopupViewController:buttonTapped:)])
    {
        [mDelegate actionPopupViewController:self buttonTapped:kActionPopupViewCancelButton];
    }
}


@end
