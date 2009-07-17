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
    UINavigationBar *mNavigationBar;
    UIView          *mTabContainerView;
    
    UIButton        *mTabBodyButton;
    UIButton        *mTabTagButton;
    UIButton        *mTabIconImageButton;
    UIImageView     *mSplitBar;
    
    UIView          *mBodyView;
    UIView          *mTagView;
    UIView          *mIconImageView;
    
    NSInteger        mSelectedTabIndex;
    UIView          *mCurrentView;

    UITextView      *mBodyTextView;
    UITextView      *mTagTextView;
    
    ///////////////////////////////////////////////////////
    

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

@property(nonatomic, assign) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic, assign) IBOutlet UIView          *tabContainerView;
@property(nonatomic, assign) IBOutlet UIButton        *tabBodyButton;
@property(nonatomic, assign) IBOutlet UIButton        *tabTagButton;
@property(nonatomic, assign) IBOutlet UIButton        *tabIconImageButton;
@property(nonatomic, assign) IBOutlet UIImageView     *splitBar;
@property(nonatomic, retain) IBOutlet UIView          *bodyView;
@property(nonatomic, retain) IBOutlet UIView          *tagView;
@property(nonatomic, retain) IBOutlet UIView          *iconImageView;
@property(nonatomic, assign) IBOutlet UITextView      *bodyTextView;
@property(nonatomic, assign) IBOutlet UITextView      *tagTextView;

///////////////////////////

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

- (IBAction)bodyTabButtonTapped:(id)aSender;
- (IBAction)tagTabButtonTapped:(id)aSender;
- (IBAction)iconImageTabButtontapped:(id)aSender;

- (IBAction)iconSelectButtonTapped:(id)aSender;
- (IBAction)takePictureButtonTapped:(id)aSender;
- (IBAction)fromPhotoLibraryButtonTapped:(id)aSender;
- (IBAction)rotateLeftButtonTapped:(id)aSender;
- (IBAction)rotateRightButtonTapped:(id)aSender;
- (IBAction)resizeButtonTapped:(id)aSender;

@end
