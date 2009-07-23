/*
 *  MEReplyViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSString+MEAdditions.h"
#import "UIAlertView+MEAdditions.h"
#import "MEReplyViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEComment.h"


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

    [mTextView setText:mText];
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
