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
#import "MECharCounter.h"


@implementation MEAddCommentViewController


@synthesize post = mPost;


#pragma mark -


- (void)dealloc
{
    [mTextView release];
    
    [mCharCounter release];    
    [mPost        release];

    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [mTextView setReturnKeyType:UIReturnKeySend];
    [mTextView setText:@""];
    
    mCharCounter = [[MECharCounter alloc] initWithParentView:[self view]];
    [mCharCounter setTextOwner:mTextView];
    [mCharCounter setLimitCount:300];
    [mCharCounter setFrame:CGRectMake(200, 207, 0, 0)];
    [mCharCounter setHidden:NO];
    [mCharCounter update];
    
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
#pragma mark UITextView Delegate


- (void)textViewDidBeginEditing:(UITextView *)aTextView;
{
    if (aTextView == mTextView)
    {
    }
}


- (void)textViewDidEndEditing:(UITextView *)aTextView
{
    if (aTextView == mTextView)
    {
        [mCharCounter setHidden:YES];
    }
}


- (void)textViewDidChange:(UITextView *)aTextView
{
    if (aTextView == mTextView)
    {
        [mCharCounter update];
    }
    
    if ([aTextView hasText])
    {
        NSRange sRange = [aTextView selectedRange];
        if (sRange.location < [[aTextView text] length])
        {
            [aTextView scrollRangeToVisible:sRange];
        }
    }
}


- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)aRange replacementText:(NSString *)aText
{
    if ([aText length] == 1 && [aText characterAtIndex:0] == 10)
    {
        if (aTextView == mTextView)
        {
            [self postButtonTapped:self];
            return NO;
        }
    }
    else if (aTextView == mTextView)
    {
        NSString *sBody = [mTextView text];
        if ([sBody length] >= [mCharCounter limitCount])
        {
            return NO;
        }
    }
    
    return YES;
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
