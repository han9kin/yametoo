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
    UITextView      *mBodyTextView;
    UITextField     *mTagTextField;
    UIImageView     *mAttachedImageView;

    MEImageButton   *mIconSelectButton;
    UILabel         *mIconDescLabel;

    UIButton        *mTakePictureButton;
    UIButton        *mFromPhotoLibraryButton;
    UIButton        *mRotateLeftButton;
    UIButton        *mRotateRightButton;
    UIButton        *mResizeButton;

    UILabel         *mImageResolutionLabel;
    UILabel         *mImageSizeLabel;

    MEIconListView  *mIconListView;

    MECharCounter   *mCharCounter;

    NSInteger        mSelectedIconIndex;
    UIImage         *mOriginalImage;
    BOOL             mIsMiddleSizeEnabled;
    BOOL             mIsLargeSizeEnabled;
    NSInteger        mImageDir;
    CGFloat          mRotateAngle;
    CGFloat          mLongSideLength;

    UIImage         *mResizedImage;
    NSData          *mImageRep;

    NSInteger        mMiddleSizeButtonIndex;
    NSInteger        mLargeSizeButtonIndex;
    NSInteger        mOriginalSizeButtonIndex;
    NSInteger        mCancelButtonIndex;
}

@property(nonatomic, assign) IBOutlet UITextView     *bodyTextView;
@property(nonatomic, assign) IBOutlet UITextField    *tagTextField;
@property(nonatomic, assign) IBOutlet UIImageView    *attachedImageView;

@property(nonatomic, assign) IBOutlet MEImageButton  *iconSelectButton;
@property(nonatomic, assign) IBOutlet UILabel        *iconDescLabel;

@property(nonatomic, assign) IBOutlet UIButton       *takePictureButton;
@property(nonatomic, assign) IBOutlet UIButton       *fromPhotoLibraryButton;
@property(nonatomic, assign) IBOutlet UIButton       *rotateLeftButton;
@property(nonatomic, assign) IBOutlet UIButton       *rotateRightButton;
@property(nonatomic, assign) IBOutlet UIButton       *resizeButton;

@property(nonatomic, assign) IBOutlet UILabel        *imageResolutionLabel;
@property(nonatomic, assign) IBOutlet UILabel        *imageSizeLabel;

@property(nonatomic, retain) IBOutlet MEIconListView *iconListView;


- (IBAction)close;
- (IBAction)upload;


- (IBAction)iconSelectButtonTapped:(id)aSender;
- (IBAction)takePictureButtonTapped:(id)aSender;
- (IBAction)fromPhotoLibraryButtonTapped:(id)aSender;
- (IBAction)rotateLeftButtonTapped:(id)aSender;
- (IBAction)rotateRightButtonTapped:(id)aSender;
- (IBAction)resizeButtonTapped:(id)aSender;

@end
