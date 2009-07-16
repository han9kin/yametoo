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
#import "MESettingsViewController.h"


@interface AppDelegate (Private)
@end

@implementation AppDelegate (Private)


- (void)setupNavigationController
{
    UIViewController *sViewController;

    sViewController       = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    mNavigationController = [[UINavigationController alloc] initWithRootViewController:sViewController];

    [sViewController release];
}


- (void)showLoginView
{
    UINavigationController *sNavigationController;
    UIViewController       *sViewController;

    sViewController       = [[MELoginViewController alloc] init];
    sNavigationController = [[UINavigationController alloc] initWithRootViewController:sViewController];

    [sNavigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [mNavigationController presentModalViewController:sNavigationController animated:YES];

    [sNavigationController release];
    [sViewController release];
}

- (void)showMainView
{
    UIViewController *sViewController;

    sViewController = [[MEListViewController alloc] initWithUserID:[[MEClientStore currentClient] userID] scope:kMEClientGetPostsScopeAll];

    [mNavigationController setViewControllers:[NSArray arrayWithObject:sViewController]];
    [mNavigationController setToolbarHidden:NO];

    [sViewController release];
}


- (void)showSettings
{
    UINavigationController *sNavigationController;
    UIViewController       *sViewController;

    sViewController       = [[MESettingsViewController alloc] init];
    sNavigationController = [[UINavigationController alloc] initWithRootViewController:sViewController];

    [sNavigationController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [mNavigationController presentModalViewController:sNavigationController animated:YES];

    [sNavigationController release];
    [sViewController release];
}

- (void)hideSettings
{
    if ([MEClientStore currentClient])
    {
        [mNavigationController dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [mNavigationController dismissModalViewControllerAnimated:NO];
        [self showLoginView];
    }
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


- (BOOL)application:(UIApplication *)aApplication didFinishLaunchingWithOptions:(NSDictionary *)aLaunchOptions
{
    NSLog(@"did launch with options: %@", aLaunchOptions);

    [MEImageCache removeCachedImagesInDisk];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChangeNotification:) name:MEClientStoreCurrentUserDidChangeNotification object:nil];

    [self setupNavigationController];

    [mWindow addSubview:[mNavigationController view]];
    [mWindow makeKeyAndVisible];

    [self showLoginView];

    return YES;
}

- (BOOL)application:(UIApplication *)aApplication handleOpenURL:(NSURL *)aURL
{
    NSLog(@"handle url: %@", aURL);

    if ([[aURL host] isEqualToString:@"user"])
    {
        if ([[[aURL path] pathComponents] count] > 1)
        {
            if ([[[mNavigationController viewControllers] objectAtIndex:0] isKindOfClass:[MEListViewController class]])
            {
                UIViewController *sViewController;

                sViewController = [[MEListViewController alloc] initWithUserID:[[[aURL path] pathComponents] objectAtIndex:1] scope:kMEClientGetPostsScopeAll];

                if ([mNavigationController modalViewController])
                {
                    [mNavigationController pushViewController:sViewController animated:NO];
                    [mNavigationController dismissModalViewControllerAnimated:YES];
                }
                else
                {
                    [mNavigationController pushViewController:sViewController animated:YES];
                }

                [sViewController release];
            }
        }
    }

    return YES;
}


#pragma mark -
#pragma mark MEClientStore Notifications


- (void)currentUserDidChangeNotification:(NSNotification *)aNotification
{
    if ([MEClientStore currentClient])
    {
        [self showMainView];
    }
}


@end
