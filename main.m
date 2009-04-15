/*
 *  main.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


int main(int argc, char *argv[])
{
    NSAutoreleasePool *sPool = [[NSAutoreleasePool alloc] init];
    int sRetVal = UIApplicationMain(argc, argv, nil, nil);
    [sPool release];
    return sRetVal;
}
