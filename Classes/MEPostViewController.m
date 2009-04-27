/*
 *  MainViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEPostViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"


@implementation MEPostViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [mBodyTextView setText:@""];
    [mBodyTextView setReturnKeyType:UIReturnKeyNext];
    [mTagTextView  setText:@""];
    [mTagTextView  setReturnKeyType:UIReturnKeyDone];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    // Return YES for supported orientations
    return (aInterfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc
{
    NSLog(@"postViewController dealloc");
    [mAttachedImage release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Private


- (void)beginEditModeAnimation
{
}


- (void)beginNormalModeAnimation
{
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
    NSString *sTags = [mTagTextView  text];

    [[MEClientStore currentClient] createPostWithBody:sBody tags:sTags icon:0 attachedImage:mAttachedImage delegate:self];
}


- (IBAction)cancelButtonTapped:(id)aSender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)keyboardToolbarDoneButtonTapped:(id)aSender
{
    [mBodyTextView resignFirstResponder];
    [mTagTextView resignFirstResponder];

    [self beginNormalModeAnimation];
}


#pragma mark -
#pragma mark TextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)aTextView;
{
    [self beginEditModeAnimation];
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
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)aTextView
{
    NSRange sRange = [aTextView selectedRange];
    [aTextView scrollRangeToVisible:sRange];
}


#pragma mark -
#pragma mark MEClientDelegate


/*- (void)client:(MEClient *)aClient didLoginWithError:(NSError *)aError
{
    NSLog(@"%@", aError);
}*/


- (void)client:(MEClient *)aClient didCreatePostWithError:(NSError *)aError
{
    if (!aError)
    {
        [mAttachedImage release];
        mAttachedImage = nil;

        [mBodyTextView      setText:@""];
        [mTagTextView       setText:@""];
        [mAttachedImageView setImage:nil];
        
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"error handling");
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
    
/*    sSize = [aImage size];
    sSize.width  /= 2;
    sSize.height /= 2;
    
    UIGraphicsBeginImageContext(sSize);
    [aImage drawInRect:CGRectMake(0, 0, sSize.width, sSize.height)];
    mAttachedImage = UIGraphicsGetImageFromCurrentImageContext();
    [mAttachedImage retain];
    UIGraphicsEndImageContext();*/
    
    mAttachedImage = [aImage retain];

    [mAttachedImageView setImage:mAttachedImage];
}


@end
