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


@implementation MEPostViewController


- (void)dealloc
{
    [mCancelButton           release];
    [mPostButton             release];
    [mTakePictureButton      release];
    [mFromPhotoLibraryButton release];
    [mBodyTextView           release];
    [mTagTextField           release];
    [mAttachedImageView      release];
    
    [mCharCounter    release];
    [mAttachedImage  release];

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

    [mBodyTextView setText:@""];
    [mBodyTextView setReturnKeyType:UIReturnKeyNext];
    [mTagTextField setPlaceholder:@"태그를 쓰세요 (공백으로 구분)"];
    [mTagTextField setReturnKeyType:UIReturnKeyDone];

    mCharCounter = [[MECharCounter alloc] initWithParentView:[self view]];

    sModel = [[UIDevice currentDevice] model];
    if (![sModel isEqualToString:@"iPhone"])
    {
        [mTakePictureButton setEnabled:NO];
    }
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


- (IBAction)postButtonTapped:(id)aSender
{
    NSString *sBody = [mBodyTextView text];
    NSString *sTags = [mTagTextField text];
    
    if ([sBody length] > 0)
    {
        [self setInterfaceEnabled:NO];
        [mBodyTextView resignFirstResponder];
        [mTagTextField resignFirstResponder];

        [[MEClientStore currentClient] createPostWithBody:sBody tags:sTags icon:0 attachedImage:mAttachedImage delegate:self];
    }
    else
    {

    }
}


- (IBAction)cancelButtonTapped:(id)aSender
{
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark TextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)aTextView;
{
    if (aTextView == mBodyTextView)
    {
        [mCharCounter setTextOwner:mBodyTextView];
        [mCharCounter setLimitCount:150];
        [mCharCounter setFrame:CGRectMake(200, 195, 0, 0)];        
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
        if ([sBody length] >= 150)
        {
            return NO;
        }
    }

    return YES;
}


#pragma mark -
#pragma mark UITextField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [mTagTextField resignFirstResponder];
    return NO;
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

    [mAttachedImage autorelease];
    mAttachedImage = [aImage retain];

    [mAttachedImageView setImage:mAttachedImage];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker
{
    [aPicker dismissModalViewControllerAnimated:YES];
    [[aPicker view] setHidden:YES];
    [[aPicker view] removeFromSuperview];
    [aPicker autorelease];
}


@end
