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

    [mShowRepliesButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [mShowPhotoButton   setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [mPostID release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setDelegate:(id)aDelegate
{
    mDelegate = aDelegate;
}


- (void)setShowPhotoButtonEnabled:(BOOL)aFlag
{
    [mShowPhotoButton setEnabled:aFlag];
}


- (void)setShowRepliesButtonEnabled:(BOOL)aFlag
{
    [mShowRepliesButton setEnabled:aFlag];
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
