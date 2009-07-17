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
#import "MECharCounter.h"
#import "MEIconListView.h"
#import "MEUser.h"
#import "MEPost.h"
#import "MEPostIcon.h"
#import "MEImageButton.h"
#import <math.h>


static double radians(double degrees) {return degrees * M_PI/180;}


#define IMAGE_PORTRAIT_MODE     0
#define IMAGE_LANDSCAPE_MODE    1


#define BEGIN_ANIMATION_OFF()       [CATransaction begin]; \
                                    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
#define END_ANIMATION_OFF()         [CATransaction commit];



@interface MEWriteViewController (Privates)

- (void)setInterfaceEnabled:(BOOL)aFlag;
- (void)updateSelectedIcon;
- (void)updateImageInfo;
- (void)resizeImage;
- (void)arrangeSubviews;

@end


@implementation MEWriteViewController (Privates)


- (void)setInterfaceEnabled:(BOOL)aFlag
{
    // TODO
}


- (void)updateSelectedIcon
{
    MEUser     *sUser      = [MEUser userWithUserID:[[MEClientStore currentClient] userID]];
    NSArray    *sPostIcons = [sUser postIcons];
    MEPostIcon *sPostIcon  = nil;
    NSArray    *sDescArray = [NSArray arrayWithObjects:NSLocalizedString(@"Think Icon", nil),
                                                       NSLocalizedString(@"Feeling Icon", nil),
                                                       NSLocalizedString(@"Notice Icon", nil), nil];
    NSString   *sDesc      = nil;

    for (sPostIcon in sPostIcons)
    {
        if ([sPostIcon iconIndex] == mSelectedIconIndex)
        {
            break;
        }
    }

    sDesc = (mSelectedIconIndex < 4) ? [sDescArray objectAtIndex:(mSelectedIconIndex - 1)] : [sPostIcon iconDescription];
    [mIconDescLabel    setText:sDesc];
    [mIconSelectButton setImageWithURL:[sPostIcon iconURL]];
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


- (void)arrangeSubviews
{
    UIInterfaceOrientation sOrientation = [self interfaceOrientation];    
    UIImage               *sTabOnImage  = [[UIImage imageNamed:@"selectedTab.png"] stretchableImageWithLeftCapWidth:11 topCapHeight:10];
    UIImage               *sTabOffImage = [[UIImage imageNamed:@"tab2.png"] stretchableImageWithLeftCapWidth:11 topCapHeight:10];
    CGRect                 sNavigationFrame;
    UIButton              *sTabButton = nil;    
    
    [mTabBodyButton      setBackgroundImage:sTabOffImage forState:UIControlStateNormal];
    [mTabTagButton       setBackgroundImage:sTabOffImage forState:UIControlStateNormal];
    [mTabIconImageButton setBackgroundImage:sTabOffImage forState:UIControlStateNormal];
    
    [mNavigationBar sizeToFit];
    sNavigationFrame = [mNavigationBar frame];
    
    [mCurrentView removeFromSuperview];
    
    sTabButton   = (mSelectedTabIndex == 0) ? mTabBodyButton : ((mSelectedTabIndex == 1) ? mTabTagButton : mTabIconImageButton);
    mCurrentView = (mSelectedTabIndex == 0) ? mBodyView      : ((mSelectedTabIndex == 1) ? mTagView      : mIconImageView);

    if (sOrientation == UIDeviceOrientationPortrait || sOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        [mTabContainerView   setFrame:CGRectMake( 0, sNavigationFrame.origin.y + sNavigationFrame.size.height, 320, 200)];
        [mTabBodyButton      setFrame:CGRectMake( 7,  10, 40,  63)];
        [mTabTagButton       setFrame:CGRectMake( 7,  70, 40,  63)];
        [mTabIconImageButton setFrame:CGRectMake( 7, 130, 40,  63)];
        [mSplitBar           setFrame:CGRectMake(47,   0,  5, 200)];
        [mCurrentView        setFrame:CGRectMake(51, 0, 320 - 51, 200)];
    }
    else if (sOrientation == UIDeviceOrientationLandscapeRight || sOrientation == UIDeviceOrientationLandscapeLeft)
    {
        [mTabContainerView   setFrame:CGRectMake(0, sNavigationFrame.origin.y + sNavigationFrame.size.height, 480, 106)];
        [mTabBodyButton      setFrame:CGRectMake(7,  8, 60,  32)];
        [mTabTagButton       setFrame:CGRectMake(7, 38, 60,  32)];
        [mTabIconImageButton setFrame:CGRectMake(7, 68, 60,  32)];
        [mSplitBar           setFrame:CGRectMake(67, 0,  5, 106)];
        [mCurrentView        setFrame:CGRectMake(70, 0, 480 - 70, 106)];        
    }

    [sTabButton setBackgroundImage:sTabOnImage forState:UIControlStateNormal];
    [mTabContainerView addSubview:mCurrentView];    
    [mTabContainerView bringSubviewToFront:sTabButton];
    [mTabContainerView bringSubviewToFront:mSplitBar];
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

//////////////////

@synthesize attachedImageView      = mAttachedImageView;

@synthesize iconSelectButton       = mIconSelectButton;
@synthesize iconDescLabel          = mIconDescLabel;

@synthesize takePictureButton      = mTakePictureButton;
@synthesize fromPhotoLibraryButton = mFromPhotoLibraryButton;
@synthesize rotateLeftButton       = mRotateLeftButton;
@synthesize rotateRightButton      = mRotateRightButton;
@synthesize resizeButton           = mResizeButton;

@synthesize imageResolutionLabel   = mImageResolutionLabel;
@synthesize imageSizeLabel         = mImageSizeLabel;

@synthesize iconListView           = mIconListView;


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

    [mCharCounter   release];
    [mOriginalImage release];
    [mResizedImage  release];
    [mImageRep      release];
    [mIconListView  release];
    
    [mBodyView      release];
    [mTagView       release];
    [mIconImageView release];

    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    NSString *sModel;

    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChangeNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];

    [mBodyTextView setText:@""];
    [mBodyTextView setReturnKeyType:UIReturnKeyNext];
//    [mTagTextView  setPlaceholder:NSLocalizedString(@"Enter tags (separated by space)", @"")];
    [mTagTextView setReturnKeyType:UIReturnKeyDone];
//    [mTagTextView setClearsOnBeginEditing:NO];

    mCharCounter = [[MECharCounter alloc] initWithParentView:[self view]];

    sModel = [[UIDevice currentDevice] model];
    if (![sModel isEqualToString:@"iPhone"])
    {
        [mTakePictureButton setEnabled:NO];
    }

    MEUser *sUser = [MEUser userWithUserID:[[MEClientStore currentClient] userID]];
    mSelectedIconIndex = [[sUser defaultPostIcon] iconIndex];

    [self updateSelectedIcon];

    [mIconSelectButton     setBorderColor:[UIColor colorWithWhite:0.6 alpha:1.0]];
    [mRotateLeftButton     setEnabled:NO];
    [mRotateRightButton    setEnabled:NO];
    [mResizeButton         setEnabled:NO];
    [mImageResolutionLabel setText:@""];
    [mImageSizeLabel       setText:@""];

    [mIconListView setDelegate:self];
    
    mSelectedTabIndex = 0;
    [self arrangeSubviews];
    
    [mBodyTextView becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)aFromInterfaceOrientation
{
    [self arrangeSubviews];
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
    [self arrangeSubviews];
}


- (IBAction)tagTabButtonTapped:(id)aSender
{
    [mTagTextView becomeFirstResponder];
    mSelectedTabIndex = 1;
    [self arrangeSubviews];
}


- (IBAction)iconImageTabButtontapped:(id)aSender
{
    mSelectedTabIndex = 2;
    [self arrangeSubviews];
}


#pragma mark -


- (IBAction)iconSelectButtonTapped:(id)aSender
{
    UIWindow *sWindow = [[UIApplication sharedApplication] keyWindow];
    [sWindow addSubview:mIconListView];
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
#pragma mark Notifications


- (void)textFieldTextDidChangeNotification:(NSNotification *)aNotification
{
    [mCharCounter update];
}


#pragma mark -
#pragma mark TextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)aTextView;
{
    if (aTextView == mBodyTextView)
    {
        [mCharCounter setTextOwner:mBodyTextView];
        [mCharCounter setLimitCount:kMEPostBodyMaxLen];
        BEGIN_ANIMATION_OFF();
        [mCharCounter setFrame:CGRectMake(200, 192, 0, 0)];
        END_ANIMATION_OFF();
        [mCharCounter setHidden:NO];
        [mCharCounter update];
    }
}


- (void)textViewDidEndEditing:(UITextView *)aTextView
{
    if (aTextView == mBodyTextView)
    {
        [mCharCounter setHidden:YES];
    }
}


- (void)textViewDidChange:(UITextView *)aTextView
{
    if (aTextView == mBodyTextView)
    {
        BEGIN_ANIMATION_OFF();
        [mCharCounter update];
        END_ANIMATION_OFF();
    }

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
            [mTagTextView becomeFirstResponder];
        }
        else
        {
            [mTagTextView resignFirstResponder];
        }
    }
    else if (aTextView == mBodyTextView)
    {
        NSString *sBody    = [mBodyTextView text];
        NSString *sNewText = [sBody stringByReplacingCharactersInRange:aRange withString:aText];
        if ([sNewText length] > [mCharCounter limitCount])
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
#pragma mark UITextField Delegate


- (void)textFieldDidBeginEditing:(UITextField *)aTextField
{
    [mCharCounter setLimitCount:kMEPostTagMaxLen];
    BEGIN_ANIMATION_OFF();
    [mCharCounter setFrame:CGRectMake(200, 165, 0, 0)];
    [mCharCounter setHidden:NO];
    [mCharCounter setTextOwner:aTextField];
    [mCharCounter update];
    END_ANIMATION_OFF();
}


- (BOOL)textField:(UITextField *)aTextField shouldChangeCharactersInRange:(NSRange)aRange replacementString:(NSString *)aString
{
    NSString *sText = [aTextField text];
    sText = [sText stringByReplacingCharactersInRange:aRange withString:aString];

    if ([sText length] > [mCharCounter limitCount])
    {
        return NO;
    }

    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [mTagTextView resignFirstResponder];

    return NO;
}


- (void)textFieldDidEndEditing:(UITextField *)aTextField
{
    [mCharCounter setHidden:YES];
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


#pragma mark -
#pragma mark UIActionSheet Delegate


- (void)iconListView:(MEIconListView *)aView iconDidSelect:(NSInteger)aIndex
{
    mSelectedIconIndex = aIndex;
    [self updateSelectedIcon];
}


@end
