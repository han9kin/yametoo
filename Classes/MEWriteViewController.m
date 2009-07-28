/*
 *  MEWriteViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSString+MEAdditions.h"
#import "UIAlertView+MEAdditions.h"
#import "MEWriteViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEClientOperation.h"
#import "MEDrawingFunctions.h"
#import "MEDraft.h"
#import "MEUser.h"
#import "MEPost.h"
#import "MEPostIcon.h"
#import "MEImageButton.h"
#import "MESettings.h"
#import <math.h>


static NSDictionary *gActions = nil;


static double radians(double degrees)
{
    return degrees * M_PI/180;
}


#define IMAGE_PORTRAIT_MODE     0
#define IMAGE_LANDSCAPE_MODE    1


@interface MEWriteViewController (Privates)

- (void)checkDraft;
- (void)loadDraft;
- (void)savePostAsDraft;

- (void)updateImageInfo;
- (void)resizeImage;

- (void)arrangeSubviews:(UIInterfaceOrientation)aToInterfaceOrientation;

- (void)showUploadActivityWindow;
- (void)hideUploadActivityWindow;
- (void)layoutUploadActivityViewForInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation;

@end


@implementation MEWriteViewController (Privates)


- (void)checkDraft
{
    MEDraft *sDraft = [MEDraft lastDraftWithUserID:[[MEClientStore currentClient] userID]];

    if (sDraft)
    {
        UIAlertView *sAlertView;

        sAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                message:NSLocalizedString(@"Load Draft?", @"")
                                               delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"No", @"")
                                      otherButtonTitles:NSLocalizedString(@"Yes", @""), nil];

        [sAlertView show];
        [sAlertView release];
    }
}


- (void)loadDraft
{
    CGSize  sImageSize;
    MEDraft *sDraft = [MEDraft lastDraftWithUserID:[[MEClientStore currentClient] userID]];

    [mBodyTextView setText:[sDraft body]];
    [mTagTextView setText:[sDraft tags]];

    mSelectedIconIndex = [sDraft icon];
    mOriginalImage     = [[sDraft originalImage] retain];
    mResizedImage      = [[sDraft editedImage] retain];

    if (mOriginalImage)
    {
        [mRotateLeftButton  setEnabled:YES];
        [mRotateRightButton setEnabled:YES];
        [mResizeButton      setEnabled:(mIsMiddleSizeEnabled || mIsLargeSizeEnabled) ? YES : NO];

        sImageSize           = [mOriginalImage size];
        mLongSideLength      = MAX(sImageSize.width, sImageSize.height);
        mIsMiddleSizeEnabled = (mLongSideLength > 500)  ? YES : NO;
        mIsLargeSizeEnabled  = (mLongSideLength > 1024) ? YES : NO;
    }

    if (mResizedImage)
    {
        sImageSize      = [mResizedImage size];
        mLongSideLength = MAX(sImageSize.width, sImageSize.height);
    }

    [self updateImageInfo];
}


- (void)savePostAsDraft
{
    MEDraft *sDraft;

    if ([[mBodyTextView text] length] || [[mTagTextView text] length] || mOriginalImage)
    {
        sDraft = [[MEDraft alloc] initWithUserID:[[MEClientStore currentClient] userID]];
        [sDraft setBody:[mBodyTextView text]];
        [sDraft setTags:[mTagTextView text]];
        [sDraft setIcon:mSelectedIconIndex];
        [sDraft setOriginalImage:mOriginalImage];
        [sDraft setEditedImage:mResizedImage];
        [sDraft save];
        [sDraft release];
    }
}


- (void)updateImageInfo
{
    CGSize     sImageSize = CGSizeZero;
    NSUInteger sLength    = 0;

    if (mResizedImage)
    {
        sImageSize = [mResizedImage size];

        [mImageRep release];
        mImageRep = UIImageJPEGRepresentation(mResizedImage, 0.8);
        [mImageRep retain];
        sLength   = [mImageRep length];

        [mAttachedImageView    setImage:mResizedImage];
        [mImageResolutionLabel setText:[NSString stringWithFormat:@"%d X %d", (int)sImageSize.width, (int)sImageSize.height]];
        [mImageSizeLabel       setText:[NSString stringWithFormat:@"%.1f KB", ((float)sLength / 1024.0)]];
    }
}


- (void)resizeImage
{

    CGSize    sSize      = CGSizeZero;
    CGSize    sImageSize = [mOriginalImage size];
    NSInteger sImageDir  = (sImageSize.width > sImageSize.height) ? IMAGE_LANDSCAPE_MODE : IMAGE_PORTRAIT_MODE;

    if (sImageDir == IMAGE_PORTRAIT_MODE)
    {
        sSize.height = mLongSideLength;
        sSize.width  = sImageSize.width * sSize.height / sImageSize.height;
    }
    else
    {
        sSize.width  = mLongSideLength;
        sSize.height = sImageSize.height * sSize.width / sImageSize.width;
    }

    double sAngle = (double)(((NSInteger)mRotateAngle % 360));
    sAngle = (sAngle < 0) ? (sAngle + 360) : sAngle;

    if (sAngle == 90.0 || sAngle == 270.0)
    {
        CGFloat sTemp = sSize.width;
        sSize.width   = sSize.height;
        sSize.height  = sTemp;
    }

    UIGraphicsBeginImageContext(sSize);
    CGContextRef sContext = UIGraphicsGetCurrentContext();

    if (sAngle == 90)
    {
        CGContextTranslateCTM(sContext, sSize.width, 0);
    }
    else if (sAngle == 180)
    {
        CGContextTranslateCTM(sContext, sSize.width, sSize.height);
    }
    else if (sAngle == 270)
    {
        CGContextTranslateCTM(sContext, 0, sSize.height);
    }
    CGContextRotateCTM(sContext, radians(sAngle));

    if (sAngle == 0 || sAngle == 180)
    {
        [mOriginalImage drawInRect:CGRectMake(0, 0, sSize.width, sSize.height)];
    }
    else if (sAngle == 90 || sAngle == 270)
    {
        [mOriginalImage drawInRect:CGRectMake(0, 0, sSize.height, sSize.width)];
    }

    [mResizedImage release];
    mResizedImage = UIGraphicsGetImageFromCurrentImageContext();
    [mResizedImage retain];

    UIGraphicsEndImageContext();

    [self updateImageInfo];
}


- (void)resizeImageToMidSize
{
    mLongSideLength = 500.0;
    [self resizeImage];
}


- (void)resizeImageToLargeSize
{
    mLongSideLength = 1024.0;
    [self resizeImage];
}


- (void)resizeImageToOriginalSize
{
    [mResizedImage release];
    mResizedImage = [mOriginalImage retain];
    [self updateImageInfo];
}


- (void)arrangeIconButtons:(UIInterfaceOrientation)aInterfaceOrientation
{
    MEImageButton *sButton = nil;
    NSInteger      i;
    NSInteger      sCount = [mIconButtons count];
    CGFloat        sXPos;
    CGFloat        sYPos;
    CGFloat        sXPosBegin;
    CGFloat        sYPosBegin;

    if (aInterfaceOrientation == UIDeviceOrientationPortrait || aInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        sXPosBegin = 28;
        sYPosBegin = 20;
        sXPos      = sXPosBegin;
        sYPos      = sYPosBegin;

        for (i = 0; i < sCount; i++)
        {
            sButton = [mIconButtons objectAtIndex:i];
            [sButton setFrame:CGRectMake(sXPos, sYPos, 46, 46)];
            if ((i + 1) == mSelectedIconIndex)
            {
                [mCheckmarkImageView setFrame:CGRectMake(sXPos - 10, sYPos - 20, 46, 46)];
            }
            if ((i % 4) == 3)
            {
                sXPos  = sXPosBegin;
                sYPos += (46 + 10);
            }
            else
            {
                sXPos += (46 + 10);
            }
        }
    }
    else if (aInterfaceOrientation == UIDeviceOrientationLandscapeRight || aInterfaceOrientation == UIDeviceOrientationLandscapeLeft)
    {
        sXPosBegin = 44;
        sYPosBegin = 16;
        sXPos      = sXPosBegin;
        sYPos      = sYPosBegin;

        for (i = 0; i < sCount; i++)
        {
            sButton = [mIconButtons objectAtIndex:i];
            [sButton setFrame:CGRectMake(sXPos, sYPos, 46, 46)];
            if ((i + 1) == mSelectedIconIndex)
            {
                [mCheckmarkImageView setFrame:CGRectMake(sXPos - 10, sYPos - 20, 46, 46)];
            }
            if ((i % 6) == 5)
            {
                sXPos  = sXPosBegin;
                sYPos += (46 + 10);
            }
            else
            {
                sXPos += (46 + 10);
            }
        }
    }

    [mIconImageView bringSubviewToFront:mCheckmarkImageView];
}


- (void)arrangeImageButtons:(UIInterfaceOrientation)aInterfaceOrientation
{
    if (aInterfaceOrientation == UIDeviceOrientationPortrait || aInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        [mImageViewContainer     setFrame:CGRectMake( 28, 213, 92, 92)];
        [mTakePictureButton      setFrame:CGRectMake(134, 213, 45, 37)];
        [mFromPhotoLibraryButton setFrame:CGRectMake(134, 258, 45, 37)];
        [mRotateLeftButton       setFrame:CGRectMake( 28, 319, 45, 37)];
        [mRotateRightButton      setFrame:CGRectMake( 81, 319, 45, 37)];
        [mResizeButton           setFrame:CGRectMake(134, 319, 45, 37)];
        [mImageResolutionLabel   setFrame:CGRectMake( 28, 364, 92, 21)];
        [mImageSizeLabel         setFrame:CGRectMake(134, 364, 84, 21)];
    }
    else if (aInterfaceOrientation == UIDeviceOrientationLandscapeRight || aInterfaceOrientation == UIDeviceOrientationLandscapeLeft)
    {
        [mImageViewContainer     setFrame:CGRectMake( 44, 136, 92, 92)];
        [mTakePictureButton      setFrame:CGRectMake(150, 136, 45, 37)];
        [mFromPhotoLibraryButton setFrame:CGRectMake(208, 136, 45, 37)];
        [mRotateLeftButton       setFrame:CGRectMake(150, 191, 45, 37)];
        [mRotateRightButton      setFrame:CGRectMake(208, 191, 45, 37)];
        [mResizeButton           setFrame:CGRectMake(266, 191, 45, 37)];
        [mImageResolutionLabel   setFrame:CGRectMake( 44, 240, 92, 21)];
        [mImageSizeLabel         setFrame:CGRectMake(150, 240, 84, 21)];
    }
}


- (void)arrangeSubviews:(UIInterfaceOrientation)aInterfaceOrientation
{
    UIImage  *sTabOnImage  = [[UIImage imageNamed:@"selectedTab.png"] stretchableImageWithLeftCapWidth:11 topCapHeight:10];
    UIImage  *sTabOffImage = [[UIImage imageNamed:@"tab2.png"] stretchableImageWithLeftCapWidth:11 topCapHeight:10];
    UIButton *sTabButton   = nil;
    UIView   *sCurrentView = nil;
    CGRect    sFrame;

    [mTabBodyButton      setBackgroundImage:sTabOffImage forState:UIControlStateNormal];
    [mTabTagButton       setBackgroundImage:sTabOffImage forState:UIControlStateNormal];
    [mTabIconImageButton setBackgroundImage:sTabOffImage forState:UIControlStateNormal];

    sTabButton   = (mSelectedTabIndex == 0) ? mTabBodyButton : ((mSelectedTabIndex == 1) ? mTabTagButton : mTabIconImageButton);
    sCurrentView = (mSelectedTabIndex == 0) ? mBodyView      : ((mSelectedTabIndex == 1) ? mTagView      : mIconImageView);

    if (sCurrentView != mCurrentView)
    {
        [mCurrentView removeFromSuperview];
        mCurrentView = sCurrentView;
    }

    if (aInterfaceOrientation == UIDeviceOrientationPortrait || aInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        [mTabContainerView   setFrame:CGRectMake( 0,  44, 320, 416)];
        [mTabBodyButton      setFrame:CGRectMake( 7,  10, 40,  63)];
        [mTabTagButton       setFrame:CGRectMake( 7,  70, 40,  63)];
        [mTabIconImageButton setFrame:CGRectMake( 7, 130, 40,  63)];
        [mSplitBar           setFrame:CGRectMake(47,   0,  5, 416)];
        [mCurrentView        setFrame:CGRectMake(51, 0, 320 - 51, (mCurrentView == mIconImageView) ? 416 : 200)];

        [mTabBodyButton      setImage:[UIImage imageNamed:@"tabWrite.png"]   forState:UIControlStateNormal];
        [mTabTagButton       setImage:[UIImage imageNamed:@"tabTag.png"]     forState:UIControlStateNormal];
        [mTabIconImageButton setImage:[UIImage imageNamed:@"tabAttach.png"] forState:UIControlStateNormal];
    }
    else if (aInterfaceOrientation == UIDeviceOrientationLandscapeRight || aInterfaceOrientation == UIDeviceOrientationLandscapeLeft)
    {
        [mTabContainerView   setFrame:CGRectMake(0, 32, 480, 269)];
        [mTabBodyButton      setFrame:CGRectMake(7,  8,  60,  33)];
        [mTabTagButton       setFrame:CGRectMake(7, 38,  60,  33)];
        [mTabIconImageButton setFrame:CGRectMake(7, 68,  60,  33)];
        [mSplitBar           setFrame:CGRectMake(67, 0,   5, 269)];
        [mCurrentView        setFrame:CGRectMake(70, 0, 480 - 70, (mCurrentView == mIconImageView) ? 269 : 106)];

        [mTabBodyButton      setImage:[UIImage imageNamed:@"tabWrite_h.png"]   forState:UIControlStateNormal];
        [mTabTagButton       setImage:[UIImage imageNamed:@"tabTag_h.png"]     forState:UIControlStateNormal];
        [mTabIconImageButton setImage:[UIImage imageNamed:@"tabAttach_h.png"] forState:UIControlStateNormal];
    }

    [self arrangeIconButtons:aInterfaceOrientation];
    [self arrangeImageButtons:aInterfaceOrientation];

    sFrame = [mCurrentView frame];
    [mCountLabel setFrame:CGRectMake(sFrame.origin.x + sFrame.size.width - 60, sFrame.size.height - 40, 60, 40)];
    [mCountLabel setHidden:(sTabButton == mTabIconImageButton) ? YES : NO];

    [sTabButton setBackgroundImage:sTabOnImage forState:UIControlStateNormal];
    [mTabContainerView addSubview:mCurrentView];
    [mTabContainerView bringSubviewToFront:sTabButton];
    [mTabContainerView bringSubviewToFront:mSplitBar];
    [mTabContainerView bringSubviewToFront:mCountLabel];
}


- (void)showUploadActivityWindow
{
    UILabel *sLabel;

    if (!mUploadActivityWindow)
    {
        mUploadActivityWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

        mUploadActivityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        [mUploadActivityWindow addSubview:mUploadActivityView];
        [mUploadActivityView release];

        sLabel = [[UILabel alloc] initWithFrame:[mUploadActivityView bounds]];
        [sLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [sLabel setBackgroundColor:[UIColor clearColor]];
        [sLabel setTextAlignment:UITextAlignmentCenter];
        [sLabel setTextColor:[UIColor whiteColor]];
        [sLabel setText:@"Uploading..."];
        [mUploadActivityView addSubview:sLabel];
        [sLabel release];

        mUploadProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [mUploadProgressView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [mUploadProgressView setFrame:CGRectMake(80, 200, 160, 11)];
        [mUploadActivityView addSubview:mUploadProgressView];
        [mUploadProgressView release];

        [mUploadActivityWindow setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
        [mUploadActivityWindow setWindowLevel:UIWindowLevelAlert];
        [mUploadActivityWindow makeKeyAndVisible];

        [self layoutUploadActivityViewForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    }
}


- (void)hideUploadActivityWindow
{
    [mUploadActivityWindow release];

    mUploadActivityWindow = nil;
    mUploadActivityView   = nil;
    mUploadProgressView   = nil;

    [[[self view] window] makeKeyAndVisible];
}


- (void)layoutUploadActivityViewForInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    switch (aInterfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
            [mUploadActivityView setTransform:CGAffineTransformMake(0, -1, 1, 0, 0, 0)];
            [mUploadActivityView setBounds:CGRectMake(0, 0, 480, 160)];
            [mUploadActivityView setCenter:CGPointMake(80, 240)];
            break;

        case UIInterfaceOrientationLandscapeRight:
            [mUploadActivityView setTransform:CGAffineTransformMake(0, 1, -1, 0, 0, 0)];
            [mUploadActivityView setBounds:CGRectMake(0, 0, 480, 160)];
            [mUploadActivityView setCenter:CGPointMake(240, 240)];
            break;

        case UIInterfaceOrientationPortrait:
            [mUploadActivityView setTransform:CGAffineTransformIdentity];
            [mUploadActivityView setBounds:CGRectMake(0, 0, 320, 260)];
            [mUploadActivityView setCenter:CGPointMake(160, 130)];
            break;

        case UIInterfaceOrientationPortraitUpsideDown:
            [mUploadActivityView setTransform:CGAffineTransformMake(-1, 0, 0, -1, 0, 0)];
            [mUploadActivityView setBounds:CGRectMake(0, 0, 320, 260)];
            [mUploadActivityView setCenter:CGPointMake(160, 350)];
            break;
    }
}


@end


@implementation MEWriteViewController


#pragma mark -
#pragma mark properties


@synthesize navigationBar          = mNavigationBar;
@synthesize tabContainerView       = mTabContainerView;
@synthesize tabBodyButton          = mTabBodyButton;
@synthesize tabTagButton           = mTabTagButton;
@synthesize tabIconImageButton     = mTabIconImageButton;
@synthesize splitBar               = mSplitBar;
@synthesize bodyView               = mBodyView;
@synthesize tagView                = mTagView;
@synthesize iconImageView          = mIconImageView;
@synthesize bodyTextView           = mBodyTextView;
@synthesize tagTextView            = mTagTextView;
@synthesize countLabel             = mCountLabel;

//  IconImageView

@synthesize checkmarkImageView     = mCheckmarkImageView;
@synthesize imageViewContainer     = mImageViewContainer;
@synthesize attachedImageView      = mAttachedImageView;
@synthesize takePictureButton      = mTakePictureButton;
@synthesize fromPhotoLibraryButton = mFromPhotoLibraryButton;
@synthesize rotateLeftButton       = mRotateLeftButton;
@synthesize rotateRightButton      = mRotateRightButton;
@synthesize resizeButton           = mResizeButton;

@synthesize imageResolutionLabel   = mImageResolutionLabel;
@synthesize imageSizeLabel         = mImageSizeLabel;


#pragma mark -
#pragma mark init / dealloc


+ (void)initialize
{
    if (!gActions)
    {
        gActions = [[NSDictionary alloc] initWithObjectsAndKeys:@"resizeImageToMidSize", NSLocalizedString(@"Mid Size", nil),
                                                                @"resizeImageToLargeSize", NSLocalizedString(@"Big Size", nil),
                                                                @"resizeImageToOriginalSize", NSLocalizedString(@"Original Size", nil), nil];
    }
}


- (id)init
{
    self = [super initWithNibName:@"WriteView" bundle:nil];

    if (self)
    {
    }

    return self;
}


- (id)initWithCallUserID:(NSString *)aUserID
{
    self = [super initWithNibName:@"WriteView" bundle:nil];

    if (self)
    {
        mText = [[NSString alloc] initWithFormat:@"/%@/ ", aUserID];
    }

    return self;
}


- (id)initWithPingbackLink:(NSString *)aPermLink
{
    self = [super initWithNibName:@"WriteView" bundle:nil];

    if (self)
    {
        mText = [[NSString alloc] initWithFormat:@"\"\":%@ ", aPermLink];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
    }

    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [mIconButtons   release];

    [mOriginalImage release];
    [mResizedImage  release];
    [mImageRep      release];

    [mBodyView      release];
    [mTagView       release];
    [mIconImageView release];

    [mText release];

    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // do nothing
}


- (void)createIconButtons
{
    MEImageButton *sButton;
    NSInteger      i;
    MEUser        *sUser = [MEUser userWithUserID:[[MEClientStore currentClient] userID]];

    mSelectedIconIndex = [[sUser defaultPostIcon] iconIndex];
    mIconButtons       = [[NSMutableArray alloc] init];

    for (i = 0; i < 12; i++)
    {
        sButton = [[MEImageButton alloc] initWithFrame:CGRectZero];
        [sButton addTarget:self action:@selector(iconSelected:) forControlEvents:UIControlEventTouchUpInside];
        [sButton setBorderColor:[UIColor lightGrayColor]];

        [mIconImageView addSubview:sButton];

        [mIconButtons addObject:sButton];
        [sButton release];
    }

    NSArray    *sPostIcons = [sUser postIcons];
    MEPostIcon *sPostIcon  = nil;
    for (sPostIcon in sPostIcons)
    {
        sButton = [mIconButtons objectAtIndex:([sPostIcon iconIndex] - 1)];
        [sButton setImageWithURL:[sPostIcon iconURL]];
    }

    [mCheckmarkImageView setAlpha:0.8];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [mBodyTextView setReturnKeyType:UIReturnKeyNext];
    [mTagTextView  setReturnKeyType:UIReturnKeyNext];

    {   //  IconImageView
        [mTakePictureButton setEnabled:[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]];

        [self createIconButtons];

        [mRotateLeftButton     setEnabled:NO];
        [mRotateRightButton    setEnabled:NO];
        [mResizeButton         setEnabled:NO];
        [mImageResolutionLabel setText:@""];
        [mImageSizeLabel       setText:@""];
    }

    mSelectedTabIndex = 0;
    mIsImageModified  = NO;

    if (mText)
    {
        [mBodyTextView setText:mText];
    }
    else
    {
        [self performSelector:@selector(checkDraft) withObject:nil afterDelay:0];
    }

    [mNavigationBar sizeToFit];
    [self arrangeSubviews:[[UIApplication sharedApplication] statusBarOrientation]];

    [mBodyTextView becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)aToInterfaceOrientation duration:(NSTimeInterval)aDuration
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:aDuration];
    [self arrangeSubviews:aToInterfaceOrientation];
    [self layoutUploadActivityViewForInterfaceOrientation:aToInterfaceOrientation];
    [UIView commitAnimations];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)aFromInterfaceOrientation
{
    [mNavigationBar sizeToFit];
}


#pragma mark -
#pragma mark Actions


- (IBAction)close
{
    [self savePostAsDraft];
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)upload
{
    NSString   *sBody   = [mBodyTextView text];
    NSString   *sTags   = [mTagTextView  text];
    NSUInteger  sLength = [sBody lengthMe2DAY];

    if (sLength == 0)
    {
        [UIAlertView showAlert:NSLocalizedString(@"Empty post body", @"")];
    }
    else if (sLength > kMEPostBodyMaxLen)
    {
        [UIAlertView showAlert:NSLocalizedString(@"Too long post body", @"")];
    }
    else
    {
        if ([sTags length] > kMEPostTagMaxLen)
        {
            [UIAlertView showAlert:NSLocalizedString(@"Too long post tag", @"")];
        }
        else
        {
            [self savePostAsDraft];
            [self showUploadActivityWindow];

            [[MEClientStore currentClient] createPostWithBody:sBody
                                                         tags:sTags
                                                         icon:mSelectedIconIndex
                                                attachedImage:mResizedImage
                                                     delegate:self];
        }
    }
}


#pragma mark -


- (IBAction)bodyTabButtonTapped:(id)aSender
{
    [mBodyTextView becomeFirstResponder];
    mSelectedTabIndex = 0;
    [self arrangeSubviews:[self interfaceOrientation]];
}


- (IBAction)tagTabButtonTapped:(id)aSender
{
    [mTagTextView becomeFirstResponder];
    mSelectedTabIndex = 1;
    [self arrangeSubviews:[self interfaceOrientation]];
}


- (IBAction)iconImageTabButtontapped:(id)aSender
{
    mSelectedTabIndex = 2;
    [self arrangeSubviews:[self interfaceOrientation]];
}


#pragma mark -


- (IBAction)iconSelected:(id)aSender
{
    MEImageButton *sButton = (MEImageButton *)aSender;
    if ([sButton imageURL])
    {
        mSelectedIconIndex = ([mIconButtons indexOfObject:aSender] + 1);
        [self arrangeSubviews:[self interfaceOrientation]];
    }
}


- (IBAction)takePictureButtonTapped:(id)aSender
{
    UIImagePickerController *sImagePickerController;

    sImagePickerController = [[UIImagePickerController alloc] init];
    [sImagePickerController setDelegate:self];
    [sImagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentModalViewController:sImagePickerController animated:NO];
    [sImagePickerController release];
}


- (IBAction)fromPhotoLibraryButtonTapped:(id)aSender
{
    UIImagePickerController *sImagePickerController;

    sImagePickerController = [[UIImagePickerController alloc] init];
    [sImagePickerController setDelegate:self];
    [sImagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentModalViewController:sImagePickerController animated:NO];
    [sImagePickerController release];
}


- (IBAction)rotateLeftButtonTapped:(id)aSender
{
    mRotateAngle -= 90;
    [self resizeImage];
}


- (IBAction)rotateRightButtonTapped:(id)aSender
{
    mRotateAngle += 90;
    [self resizeImage];
}


- (IBAction)resizeButtonTapped:(id)aSender
{
    UIActionSheet *sActionSheet  = nil;

    if (mIsMiddleSizeEnabled && mIsLargeSizeEnabled)
    {
        sActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Resize Photo Size", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"Mid Size", nil),
                                                            NSLocalizedString(@"Big Size", nil),
                                                            NSLocalizedString(@"Original Size", nil), nil];
    }
    else if (mIsMiddleSizeEnabled && !mIsLargeSizeEnabled)
    {
        sActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Resize Photo Size", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"Mid Size", nil),
                                                            NSLocalizedString(@"Original Size", nil), nil];
    }

    [sActionSheet showInView:[self view]];
    [sActionSheet release];
}


#pragma mark -
#pragma mark UIKeyboard Notifications


- (void)keyboardDidShow:(NSNotification *)aNotification
{
    if ([[mBodyTextView text] isEqualToString:mText])
    {
        [mBodyTextView setSelectedRange:NSMakeRange(1, 0)];
    }
}


#pragma mark -
#pragma mark UITextViewDelegate


- (void)updateCharCounter:(UITextView *)aTextView
{
    NSString *sText = [aTextView text];
    NSInteger sRemainCount;

    if (aTextView == mBodyTextView)
    {
        sRemainCount = kMEPostBodyMaxLen - [sText lengthMe2DAY];
    }
    else if (aTextView == mTagTextView)
    {
        sRemainCount = kMEPostBodyMaxLen - [sText length];
    }

    [mCountLabel setHighlighted:((sRemainCount < 0) ? YES : NO)];
    [mCountLabel setText:[NSString stringWithFormat:@"%d", sRemainCount]];
}


- (void)textViewDidBeginEditing:(UITextView *)aTextView;
{
    [self updateCharCounter:aTextView];
}


- (void)textViewDidEndEditing:(UITextView *)aTextView
{

}


- (void)textViewDidChange:(UITextView *)aTextView
{
    [self updateCharCounter:aTextView];

    if ([aTextView hasText])
    {
        NSRange sRange = [aTextView selectedRange];
        if (sRange.location < [[aTextView text] length])
        {
            [aTextView scrollRangeToVisible:sRange];
        }
    }
}


- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)aRange replacementText:(NSString *)aText
{
    if (([aText length] == 1) && ([aText characterAtIndex:0] == '\n'))
    {
        if (aTextView == mBodyTextView)
        {
            [self tagTabButtonTapped:nil];
        }
        else
        {
            [self iconImageTabButtontapped:nil];
        }

        return NO;
    }
    else
    {
        if ([aText rangeOfString:@"\n"].location != NSNotFound)
        {
            aText = [aText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

            [aTextView setText:[[aTextView text] stringByReplacingCharactersInRange:aRange withString:aText]];

            return NO;
        }
        else
        {
            return YES;
        }
    }
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didCreatePostWithError:(NSError *)aError
{
    [self hideUploadActivityWindow];

    if (aError)
    {
        [UIAlertView showError:aError];
    }
    else
    {
        [MEDraft clearLastDraftWithUserID:[[MEClientStore currentClient] userID]];
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark MEClientOperationDelegate


- (void)clientOperation:(MEClientOperation *)aOperation didSendDataProgress:(float)aProgress
{
    [mUploadProgressView setProgress:aProgress];
}


#pragma mark -
#pragma mark UIImagePickerDelegate


- (void)imagePickerController:(UIImagePickerController *)aPicker
        didFinishPickingImage:(UIImage *)aImage
                  editingInfo:(NSDictionary *)aEditingInfo
{
    mIsImageModified = ([aPicker sourceType] == UIImagePickerControllerSourceTypeCamera) ? YES : NO;
    if (mIsImageModified == YES)
    {
        if ([MESettings saveToPhotosAlbum])
        {
            UIImageWriteToSavedPhotosAlbum(aImage, nil, nil, nil);
        }
    }

    [mOriginalImage autorelease];
    [mResizedImage  autorelease];

    mOriginalImage = [aImage retain];
    mResizedImage  = [mOriginalImage retain];

    [mAttachedImageView setImage:mOriginalImage];

    CGSize  sImageSize   = [mOriginalImage size];
    mLongSideLength      = MAX(sImageSize.width, sImageSize.height);
    mIsMiddleSizeEnabled = (mLongSideLength > 500) ? YES : NO;
    mIsLargeSizeEnabled  = (mLongSideLength > 1024) ? YES : NO;

    [mRotateLeftButton  setEnabled:YES];
    [mRotateRightButton setEnabled:YES];
    [mResizeButton      setEnabled:(mIsMiddleSizeEnabled || mIsLargeSizeEnabled) ? YES : NO];

    [self updateImageInfo];

    [aPicker dismissModalViewControllerAnimated:NO];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker
{
    [aPicker dismissModalViewControllerAnimated:NO];
}


#pragma mark -
#pragma mark UIAlertViewDelegate


- (void)alertView:(UIAlertView *)aAlertView clickedButtonAtIndex:(NSInteger)aButtonIndex
{
    if (aButtonIndex != [aAlertView cancelButtonIndex])
    {
        [self loadDraft];
    }
}


#pragma mark -
#pragma mark UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)aActionSheet didDismissWithButtonIndex:(NSInteger)aButtonIndex
{
    if (aButtonIndex != [aActionSheet cancelButtonIndex])
    {
        SEL sSelector = NSSelectorFromString([gActions objectForKey:[aActionSheet buttonTitleAtIndex:aButtonIndex]]);

        if (sSelector)
        {
            [self performSelector:sSelector];
        }
    }
}


@end
