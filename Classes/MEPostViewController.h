/*
 *  MainViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEPostViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UITextView  *mBodyTextView;
    IBOutlet UITextView  *mTagTextView;
    IBOutlet UIImageView *mAttachedImageView;

    UIImage              *mAttachedImage;
}

- (IBAction)takePictureButtonTapped:(id)aSender;
- (IBAction)fromPhotoLibraryButtonTapped:(id)aSender;
- (IBAction)postButtonTapped:(id)aSender;
- (IBAction)cancelButtonTapped:(id)aSender;
- (IBAction)keyboardToolbarDoneButtonTapped:(id)aSender;

@end
