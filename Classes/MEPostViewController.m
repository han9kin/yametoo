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
#import "MEDrawingFunctions.h"


@implementation MEPostViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [mBodyTextView setText:@""];
    [mBodyTextView setReturnKeyType:UIReturnKeyNext];
    [mTagTextView  setText:@""];
    [mTagTextView  setReturnKeyType:UIReturnKeyDone];
    
    mCharCountLayer = [[CALayer layer] retain];
    [mCharCountLayer setHidden:YES];
    [mCharCountLayer setFrame:CGRectMake(200, 195, 0, 0)];
    
    [[[self view] layer] addSublayer:mCharCountLayer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [mCharCountLayer release];
    [mAttachedImage  release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Private


- (void)updateCharCounter
{
    UIImage  *sImage = nil;
    NSString *sBody  = [mBodyTextView text];
    UIFont   *sFont  = [UIFont systemFontOfSize:17];
    NSString *sStr   = [NSString stringWithFormat:NSLocalizedString(@"%d character(s) remains", nil), (150 - [sBody length])];
    CGSize    sSize  = [sStr sizeWithFont:sFont];
    CGRect    sFrame;
    
    sSize.width  += 10;
    sSize.height += 6;

    UIGraphicsBeginImageContext(sSize);
    [[UIColor orangeColor] set];
    MERoundRectFill(CGRectMake(0, 0, sSize.width, sSize.height), 3);
    
    [[UIColor blackColor] set];
    [sStr drawAtPoint:CGPointMake(5, 5) withFont:sFont];
    
    sImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    sFrame = CGRectMake(320 - sSize.width - 20, 195, sSize.width, sSize.height);
    
    [mCharCountLayer setOpacity:0.8];
    [mCharCountLayer setContents:(id)[sImage CGImage]];
    [mCharCountLayer setFrame:sFrame];
}


- (void)setInterfaceEnabled:(BOOL)aFlag
{
    [mCancelButton           setEnabled:aFlag];
    [mPostButton             setEnabled:aFlag];
    [mTakePictureButton      setEnabled:aFlag];
    [mFromPhotoLibraryButton setEnabled:aFlag];
    [mBodyTextView           setEditable:aFlag];
    [mTagTextView            setEditable:aFlag];
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
    
    if ([sBody length] > 0)
    {
        [self setInterfaceEnabled:NO];
        [mBodyTextView resignFirstResponder];
        [mTagTextView  resignFirstResponder];
        
        [[MEClientStore currentClient] createPostWithBody:sBody tags:sTags icon:0 attachedImage:mAttachedImage delegate:self];
    }
    else
    {
    
    }
}


- (IBAction)cancelButtonTapped:(id)aSender
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark TextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)aTextView;
{
    if (aTextView == mBodyTextView)
    {
        [self updateCharCounter];
        [mCharCountLayer setHidden:NO];
    }
}


- (void)textViewDidEndEditing:(UITextView *)aTextView
{
    if (aTextView == mBodyTextView)
    {
        [mCharCountLayer setContents:nil];
        [mCharCountLayer setHidden:YES];
    }
}


- (void)textViewDidChange:(UITextView *)aTextView
{
    if (aTextView == mBodyTextView)
    {
        [self updateCharCounter];
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
            [mTagTextView becomeFirstResponder];
        }
        else
        {
            [mTagTextView resignFirstResponder];
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
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didCreatePostWithError:(NSError *)aError
{
    if (!aError)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"error handling");
        [self setInterfaceEnabled:YES];
        [mBodyTextView resignFirstResponder];
        [mTagTextView  resignFirstResponder];
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
