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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChangeNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    [mBodyTextView setText:@""];
    [mBodyTextView setReturnKeyType:UIReturnKeyNext];
    [mTagTextField setPlaceholder:@"태그를 쓰세요 (공백으로 구분)"];
    [mTagTextField setReturnKeyType:UIReturnKeyDone];
    [mTagTextField setClearsOnBeginEditing:NO];

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
