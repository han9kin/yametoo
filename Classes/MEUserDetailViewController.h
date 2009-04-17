/*
 *  MEUserDetailViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEUserDetailViewController : UIViewController <UITextFieldDelegate>
{
    UITextField      *mUserIDField;
    UITextField      *mUserKeyField;

    UIViewController *mParentViewController;

    NSString         *mUserID;
}

- (id)initWithUserID:(NSString *)aUserID parentViewController:(UIViewController *)aParentViewController;

@end
