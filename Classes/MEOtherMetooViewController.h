/*
 *  MEOtherMetooViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 11.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MEReaderViewController.h"


@interface MEOtherMetooViewController : MEReaderViewController
{
    NSString *mUserID;
}

- (id)initWithUserID:(NSString *)aUserID;

@end
