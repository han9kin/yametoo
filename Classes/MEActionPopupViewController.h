/*
 *  MEActionPopupViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEActionPopupViewController : UIViewController
{
    IBOutlet UIButton *mShowRepliesButton;
    IBOutlet UIButton *mPostReplyButton;
    IBOutlet UIButton *mShowPhotoButton;
    IBOutlet UIButton *mCancelButton;
}

- (IBAction)showRepliesButtonTapped:(id)aSender;
- (IBAction)postReplyButtonTapped:(id)aSender;
- (IBAction)showPhotoButtonTapped:(id)aSender;
- (IBAction)cancelButtonTapped:(id)aSender;

@end
