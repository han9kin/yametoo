/*
 *  MEWriteViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MEIconListView.h"


@class MECharCounter;
@class MEImageButton;


@interface MEWriteViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, MEIconListViewDelegate>
{
    IBOutlet UIBarButtonItem *mCancelButton;
    IBOutlet UIBarButtonItem *mPostButton;

    IBOutlet UITextView      *mBodyTextView;
    IBOutlet UITextField     *mTagTextField;
    IBOutlet UIImageView     *mAttachedImageView;
    
    IBOutlet MEImageButton   *mIconSelectButton;
    IBOutlet UILabel         *mIconDescLabel;

    IBOutlet UIButton        *mTakePictureButton;
    IBOutlet UIButton        *mFromPhotoLibraryButton;
    IBOutlet UIButton        *mRotateLeftButton;
    IBOutlet UIButton        *mRotateRightButton;
    IBOutlet UIButton        *mResizeButton;
    
    IBOutlet UILabel         *mImageResolutionLabel;
    IBOutlet UILabel         *mImageSizeLabel;

    IBOutlet MEIconListView  *mIconListView;

    MECharCounter *mCharCounter;
    
    NSInteger      mSelectedIconIndex;
    UIImage       *mOriginalImage;
    BOOL           mIsMiddleSizeEnabled;
    BOOL           mIsLargeSizeEnabled;
    NSInteger      mImageDir;
    CGFloat        mRotateAngle;
    CGFloat        mLongSideLength;
    
    UIImage       *mResizedImage;
    NSData        *mImageRep;
    
    NSInteger      mMiddleSizeButtonIndex;
    NSInteger      mLargeSizeButtonIndex;
    NSInteger      mOriginalSizeButtonIndex;
    NSInteger      mCancelButtonIndex;
}

- (IBAction)postButtonTapped:(id)aSender;
- (IBAction)cancelButtonTapped:(id)aSender;

- (IBAction)iconSelectButtonTapped:(id)aSender;
- (IBAction)takePictureButtonTapped:(id)aSender;
- (IBAction)fromPhotoLibraryButtonTapped:(id)aSender;
- (IBAction)rotateLeftButtonTapped:(id)aSender;
- (IBAction)rotateRightButtonTapped:(id)aSender;
- (IBAction)resizeButtonTapped:(id)aSender;

@end
