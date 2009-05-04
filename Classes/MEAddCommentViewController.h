/*
 *  MEAddCommentViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEAddCommentViewController : UIViewController
{
    IBOutlet UITextView *mTextView;
}

- (IBAction)closeButtonTapped:(id)aSender;
- (IBAction)postButtonTapped:(id)aSender;

@end
