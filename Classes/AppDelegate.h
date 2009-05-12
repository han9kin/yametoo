/*
 *  AppDelegate.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MELoginViewController;


@interface AppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow              *mWindow;
    UITabBarController    *mTabBarController;
    MELoginViewController *mLoginViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow           *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
