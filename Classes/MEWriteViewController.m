/*
 *  MEWriteViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIAlertView+MEAdditions.h"
#import "MEWriteViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEDrawingFunctions.h"
#import "MEUser.h"
#import "MEPost.h"
#import "MEPostIcon.h"
#import "MEImageButton.h"
#import <math.h>


static double radians(double degrees) {return degrees * M_PI/180;}


#define IMAGE_PORTRAIT_MODE     0
#define IMAGE_LANDSCAPE_MODE    1


@interface MEWriteViewController (Privates)

- (void)setInterfaceEnabled:(BOOL)aFlag;
- (void)updateImageInfo;
- (void)resizeImage;

- (void)arrangeSubviews:(UIInterfaceOrientation)aToInterfaceOrientation;

@end


@implementation MEWriteViewController (Privates)


- (void)setInterfaceEnabled:(BOOL)aFlag
{
    // TODO
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
    CGSize sSize      = CGSizeZero;
    CGSize sImageSize = [mOriginalImage size];

    if (mImageDir == IMAGE_PORTRAIT_MODE)
    {
        sSize.height = mLongSideLength;
        sSize.width  = sImageSize.width * sSize.height / sImageSize.height;
    }
    else
    {
        sSize.width = mLongSideLength;
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

    CGContextSetLineWidth(sContext, 10);
    [[UIColor redColor] set];

    /*    if (sAngle == 0 || sAngle == 180)
     {
     UIRectFrame(CGRectMake(0, 0, sSize.width, sSize.height));
     }
     else if (sAngle == 90 || sAngle == 270)
     {
     UIRectFrame(CGRectMake(0, 0, sSize.height, sSize.width));
     }*/

    [mResizedImage release];
    mResizedImage = UIGraphicsGetImageFromCurrentImageContext();
    [mResizedImage retain];

    UIGraphicsEndImageContext();

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
    }
    else if (aInterfaceOrientation == UIDeviceOrientationLandscapeRight || aInterfaceOrientation == UIDeviceOrientationLandscapeLeft)
    {
        [mTabContainerView   setFrame:CGRectMake(0, 32, 480, 269)];
        [mTabBodyButton      setFrame:CGRectMake(7,  8,  60,  33)];
        [mTabTagButton       setFrame:CGRectMake(7, 38,  60,  33)];
        [mTabIconImageButton setFrame:CGRectMake(7, 68,  60,  33)];
        [mSplitBar           setFrame:CGRectMake(67, 0,   5, 269)];
        [mCurrentView        setFrame:CGRectMake(70, 0, 480 - 70, (mCurrentView == mIconImageView) ? 269 : 106)];
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


- (id)init
{
    self = [super initWithNibName:@"WriteView" bundle:nil];

    if (self)
    {

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

    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    NSString *sModel;

    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChangeNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];

    [mBodyTextView setReturnKeyType:UIReturnKeyNext];
    [mTagTextView  setReturnKeyType:UIReturnKeyNext];

    {   //  IconImageView
        sModel = [[UIDevice currentDevice] model];
        if (![sModel isEqualToString:@"iPhone"])
        {
            [mTakePictureButton setEnabled:NO];
        }

        [self createIconButtons];

        [mRotateLeftButton     setEnabled:NO];
        [mRotateRightButton    setEnabled:NO];
        [mResizeButton         setEnabled:NO];
        [mImageResolutionLabel setText:@""];
        [mImageSizeLabel       setText:@""];
    }

    mSelectedTabIndex = 0;
    [self arrangeSubviews:[self interfaceOrientation]];

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
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)upload
{
    NSString *sBody = [mBodyTextView text];
    NSString *sTags = [mTagTextView  text];

    if ([sBody length] > 0)
    {
        [self setInterfaceEnabled:NO];
        [mBodyTextView resignFirstResponder];
        [mTagTextView  resignFirstResponder];

        [[MEClientStore currentClient] createPostWithBody:sBody tags:sTags icon:mSelectedIconIndex attachedImage:mResizedImage delegate:self];
    }
    else
    {
        [UIAlertView showAlert:NSLocalizedString(@"Please enter contents.", @"")];
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
    UIApplication           *sApp                   = [UIApplication sharedApplication];
    UIWindow                *sKeyWindow             = [sApp keyWindow];
    UIImagePickerController *sImagePickerController = [[UIImagePickerController alloc] init];

    [sImagePickerController setDelegate:self];
    [sImagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [sKeyWindow addSubview:[sImagePickerController view]];
    [sKeyWindow bringSubviewToFront:[sImagePickerController view]];
}


- (IBAction)fromPhotoLibraryButtonTapped:(id)aSender
{
    UIApplication           *sApp                   = [UIApplication sharedApplication];
    UIWindow                *sKeyWindow             = [sApp keyWindow];
    UIImagePickerController *sImagePickerController = [[UIImagePickerController alloc] init];

    [sImagePickerController setDelegate:self];
    [sImagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [sKeyWindow addSubview:[sImagePickerController view]];
    [sKeyWindow bringSubviewToFront:[sImagePickerController view]];
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
        mMiddleSizeButtonIndex   = 0;
        mLargeSizeButtonIndex    = 1;
        mOriginalSizeButtonIndex = 2;
        mCancelButtonIndex       = 3;
    }
    else if (mIsMiddleSizeEnabled && !mIsLargeSizeEnabled)
    {
        sActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Resize Photo Size", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"Mid Size", nil),
                                                            NSLocalizedString(@"Original Size", nil), nil];
        mMiddleSizeButtonIndex   = 0;
        mOriginalSizeButtonIndex = 1;
        mCancelButtonIndex       = 2;
    }

    [sActionSheet showInView:[self view]];
    [sActionSheet release];
}


#pragma mark -
#pragma mark TextViewDelegate


- (void)updateCharCounter:(UITextView *)aTextView
{
    NSString *sText = [aTextView text];
    NSInteger sRemainCount;
    
    if (aTextView == mBodyTextView)
    {
        sRemainCount = kMEPostBodyMaxLen - [sText length];
    }
    else if (aTextView == mTagTextView)
    {
        sRemainCount = kMEPostBodyMaxLen - [sText length];
    }
    
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
    if ([aText length] == 1 && [aText characterAtIndex:0] == 10)
    {
        if (aTextView == mBodyTextView)
        {
            [self tagTabButtonTapped:nil];
        }
        else
        {
            [self iconImageTabButtontapped:nil];
        }
    }
    else
    {
        NSString *sBody    = [aTextView text];
        NSString *sNewText = [sBody stringByReplacingCharactersInRange:aRange withString:aText];
        if ([sNewText length] > kMEPostBodyMaxLen)
        {
            UIAlertView *sAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                             message:NSLocalizedString(@"You have exceeded limit the number of input characters.", nil)
                                                            delegate:nil
                                                   cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                                   otherButtonTitles:nil];
            [sAlert show];

            return NO;
        }
    }
    
    return YES;
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didCreatePostWithError:(NSError *)aError
{
    if (aError)
    {
        [UIAlertView showError:aError];
        [self setInterfaceEnabled:YES];
        [mBodyTextView resignFirstResponder];
        [mTagTextView  resignFirstResponder];
    }
    else
    {
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark UIImagePickerDelegate


- (void)imagePickerController:(UIImagePickerController *)aPicker
        didFinishPickingImage:(UIImage *)aImage
                  editingInfo:(NSDictionary *)aEditingInfo
{
    [aPicker dismissModalViewControllerAnimated:YES];
    [[aPicker view] setHidden:YES];
    [[aPicker view] removeFromSuperview];
    [aPicker autorelease];

    [mOriginalImage autorelease];
    [mResizedImage  autorelease];

    mOriginalImage = [aImage retain];
    mResizedImage  = [mOriginalImage retain];

    [mAttachedImageView setImage:mOriginalImage];

    CGSize  sImageSize   = [mOriginalImage size];
    mLongSideLength      = MAX(sImageSize.width, sImageSize.height);
    mIsMiddleSizeEnabled = (mLongSideLength > 500) ? YES : NO;
    mIsLargeSizeEnabled  = (mLongSideLength > 1024) ? YES : NO;
    mImageDir            = (sImageSize.width > sImageSize.height) ? IMAGE_LANDSCAPE_MODE : IMAGE_PORTRAIT_MODE;

    [mRotateLeftButton  setEnabled:YES];
    [mRotateRightButton setEnabled:YES];
    [mResizeButton      setEnabled:(mIsMiddleSizeEnabled || mIsLargeSizeEnabled) ? YES : NO];

    [self updateImageInfo];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker
{
    [aPicker dismissModalViewControllerAnimated:YES];
    [[aPicker view] setHidden:YES];
    [[aPicker view] removeFromSuperview];
    [aPicker autorelease];
}


#pragma mark -
#pragma mark UIActionSheet Delegate


- (void)actionSheet:(UIActionSheet *)aActionSheet didDismissWithButtonIndex:(NSInteger)aButtonIndex
{
    if (aButtonIndex == mMiddleSizeButtonIndex)
    {
        mLongSideLength = 500.0;
        [self resizeImage];
    }
    else if (aButtonIndex == mLargeSizeButtonIndex)
    {
        mLongSideLength = 1024.0;
        [self resizeImage];
    }
    else if (aButtonIndex == mOriginalSizeButtonIndex)
    {
        [mResizedImage release];
        mResizedImage = [mOriginalImage retain];
        [self updateImageInfo];
    }
    else if (aButtonIndex == mCancelButtonIndex)
    {
    }
}


@end
