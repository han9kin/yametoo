/*
 *  AppDelegate.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "AppDelegate.h"
#import "MEClientStore.h"
#import "MEImageCache.h"
#import "MELoginViewController.h"
#import "MEListViewController.h"


@interface AppDelegate (Private)
@end

@implementation AppDelegate (Private)


- (void)showLoginView
{
    UIViewController *sViewController;

    sViewController = [[MELoginViewController alloc] init];

    if (mNavigationController)
    {
        [mNavigationController setViewControllers:[NSArray arrayWithObject:sViewController]];
    }
    else
    {
        mNavigationController = [[UINavigationController alloc] initWithRootViewController:sViewController];
    }

    [mNavigationController setNavigationBarHidden:YES];
    [mNavigationController setToolbarHidden:YES];

    [sViewController release];
}


- (void)showListView
{
    UIViewController *sViewController;

    sViewController = [[MEListViewController alloc] initWithUserID:[[MEClientStore currentClient] userID] scope:kMEClientGetPostsScopeAll];

    if (mNavigationController)
    {
        [mNavigationController setViewControllers:[NSArray arrayWithObject:sViewController] animated:NO];
    }
    else
    {
        mNavigationController = [[UINavigationController alloc] initWithRootViewController:sViewController];
    }

    [mNavigationController setNavigationBarHidden:NO];
    [mNavigationController setToolbarHidden:NO];

    [sViewController release];
}


@end


@implementation AppDelegate

@synthesize window = mWindow;


- (void)dealloc
{
    [mNavigationController release];
    [mWindow release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIApplicationDelegate


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)aApplication
{
    NSLog(@"applicationDidReceiveMemoryWarning");
}


- (void)applicationDidFinishLaunching:(UIApplication *)aApplication
{
    [MEImageCache removeCachedImagesInDisk];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChangeNotification:) name:MEClientStoreCurrentUserDidChangeNotification object:nil];

    [self showLoginView];

    [mWindow addSubview:[mNavigationController view]];
    [mWindow makeKeyAndVisible];
}


#pragma mark -
#pragma mark Notifications


- (void)currentUserDidChangeNotification:(NSNotification *)aNotification
{
    if ([MEClientStore currentClient])
    {
        [self showListView];
    }
    else
    {
        [self showLoginView];
    }
}


@end
