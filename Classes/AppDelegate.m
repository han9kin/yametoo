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
    [MEImageCache removeCachedImagesInDisk];
    
    NSString *sVersion = [[UIDevice currentDevice] systemVersion];
    NSString *sMajorVersion = [[sVersion componentsSeparatedByString:@"."] objectAtIndex:0];
    if ([sMajorVersion integerValue] > 2)
    {
        UIAlertView *sAlert = nil;
        sAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                            message:NSLocalizedString(@"get new version message", nil)
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                  otherButtonTitles:NSLocalizedString(@"get yametoo remix", nil),
                                                    NSLocalizedString(@"get me2DAY", nil), nil];
        [sAlert show];
        [sAlert release];
    }

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


- (void)alertView:(UIAlertView *)aAlertView clickedButtonAtIndex:(NSInteger)aButtonIndex
{
    NSURL *sURL;
    
    if (aButtonIndex == 1)
    {
        sURL = [NSURL URLWithString:@"http://itunes.apple.com/app/id327207840?mt=8"];
    }
    else if (aButtonIndex == 2)
    {
        sURL = [NSURL URLWithString:@"http://itunes.apple.com/app/id322934412?mt=8"];
    }
    
    [[UIApplication sharedApplication] openURL:sURL];
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
