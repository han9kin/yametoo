/*
 *  MEPhotoViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 16.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "MEPhotoViewController.h"
#import "MEImageButton.h"
#import "MEPost.h"
#import "MEUser.h"


@interface MEPhotoViewController (Private)
@end

@implementation MEPhotoViewController (Private)

- (void)layoutControls
{
    CGSize sViewSize;
    CGSize sLabelSize;

    [mNavigationBar sizeToFit];
    [mTextLabel sizeToFit];

    sViewSize          = [[self view] bounds].size;
    sLabelSize         = [mTextLabel frame].size;
    sLabelSize.height += 20;

    [mTextLabel setFrame:CGRectMake(0, sViewSize.height - sLabelSize.height, sViewSize.width, sLabelSize.height)];
}

- (void)showControls
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [mNavigationBar setHidden:NO];
    [mTextLabel setHidden:NO];
}

- (void)hideControls
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [mNavigationBar setHidden:YES];
    [mTextLabel setHidden:YES];
}

@end


@implementation MEPhotoViewController

@synthesize imageButton       = mImageButton;
@synthesize navigationBar     = mNavigationBar;
@synthesize textLabel         = mTextLabel;
@synthesize activityIndicator = mActivityIndicator;


- (id)initWithPost:(MEPost *)aPost
{
    self = [super initWithNibName:@"PhotoView" bundle:nil];

    if (self)
    {
        mPost = aPost;

        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self setWantsFullScreenLayout:YES];
    }

    return self;
}

- (void)dealloc
{
    [mImageButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [[mNavigationBar topItem] setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@'s me2photo", @""), [[mPost author] nickname]]];

    [mTextLabel setText:[[mPost body] string]];

    [mImageButton setBackgroundColor:[UIColor blackColor]];
    [mImageButton setContentMode:UIViewContentModeScaleAspectFit];
    [mImageButton setImageWithURL:[mPost photoURL]];

    [self layoutControls];
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:aAnimated];
}

- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:aAnimated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    [self layoutControls];
}


- (IBAction)imageDidLoad
{
    [mActivityIndicator stopAnimating];

    [self performSelector:@selector(hideControls) withObject:nil afterDelay:1.5];
}

- (IBAction)toggleControls
{
    if ([mActivityIndicator isHidden])
    {
        if ([mNavigationBar isHidden])
        {
            [self showControls];
        }
        else
        {
            [self hideControls];
        }
    }
}

- (IBAction)close
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [self dismissModalViewControllerAnimated:YES];
}


@end
