/*
 *  MainViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MECharCounter;


@interface MEPostViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIBarButtonItem *mCancelButton;
    IBOutlet UIBarButtonItem *mPostButton;
    IBOutlet UIButton        *mTakePictureButton;
    IBOutlet UIButton        *mFromPhotoLibraryButton;
    IBOutlet UITextView      *mBodyTextView;
    IBOutlet UITextField     *mTagTextField;
    IBOutlet UIImageView     *mAttachedImageView;

    MECharCounter *mCharCounter;
    UIImage       *mAttachedImage;
}

- (IBAction)takePictureButtonTapped:(id)aSender;
- (IBAction)fromPhotoLibraryButtonTapped:(id)aSender;
- (IBAction)postButtonTapped:(id)aSender;
- (IBAction)cancelButtonTapped:(id)aSender;

@end
