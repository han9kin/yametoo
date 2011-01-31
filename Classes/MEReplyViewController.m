/*
 *  MEReplyViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 05. 04.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "NSString+MEAdditions.h"
#import "UIAlertView+MEAdditions.h"
#import "MEReplyViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEComment.h"


@interface MEReplyViewController (Private)
@end

@implementation MEReplyViewController (Private)

- (void)layoutViewsForInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    switch (aInterfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [mNavigationBar setFrame:CGRectMake(0, 0, 480, 32)];
            [mTextView setFrame:CGRectMake(0, 32, 480, 76)];
            [mCounterLabel setFrame:CGRectMake(370, 108, 100, 30)];
            break;

        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [mNavigationBar setFrame:CGRectMake(0, 0, 320, 44)];
            [mTextView setFrame:CGRectMake(0, 44, 320, 170)];
            [mCounterLabel setFrame:CGRectMake(210, 214, 100, 30)];
            break;
    }
}

@end


@implementation MEReplyViewController


@synthesize navigationBar = mNavigationBar;
@synthesize textView      = mTextView;
@synthesize counterLabel  = mCounterLabel;


#pragma mark -


- (id)initWithPostID:(NSString *)aPostID
{
    self = [super initWithNibName:@"ReplyView" bundle:nil];

    if (self)
    {
        mPostID = [aPostID copy];
    }

    return self;
}

- (id)initWithPostID:(NSString *)aPostID callUserID:(NSString *)aUserID
{
    self = [super initWithNibName:@"ReplyView" bundle:nil];

    if (self)
    {
        mPostID = [aPostID copy];
        mText   = [[NSString alloc] initWithFormat:@"/%@/ ", aUserID];
    }

    return self;
}

- (void)dealloc
{
    [mPostID release];
    [mText release];

    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self layoutViewsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];

    [mTextView setText:mText];
    [mTextView becomeFirstResponder];

    [mCounterLabel setText:[NSString stringWithFormat:@"%d", (kMECommentBodyMaxLen - [[mTextView text] length])]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation duration:(NSTimeInterval)aDuration
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:aDuration];
    [self layoutViewsForInterfaceOrientation:aInterfaceOrientation];
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark actions


- (IBAction)close
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)upload
{
    NSString   *sComment = [mTextView text];
    NSUInteger  sLength  = [sComment lengthMe2DAY];

    if (sLength == 0)
    {
        [UIAlertView showAlert:NSLocalizedString(@"Empty comment body", @"")];
    }
    else if (sLength > kMECommentBodyMaxLen)
    {
        [UIAlertView showAlert:NSLocalizedString(@"Too long comment body", @"")];
    }
    else
    {
        [[MEClientStore currentClient] createCommentWithPostID:mPostID body:sComment delegate:self];
    }
}


#pragma mark -
#pragma mark UITextView Delegate


- (void)textViewDidChange:(UITextView *)aTextView
{
    NSInteger sRemainCount = kMECommentBodyMaxLen - [[aTextView text] lengthMe2DAY];

    [mCounterLabel setHighlighted:((sRemainCount < 0) ? YES : NO)];
    [mCounterLabel setText:[NSString stringWithFormat:@"%d", sRemainCount]];

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
    if (([aText length] == 1) && ([aText characterAtIndex:0] == '\n'))
    {
        return NO;
    }
    else
    {
        if ([aText rangeOfString:@"\n"].location != NSNotFound)
        {
            aText   = [aText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

            [aTextView setText:[[aTextView text] stringByReplacingCharactersInRange:aRange withString:aText]];

            return NO;
        }
        else
        {
            return YES;
        }
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
