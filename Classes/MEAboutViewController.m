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
        [self setTitle:NSLocalizedString(@"About", @"")];
    }

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView    *sView;
    UILabel   *sLabel;
    UIWebView *sWebView;
    CGFloat    sOffset;
    CGFloat    sHeight;

    if ([self navigationController])
    {
        sOffset = 0;
        sHeight = 416;
    }
    else
    {
        UINavigationBar  *sNavigationBar;
        UINavigationItem *sNavigationItem;
        UIBarButtonItem  *sBarButtonItem;

        sNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [[self view] addSubview:sNavigationBar];
        [sNavigationBar release];

        sNavigationItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"About", @"")];
        [sNavigationBar pushNavigationItem:sNavigationItem animated:NO];
        [sNavigationItem release];

        sBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped)];
        [sNavigationItem setRightBarButtonItem:sBarButtonItem];
        [sBarButtonItem release];

        sOffset = 44;
        sHeight = 460;
    }

    sView = [[UIView alloc] initWithFrame:CGRectMake(0, sOffset, 320, 70)];
    [sView setBackgroundColor:[UIColor whiteColor]];
    [[self view] addSubview:sView];
    [sView release];

    sOffset += 70;

    sLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 29)];
    [sLabel setBackgroundColor:[UIColor clearColor]];
    [sLabel setFont:[UIFont boldSystemFontOfSize:24.0]];
    [sLabel setTextAlignment:UITextAlignmentCenter];
    [sLabel setText:[self titleText]];
    [sView addSubview:sLabel];
    [sLabel release];

    sWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, sOffset, 320, sHeight - sOffset)];
    [sWebView setBackgroundColor:[UIColor whiteColor]];
    [sWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[self creditsPath]]]];
    [[self view] addSubview:sWebView];
    [sWebView release];
}


- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}


- (void)closeButtonTapped
{
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
}


@end
