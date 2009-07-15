/*
 *  MEAboutViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 29.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEAboutViewController.h"


@interface MEAboutViewController (Private)
@end

@implementation MEAboutViewController (Private)


- (NSString *)titleText
{
    NSBundle *sBundle  = [NSBundle mainBundle];
    NSString *sAppName = [sBundle objectForInfoDictionaryKey:(id)kCFBundleNameKey];
    NSString *sAppVer  = [sBundle objectForInfoDictionaryKey:(id)kCFBundleVersionKey];

    return [NSString stringWithFormat:@"%@ %@", sAppName, sAppVer];
}


- (NSString *)creditsPath
{
    return [[NSBundle mainBundle] pathForResource:@"Credits" ofType:@"html"];
}


@end


@implementation MEAboutViewController


- (id)init
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        [self setTitle:[self titleText]];
    }

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIWebView *sWebView;

    sWebView = [[UIWebView alloc] initWithFrame:[[self view] bounds]];
    [sWebView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [sWebView setBackgroundColor:[UIColor whiteColor]];
    [sWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[self creditsPath]]]];
    [[self view] addSubview:sWebView];
    [sWebView release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}


- (void)closeButtonTapped
{
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
}


@end
