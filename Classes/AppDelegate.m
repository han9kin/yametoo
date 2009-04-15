/*
 *  AppDelegate.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "AppDelegate.h"
#import "MEPostViewController.h"


@implementation AppDelegate

@synthesize window         = mWindow;
@synthesize viewController = mViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)aApplication
{
    // Override point for customization after app launch
    [mWindow addSubview:[mViewController view]];
    [mWindow makeKeyAndVisible];
}

- (void)dealloc
{
    [mViewController release];
    [mWindow release];
    [super dealloc];
}

@end
