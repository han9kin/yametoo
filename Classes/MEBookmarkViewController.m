/*
 *  MEBookmarkViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 16.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MEBookmarkViewController.h"
#import "MEListViewController.h"
#import "METableViewCellFactory.h"
#import "MESettings.h"
#import "MEUser.h"
#import "MELink.h"


@interface MEBookmarkViewController (Private)
@end

@implementation MEBookmarkViewController (Private)

- (void)layoutViews
{
    CGRect  sRect;
    CGFloat sHeight;

    [mNavigationBar sizeToFit];

    sRect   = [[self view] bounds];
    sHeight = [mNavigationBar frame].size.height;

    sRect.origin.y    += sHeight;
    sRect.size.height -= sHeight;

    [mTableView setFrame:sRect];
}

@end


@implementation MEBookmarkViewController

@synthesize navigationBar = mNavigationBar;
@synthesize tableView     = mTableView;


- (id)init
{
    self = [super initWithNibName:@"BookmarkView" bundle:nil];

    if (self)
    {
    }

    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self layoutViews];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    [self layoutViews];
}


- (IBAction)close
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)edit
{
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    if (aSection)
    {
        return [[MESettings bookmarks] count];
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    static NSString *sDefaultTitle[] = {
        @"%@'s Friends",
    };

    UITableViewCell *sCell = [METableViewCellFactory defaultCellForTableView:mTableView];

    if ([aIndexPath section])
    {
        [[sCell textLabel] setFont:[UIFont systemFontOfSize:17.0]];
        [[sCell textLabel] setText:[[[MESettings bookmarks] objectAtIndex:[aIndexPath row]] urlDescription]];
    }
    else
    {
        [[sCell textLabel] setFont:[UIFont boldSystemFontOfSize:17.0]];
        [[sCell textLabel] setText:[NSString stringWithFormat:NSLocalizedString(sDefaultTitle[[aIndexPath row]], @""), [[MEUser currentUser] nickname]]];
    }

    return sCell;
}


#pragma mark -
#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    static MEClientGetPostsScope sScope[] = {
        kMEClientGetPostsScopeFriendAll,
    };

    UIViewController *sViewController;

    if ([aIndexPath section])
    {
    }
    else
    {
        sViewController = [[MEListViewController alloc] initWithUser:[MEUser currentUser] scope:sScope[[aIndexPath row]]];
    }

    [(UINavigationController *)[self parentViewController] pushViewController:sViewController animated:NO];
    [self dismissModalViewControllerAnimated:YES];

    [sViewController release];
}


@end
