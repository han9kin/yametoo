/*
 *  AppDelegate.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface AppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow               *mWindow;
    UINavigationController *mNavigationController;
}

@property(nonatomic, retain) IBOutlet UIWindow *window;


@end
