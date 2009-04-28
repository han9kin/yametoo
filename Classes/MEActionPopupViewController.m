/*
 *  MEActionPopupViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEActionPopupViewController.h"


@implementation MEActionPopupViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
#pragma mark Actions


- (IBAction)showRepliesButtonTapped:(id)aSender
{
    NSLog(@"showRepliesButtonTapped");
}


- (IBAction)postReplyButtonTapped:(id)aSender
{
    NSLog(@"postReplyButtonTapped");
}


- (IBAction)showPhotoButtonTapped:(id)aSender
{
    NSLog(@"showPhotoButtonTapped");
}


- (IBAction)cancelButtonTapped:(id)aSender
{
    NSLog(@"cencelButton");
}


@end
