/*
 *  MainViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEPostViewController : UIViewController
{
    IBOutlet UITextView *mBodyTextView;
    IBOutlet UITextView *mTagTextView;
    IBOutlet UIToolbar  *mKeyboardToolbar;
}

- (IBAction)takePictureButtonTapped:(id)aSender;
- (IBAction)postButtonTapped:(id)aSender;
- (IBAction)keyboardToolbarDoneButtonTapped:(id)aSender;

@end
