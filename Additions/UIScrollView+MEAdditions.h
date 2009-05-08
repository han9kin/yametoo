/*
 *  UIScrollView+MEAdditions.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 08.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@protocol MEScrollViewDelegate <UIScrollViewDelegate>

@optional;

- (BOOL)scrollView:(UIScrollView *)aScrollView shouldBeginTouches:(NSSet *)aTouches withEvent:(UIEvent *)aEvent inContentView:(UIView *)aView;
- (BOOL)scrollView:(UIScrollView *)aScrollView shouldCancelTouchesInContentView:(UIView *)aView;

@end


@interface UIScrollView (MEAdditions)

@end
