/*
 *  MainViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEPostViewController.h"
#import "MEClient.h"


@implementation MEPostViewController


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    NSLog(@"initWithNibName");
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    if (self)
    {
        mClient = [[MEClient alloc] init];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aCoder
{
    NSLog(@"initWithCoder");
    self = [super initWithCoder:aCoder];
    if (self)
    {
        mClient = [[MEClient alloc] init];
    }

    return self;
}


- (void)loadView
{
    [super loadView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [mKeyboardToolbar setTintColor:[UIColor colorWithRed:0.565 green:0.596 blue:0.635 alpha:1.0]];
    [mBodyTextView setText:@""];
    [mTagTextView  setText:@""];

    [mClient loginWithUserID:@"han9kin" userKey:@"idontknow" delegate:self];
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
    [mClient release];
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
    NSLog(@"takePictureButtonTapped");
}


- (IBAction)postButtonTapped:(id)aSender
{
    NSString *sBody = [mBodyTextView text];
    NSString *sTags = [mTagTextView  text];

    [mClient postWithBody:sBody tags:sTags icon:0 attachedImage:nil delegate:self];
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

- (void)client:(MEClient *)aClient didPostWithError:(NSError *)aError
{
    NSLog(@"%@", aError);
}


@end