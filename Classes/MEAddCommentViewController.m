/*
 *  MEAddCommentViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEAddCommentViewController.h"


@implementation MEAddCommentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [mTextView setText:@""];
    [mTextView becomeFirstResponder];
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
#pragma mark actions


- (IBAction)closeButtonTapped:(id)aSender
{
    NSLog(@"closeButtonTapped:");
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
}


- (IBAction)postButtonTapped:(id)aSender
{
    NSLog(@"postButtonTapped");
}


@end
