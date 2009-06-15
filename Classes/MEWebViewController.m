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
    if (mLoading > 0)
    {
        [MEClient endNetworkOperation];
    }

    mLoading = -1;

    [mWebView stopLoading];
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

    mWebView = [[UIWebView alloc] initWithFrame:[[self view] bounds]];
    [mWebView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [mWebView setScalesPageToFit:YES];
    [mWebView setDelegate:self];
    [mWebView loadRequest:[NSURLRequest requestWithURL:mURL]];
    [[self view] addSubview:mWebView];
    [mWebView release];
}


#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
    if (mLoading == 0)
    {
        [MEClient beginNetworkOperation];
        mLoading++;
    }
    else if (mLoading > 0)
    {
        mLoading++;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    if (mLoading > 0)
    {
        mLoading--;

        if (mLoading == 0)
        {
            [MEClient endNetworkOperation];

            [aWebView stringByEvaluatingJavaScriptFromString:@"{\n"
                      "var a = document.getElementsByTagName(\"a\");\n"
                      "for (var i = 0; i < a.length; i++)\n"
                      "a[i].target = \"_self\";\n"
                      "}"];
        }
    }
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)aError
{
    if (mLoading > 0)
    {
        mLoading--;

        if (mLoading == 0)
        {
            [MEClient endNetworkOperation];
        }
    }
}


@end
