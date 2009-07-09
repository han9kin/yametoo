/*
 *  MEOtherMetooViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 11.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MEListViewController.h"


@interface MEOtherMetooViewController : MEListViewController
{
    NSString *mUserID;
}

- (id)initWithUserID:(NSString *)aUserID;

@end
