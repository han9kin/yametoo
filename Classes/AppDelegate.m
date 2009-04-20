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
#import "MEClientStore.h"
#import "MELoginViewController.h"


@implementation AppDelegate


#pragma mark -
#pragma mark Properties


@synthesize window         = mWindow;
@synthesize viewController = mViewController;


#pragma mark -


- (void)applicationDidFinishLaunching:(UIApplication *)aApplication
{
    // Override point for customization after app launch
    //[mWindow addSubview:[mViewController view]];
    
    NSNotificationCenter *sCenter = [NSNotificationCenter defaultCenter];
    [sCenter addObserver:self
                selector:@selector(currentUserDidChangeNotification:)
                    name:MEClientStoreCurrentUserDidChangeNotification
                  object:nil];
    
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
#pragma mark Notifications


- (void)currentUserDidChangeNotification:(NSNotification *)aNotification
{
    NSArray *sSubviews = [mWindow subviews];
    
    if ([sSubviews containsObject:[mLoginViewController view]])
    {
        [[mLoginViewController view] removeFromSuperview];
        [mLoginViewController autorelease];
        mLoginViewController = nil;
        
        [mWindow addSubview:[mViewController view]];
        [mWindow makeKeyAndVisible];
    }
}


@end
