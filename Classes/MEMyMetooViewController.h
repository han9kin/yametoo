/*
 *  MEMyMetooViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 16.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MEReaderView.h"


@interface MEMyMetooViewController : UIViewController
{
    IBOutlet UILabel      *mTopBarLabel;
    IBOutlet MEReaderView *mReaderView;
}

@end
