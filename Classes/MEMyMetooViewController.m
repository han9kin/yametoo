/*
 *  MEMymetooViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 16.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEMyMetooViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEPost.h"


@implementation MEMyMetooViewController


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


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)aAnimated
{

    [mTopBarLabel setText:[NSString stringWithFormat:@"%@'s me2day", [[MEClientStore currentClient] userID]]];
    [mReaderView removeAllPosts];
    
    MEClient *sClient = [MEClientStore currentClient];
    [sClient getPostsWithUserID:[sClient userID]
                         offset:0
                          count:30
                       delegate:self];
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
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [super dealloc];
}
    

#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPosts:(NSArray *)aPosts error:(NSError *)aError
{
    MEPost *sPost;
    
    for (sPost in aPosts)
    {
        [mReaderView addPost:sPost];
    }
}



@end
