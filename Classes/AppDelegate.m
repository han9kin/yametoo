/*
 *  AppDelegate.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MEClient.h"
#import "MEClient+Requests.h"


@implementation AppDelegate

@synthesize window         = mWindow;
@synthesize viewController = mViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)aApplication
{
    // Override point for customization after app launch
    [mWindow addSubview:[mViewController view]];
    [mWindow makeKeyAndVisible];
    
    MEClient *sClient = [[MEClient alloc] init];
    [sClient setUserID:@"maccrazy"];
    [sClient setUserKey:@"1234567"];
    NSLog(@"%@", [sClient loginRequest]);
    [sClient createCommentRequest];
    NSLog(@"%@", [sClient createPostRequestWithBody:@"body_str" tags:@"test test2" icon:1 attachedImage:nil]);
    [sClient deleteCommentsRequest];
    [sClient getCommentsRequest];
    [sClient getFriendsRequest];
    [sClient getLatestsRequest];
    [sClient getMetoosRequest];
    [sClient getPersonRequest];
    [sClient getPostsRequest];
    [sClient getSettingsRequest];
    [sClient getTagsRequest];
    [sClient metooRequest];
    [sClient trackCommentsRequest];
    [sClient release];
}

- (void)dealloc
{
    [mViewController release];
    [mWindow release];
    [super dealloc];
}

@end
