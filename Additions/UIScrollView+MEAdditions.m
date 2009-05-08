/*
 *  UIScrollView+MEAdditions.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 08.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIScrollView+MEAdditions.h"


@implementation UIScrollView (MEAdditions)

- (BOOL)touchesShouldBegin:(NSSet *)aTouches withEvent:(UIEvent *)aEvent inContentView:(UIView *)aView
{
    if ([[self delegate] respondsToSelector:@selector(scrollView:shouldBeginTouches:withEvent:inContentView:)])
    {
        return [(id<MEScrollViewDelegate>)[self delegate] scrollView:self shouldBeginTouches:aTouches withEvent:aEvent inContentView:aView];
    }
    else
    {
        return YES;
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)aView
{
    if ([[self delegate] respondsToSelector:@selector(scrollView:shouldCancelTouchesInContentView:)])
    {
        return [(id<MEScrollViewDelegate>)[self delegate] scrollView:self shouldCancelTouchesInContentView:aView];
    }
    else
    {
        return [aView isKindOfClass:[UIControl class]] ? NO : YES;
    }
}

@end
