/*
 *  UIAlertView+MEAdditions.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 06.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "UIAlertView+MEAdditions.h"
#import "NSError+MEAdditions.h"


@implementation UIAlertView (MEAdditions)

+ (void)showAlert:(NSString *)aString
{
    UIAlertView *sAlertView;

    sAlertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(aString, @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [sAlertView show];
    [sAlertView release];
}

+ (void)showConfirm:(NSString *)aString delegate:(id)aDelegate
{
    UIAlertView *sAlertView;

    sAlertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(aString, @"") delegate:aDelegate cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [sAlertView show];
    [sAlertView release];
}

+ (void)showError:(NSError *)aError
{
    UIAlertView *sAlertView;

    sAlertView = [[UIAlertView alloc] initWithTitle:nil message:[aError localizedDescriptionMe2DAY] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [sAlertView show];
    [sAlertView release];
}

@end
