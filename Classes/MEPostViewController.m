/*
 *  MainViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIAlertView+MEAdditions.h"
#import "MEPostViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEDrawingFunctions.h"
#import "MECharCounter.h"
#import <math.h>


static double radians(double degrees) {return degrees * M_PI/180;}


#define IMAGE_PORTRAIT_MODE     0
#define IMAGE_LANDSCAPE_MODE    1


#define BEGIN_ANIMATION_OFF()       [CATransaction begin]; \
                                    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
#define END_ANIMATION_OFF()         [CATransaction commit];


@implementation MEPostViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [mCancelButton           release];
    [mPostButton             release];
    [mTakePictureButton      release];
    [mFromPhotoLibraryButton release];
    [mBodyTextView           release];
    [mTagTextField           release];
    [mAttachedImageView      release];

    [mCharCounter    release];
    [mOriginalImage  release];
    [mResizedImage   release];
    [mImageRep       release];

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
    [mTagTextField setPlaceholder:NSLocalizedString(@"Enter tags (separated by space)", @"")];
    [mTagTextField setReturnKeyType:UIReturnKeyDone];
    [mTagTextField setClearsOnBeginEditing:NO];

    mCharCounter = [[MECharCounter alloc] initWithParentView:[self view]];

    sModel = [[UIDevice currentDevice] model];
    if (![sModel isEqualToString:@"iPhone"])
    {
        [mTakePictureButton setEnabled:NO];
    }
    
    [mRotateLeftButton     setEnabled:NO];
    [mRotateRightButton    setEnabled:NO];
    [mResizeButton         setEnabled:NO];
    [mImageResolutionLabel setText:@""];
    [mImageSizeLabel       setText:@""];
}


#pragma mark -
#pragma mark Private


- (void)setInterfaceEnabled:(BOOL)aFlag
{
    [mCancelButton           setEnabled:aFlag];
    [mPostButton             setEnabled:aFlag];
    [mTakePictureButton      setEnabled:aFlag];
    [mFromPhotoLibraryButton setEnabled:aFlag];
    [mBodyTextView           setEditable:aFlag];
    [mTagTextField           setEnabled:aFlag];
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


#pragma mark -
#pragma mark Actions


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
    NSLog(@"rotateLeftButtonTapped");
    mRotateAngle -= 90;
    [self resizeImage];
}


- (IBAction)rotateRightButtonTapped:(id)aSender
{
    NSLog(@"rotateRightButtonTapped");
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


- (IBAction)postButtonTapped:(id)aSender
{
    NSString *sBody = [mBodyTextView text];
    NSString *sTags = [mTagTextField text];

    if ([sBody length] > 0)
    {
        [self setInterfaceEnabled:NO];
        [mBodyTextView resignFirstResponder];
        [mTagTextField resignFirstResponder];

        [[MEClientStore currentClient] createPostWithBody:sBody tags:sTags icon:0 attachedImage:mResizedImage delegate:self];
    }
    else
    {
        [UIAlertView showAlert:NSLocalizedString(@"Please enter contents.", @"")];
    }
}


- (IBAction)cancelButtonTapped:(id)aSender
{
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
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
        [mCharCounter setLimitCount:150];
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
        [mCharCounter update];
    }

    NSRange sRange = [aTextView selectedRange];
    [aTextView scrollRangeToVisible:sRange];
}


- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)aRange replacementText:(NSString *)aText
{
    if ([aText length] == 1 && [aText characterAtIndex:0] == 10)
    {
        if (aTextView == mBodyTextView)
        {
            [mTagTextField becomeFirstResponder];
        }
        else
        {
            [mTagTextField resignFirstResponder];
        }
    }
    else if (aTextView == mBodyTextView)
    {
        NSString *sBody = [mBodyTextView text];
        if ([sBody length] >= [mCharCounter limitCount])
        {
            return NO;
        }
    }

    return YES;
}


#pragma mark -
#pragma mark UITextField Delegate


- (void)textFieldDidBeginEditing:(UITextField *)aTextField
{
    [mCharCounter setLimitCount:300];
    BEGIN_ANIMATION_OFF();
    [mCharCounter setFrame:CGRectMake(200, 165, 0, 0)];
    END_ANIMATION_OFF();
    [mCharCounter setHidden:NO];
    [mCharCounter setTextOwner:aTextField];
    [mCharCounter update];
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
    [mTagTextField resignFirstResponder];

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
        [mTagTextField resignFirstResponder];
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
    CGFloat sTargetSize = 0.0;
    
    if (mIsMiddleSizeEnabled && mIsLargeSizeEnabled)
    {
        if (aButtonIndex == 0)
        {
            sTargetSize = 500.0;
        }
        else if (aButtonIndex == 1)
        {
            sTargetSize = 1024.0;
        }
        else if (aButtonIndex == 2)
        {
            sTargetSize = -1.0;
        }
    }
    else if (mIsMiddleSizeEnabled && !mIsLargeSizeEnabled)
    {
        if (aButtonIndex == 0)
        {
            sTargetSize = 500.0;
        }
        else if (aButtonIndex == 1)
        {
            sTargetSize = -1.0;
        }
    }
    
    if (sTargetSize != -1.0)
    {
        mLongSideLength = sTargetSize;        
        [self resizeImage];
    }
    else
    {
        [mResizedImage release];
        mResizedImage = [mOriginalImage retain];
        [self updateImageInfo];
    }
}


@end
