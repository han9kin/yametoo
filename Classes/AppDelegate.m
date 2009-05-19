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
#import "MELoginViewController.h"


@interface AppDelegate (Private)
@end

@implementation AppDelegate (Private)


- (void)showMainView
{
    if (mLoginViewController)
    {
        if ([[mWindow subviews] containsObject:[mLoginViewController view]])
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:mWindow cache:YES];
            [[mLoginViewController view] removeFromSuperview];
            [mWindow addSubview:[mTabBarController view]];
            [UIView commitAnimations];

            [mLoginViewController autorelease];
            mLoginViewController = nil;

            if ([[mTabBarController selectedViewController] isKindOfClass:[UINavigationController class]])
            {
                [(UINavigationController *)[mTabBarController selectedViewController] popToRootViewControllerAnimated:NO];
            }

            [mTabBarController setSelectedIndex:0];
        }
        else
        {
            [self performSelector:_cmd withObject:nil afterDelay:0.1];
        }
    }
}


- (void)showLoginView
{
    if (!mLoginViewController)
    {
        mLoginViewController = [[MELoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [[mLoginViewController view] setFrame:CGRectMake(0, 20, 320, 460)];

        if ([[mTabBarController view] superview] == mWindow)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:mWindow cache:YES];
            [[mTabBarController view] removeFromSuperview];
            [mWindow addSubview:[mLoginViewController view]];
            [UIView commitAnimations];
        }
        else
        {
            [mWindow addSubview:[mLoginViewController view]];
        }
    }
}


@end


@implementation AppDelegate


#pragma mark -
#pragma mark Properties


@synthesize window           = mWindow;
@synthesize tabBarController = mTabBarController;


#pragma mark -


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)aApplication
{
    NSLog(@"applicationDidReceiveMemoryWarning");
}


- (void)applicationDidFinishLaunching:(UIApplication *)aApplication
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChangeNotification:) name:MEClientStoreCurrentUserDidChangeNotification object:nil];

    [self showLoginView];
    [mWindow makeKeyAndVisible];
}


- (void)dealloc
{
    [mLoginViewController release];
    [mTabBarController release];
    [mWindow release];

    [super dealloc];
}


#pragma mark -
#pragma mark Notifications


- (void)currentUserDidChangeNotification:(NSNotification *)aNotification
{
    if ([MEClientStore currentClient])
    {
        [self performSelector:@selector(showMainView) withObject:nil afterDelay:0.0];
    }
    else
    {
        [self performSelector:@selector(showLoginView) withObject:nil afterDelay:0.0];
    }
}


@end
