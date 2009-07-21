/*
 *  MEReplyViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIAlertView+MEAdditions.h"
#import "MEReplyViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEPost.h"
#import "MEComment.h"


@implementation MEReplyViewController


@synthesize navigationBar = mNavigationBar;
@synthesize textView      = mTextView;
@synthesize counterLabel  = mCounterLabel;


#pragma mark -


- (id)initWithPost:(MEPost *)aPost
{
    self = [super initWithNibName:@"ReplyView" bundle:nil];

    if (self)
    {
        mPost = [aPost retain];
    }

    return self;
}


- (void)dealloc
{
    [mPost release];

    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [mTextView becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)aFromInterfaceOrientation
{
    UIInterfaceOrientation sOrientation;
    CGRect                 sFrame;
    
    [mNavigationBar sizeToFit];
    sFrame       = [mNavigationBar frame];
    sOrientation = [self interfaceOrientation];    

    if (sOrientation == UIInterfaceOrientationPortrait || sOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [mTextView setFrame:CGRectMake(0, sFrame.origin.y + sFrame.size.height, sFrame.size.width, 200)];    
    }
    else if (sOrientation == UIInterfaceOrientationLandscapeLeft || sOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [mTextView setFrame:CGRectMake(0, sFrame.origin.y + sFrame.size.height, sFrame.size.width, 106)];
    }
    
    sFrame = [mTextView frame];
    [mCounterLabel setFrame:CGRectMake(sFrame.origin.x + sFrame.size.width - 60, sFrame.origin.y + sFrame.size.height - 40, 60, 40)];
}


#pragma mark -
#pragma mark actions


- (IBAction)close
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)upload
{
    NSString *sComment = [mTextView text];

    if ([sComment length] > 0)
    {
        [[MEClientStore currentClient] createCommentWithPostID:[mPost postID] body:sComment delegate:self];
    }
}


#pragma mark -
#pragma mark UITextView Delegate


- (void)textViewDidChange:(UITextView *)aTextView
{
    [mCounterLabel setText:[NSString stringWithFormat:@"%d", (kMECommentBodyMaxLen - [[aTextView text] length])]];

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
    BOOL sResult = YES;

    if ([aText length] == 1 && [aText characterAtIndex:0] == '\n')
    {
        sResult = NO;
    }
    else
    {
        if ([aText rangeOfString:@"\n"].location != NSNotFound)
        {
            aText   = [aText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            sResult = NO;
        }

        if (([[aTextView text] length] + [aText length] - aRange.length) > kMECommentBodyMaxLen)
        {
            aText   = [aText substringToIndex:(kMECommentBodyMaxLen - [[aTextView text] length] + aRange.length)];
            sResult = NO;
        }

        if (!sResult)
        {
            [aTextView setText:[[aTextView text] stringByReplacingCharactersInRange:aRange withString:aText]];
        }
    }

    return sResult;
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
