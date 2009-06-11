/*
 *  MEWebViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 11.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MEWebViewController.h"
#import "MEClient.h"


@implementation MEWebViewController


- (id)initWithURL:(NSURL *)aURL
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        mURL = [aURL retain];
    }

    return self;
}

- (void)dealloc
{
    [mURL release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIWebView *sWebView;

    sWebView = [[UIWebView alloc] initWithFrame:[[self view] bounds]];
    [sWebView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [sWebView setScalesPageToFit:YES];
    [sWebView setDelegate:self];
    [sWebView loadRequest:[NSURLRequest requestWithURL:mURL]];
    [[self view] addSubview:sWebView];
    [sWebView release];
}


#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)aRequest navigationType:(UIWebViewNavigationType)aNavigationType
{
    UIAlertView *sAlertView;

    if (aNavigationType == UIWebViewNavigationTypeLinkClicked)
    {
        mExternalURL  = [[aRequest URL] retain];

        sAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Open Link with Safari", @"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        [sAlertView show];
        [sAlertView autorelease];

        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
    if (mLoading <= 0)
    {
        mLoading = 0;
        [MEClient beginNetworkOperation];
    }

    mLoading++;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    mLoading--;

    if (mLoading <= 0)
    {
        [MEClient endNetworkOperation];

	[aWebView stringByEvaluatingJavaScriptFromString:@"{\n"
                  "var a = document.getElementsByTagName(\"a\");\n"
                  "for (var i = 0; i < a.length; i++)\n"
                  "a[i].target = \"_self\";\n"
                  "}"];
    }
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)aError
{
    mLoading--;

    if (mLoading <= 0)
    {
        [MEClient endNetworkOperation];
    }
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)aAlertView clickedButtonAtIndex:(NSInteger)aButtonIndex
{
    if (aButtonIndex)
    {
        [[UIApplication sharedApplication] openURL:mExternalURL];
    }

    [mExternalURL release];
    mExternalURL  = nil;
}


@end
