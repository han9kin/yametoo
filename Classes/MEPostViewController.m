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

    [mKeyboardToolbar setTintColor:[UIColor colorWithRed:0.565 green:0.596 blue:0.635 alpha:1.0]];
    [mBodyTextView setText:@""];
    [mTagTextView  setText:@""];
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
    [super dealloc];
}


#pragma mark -
#pragma mark Private


- (void)beginEditModeAnimation
{
    CGRect sFrame;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];

    sFrame = [mKeyboardToolbar frame];
    sFrame.origin.y = 200;
    [mKeyboardToolbar setFrame:sFrame];

    [UIView commitAnimations];
}


- (void)beginNormalModeAnimation
{
    CGRect sFrame;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];

    sFrame = [mKeyboardToolbar frame];
    sFrame.origin.y = 416;
    [mKeyboardToolbar setFrame:sFrame];

    [UIView commitAnimations];
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


- (IBAction)postButtonTapped:(id)aSender
{
    NSString *sBody = [mBodyTextView text];
    NSString *sTags = [mTagTextView  text];

    [[MEClientStore currentClient] createPostWithBody:sBody tags:sTags icon:0 attachedImage:mAttachedImage delegate:self];
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


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didLoginWithError:(NSError *)aError
{
    NSLog(@"%@", aError);
}


- (void)client:(MEClient *)aClient didCreatePostWithError:(NSError *)aError
{
    NSLog(@"%@", aError);

    if (!aError)
    {
        [mAttachedImage release];
        mAttachedImage = nil;

        [mBodyTextView      setText:@""];
        [mTagTextView       setText:@""];
        [mAttachedImageView setImage:nil];
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


@end
