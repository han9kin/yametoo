/*
 *  AppDelegate.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "AppDelegate.h"
#import "MEImageCache.h"
#import "MEClientStore.h"
#import "MELoginViewController.h"
#import "MEReaderViewController.h"


@implementation AppDelegate


#pragma mark -
#pragma mark Properties


@synthesize window         = mWindow;
@synthesize viewController = mViewController;


#pragma mark -


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)aApplication
{
    [MEImageCache removeCachedImagesInMemory];
}


- (void)applicationDidFinishLaunching:(UIApplication *)aApplication
{
    [MEImageCache removeCachedImagesInDisk];

    NSNotificationCenter *sCenter = [NSNotificationCenter defaultCenter];
    [sCenter addObserver:self
                selector:@selector(currentUserDidChangeNotification:)
                    name:MEClientStoreCurrentUserDidChangeNotification
                  object:nil];

    [(MEReaderViewController *)[[mViewController viewControllers] objectAtIndex:0] setType:kMEReaderViewControllerTypeMyMetoo];
    [(MEReaderViewController *)[[mViewController viewControllers] objectAtIndex:1] setType:kMEReaderViewControllerTypeMyFriends];

    mLoginViewController = [[MELoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [[mLoginViewController view] setFrame:CGRectMake(0, 20, 320, 460)];
    [mWindow addSubview:[mLoginViewController view]];
    [mWindow makeKeyAndVisible];
}


- (void)dealloc
{
    [mLoginViewController release];
    [mViewController      release];
    [mWindow              release];

    [super dealloc];
}


#pragma mark -


- (void)showMainView
{
    if (mLoginViewController)
    {
        if ([[mWindow subviews] containsObject:[mLoginViewController view]])
        {
            [[mLoginViewController view] removeFromSuperview];
            [mLoginViewController autorelease];
            mLoginViewController = nil;

            [mWindow addSubview:[mViewController view]];
            [mWindow makeKeyAndVisible];
        }
        else
        {
            [self performSelector:_cmd withObject:nil afterDelay:0.1];
        }
    }
}

#pragma mark -
#pragma mark Notifications


- (void)currentUserDidChangeNotification:(NSNotification *)aNotification
{
    if ([MEClientStore currentClient])
    {
        [self showMainView];
    }
}


@end
