/*
 *  MEWebViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 11.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEWebViewController : UIViewController <UIWebViewDelegate>
{
    UIWebView *mWebView;

    NSURL     *mURL;
    NSInteger  mLoading;
}

@property(nonatomic, assign) IBOutlet UIWebView *webView;


- (id)initWithURL:(NSURL *)aURL;

@end
