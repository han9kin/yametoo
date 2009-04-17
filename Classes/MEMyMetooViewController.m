/*
 *  MEMymetooViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 16.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEMyMetooViewController.h"
#import "METableViewCellFactory.h"
#import "MEReaderHeadView.h"


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
    
    MEReaderHeadView *sReaderHeadView = [MEReaderHeadView readerHeadView];
    [mReaderView setTableHeaderView:sReaderHeadView];
    [mReaderView setDelaysContentTouches:NO];
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
#pragma mark TableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 3;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    NSString *sResult = nil;
    
    if (aSection == 0)
    {
        sResult = @"오늘";
    }
    else if (aSection == 1)
    {
        sResult = @"어제";
    }
    else if (aSection == 2)
    {
        sResult = @"그저께";
    }
    
    return sResult;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    NSInteger sResult;
    
    if (aSection == 0)
    {
        sResult = 5;
    }
    else if (aSection == 1)
    {
        sResult = 3;
    }
    else if (aSection == 2)
    {
        sResult = 10;
    }
    
    return sResult;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sResult = nil;
    
    sResult = [aTableView dequeueReusableCellWithIdentifier:kTablePostCellIdentifier];
    if (!sResult)
    {
        sResult = [METableViewCellFactory tableViewCellForPost];
    }
    
    return sResult;
}


#pragma mark -
#pragma mark TableView Delegate


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    CGFloat sResult = 0;
    
    sResult = 90;
    return sResult;
}


@end
