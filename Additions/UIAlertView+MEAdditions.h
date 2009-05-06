/*
 *  UIAlertView+MEAdditions.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 06.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface UIAlertView (MEAdditions)

+ (void)showAlert:(NSString *)aString;
+ (void)showError:(NSError *)aError;

@end
