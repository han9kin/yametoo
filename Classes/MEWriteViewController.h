/*
 *  MEWriteViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEImageButton;


@interface MEWriteViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
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

    UILabel         *mCountLabel;

    UIWindow        *mUploadActivityWindow;
    UIView          *mUploadActivityView;
    UIProgressView  *mUploadProgressView;

    //  Icon Image View
    NSMutableArray  *mIconButtons;
    NSInteger        mSelectedIconIndex;

    UIImageView     *mCheckmarkImageView;
    UIView          *mImageViewContainer;
    UIImageView     *mAttachedImageView;
    UIButton        *mTakePictureButton;
    UIButton        *mFromPhotoLibraryButton;
    UIButton        *mRotateLeftButton;
    UIButton        *mRotateRightButton;
    UIButton        *mResizeButton;

    UILabel         *mImageResolutionLabel;
    UILabel         *mImageSizeLabel;

    UIImage         *mOriginalImage;
    UIImage         *mResizedImage;
    NSData          *mImageRep;
    BOOL             mIsImageModified;
    BOOL             mIsMiddleSizeEnabled;
    BOOL             mIsLargeSizeEnabled;
    CGFloat          mRotateAngle;
    CGFloat          mLongSideLength;

    NSString        *mText;
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
@property(nonatomic, assign) IBOutlet UILabel         *countLabel;

///////////////////////////

@property(nonatomic, assign) IBOutlet UIImageView     *checkmarkImageView;
@property(nonatomic, assign) IBOutlet UIView          *imageViewContainer;
@property(nonatomic, assign) IBOutlet UIImageView     *attachedImageView;
@property(nonatomic, assign) IBOutlet UIButton        *takePictureButton;
@property(nonatomic, assign) IBOutlet UIButton        *fromPhotoLibraryButton;
@property(nonatomic, assign) IBOutlet UIButton        *rotateLeftButton;
@property(nonatomic, assign) IBOutlet UIButton        *rotateRightButton;
@property(nonatomic, assign) IBOutlet UIButton        *resizeButton;

@property(nonatomic, assign) IBOutlet UILabel         *imageResolutionLabel;
@property(nonatomic, assign) IBOutlet UILabel         *imageSizeLabel;


- (id)init;
- (id)initWithCallUserID:(NSString *)aUserID;
- (id)initWithPingbackLink:(NSString *)aPermLink;


- (IBAction)close;
- (IBAction)upload;

- (IBAction)bodyTabButtonTapped:(id)aSender;
- (IBAction)tagTabButtonTapped:(id)aSender;
- (IBAction)iconImageTabButtontapped:(id)aSender;

- (IBAction)iconSelected:(id)aSender;
- (IBAction)takePictureButtonTapped:(id)aSender;
- (IBAction)fromPhotoLibraryButtonTapped:(id)aSender;
- (IBAction)rotateLeftButtonTapped:(id)aSender;
- (IBAction)rotateRightButtonTapped:(id)aSender;
- (IBAction)resizeButtonTapped:(id)aSender;


@end
