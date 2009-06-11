/*
 *  MEWebViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 11.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEWebViewController : UIViewController <UIWebViewDelegate>
{
    NSURL     *mURL;
    NSInteger  mLoading;
}

- (id)initWithURL:(NSURL *)aURL;

@end
