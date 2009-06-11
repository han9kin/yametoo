/*
 *  MEVisitsViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 09.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "ObjCUtil.h"
#import "UIViewController+MEAdditions.h"
#import "MEReaderView.h"
#import "MEVisitsViewController.h"
#import "MEOtherMetooViewController.h"
#import "MEReplyViewController.h"
#import "MEWebViewController.h"
#import "METableViewCellFactory.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"
#import "MELink.h"


@interface MEVisitsViewController (Private)
@end

@implementation MEVisitsViewController (Private)

- (UIViewController *)viewControllerForLink:(MELink *)aLink
{
    UIViewController *sViewController;

    switch ([aLink type])
    {
        case kMELinkTypeMe2DAY:
            sViewController = [[MEOtherMetooViewController alloc] initWithUserID:[aLink url]];
            break;

        case kMELinkTypePost:
            sViewController = [[MEReplyViewController alloc] initWithPostID:[aLink url]];
            break;

        case kMELinkTypeOther:
            sViewController = [[MEWebViewController alloc] initWithURL:[aLink url]];
            break;

        default:
            sViewController = nil;
            break;
    }

    return [sViewController autorelease];
}

@end


@implementation MEVisitsViewController

SYNTHESIZE_SINGLETON_CLASS(MEVisitsViewController, sharedController);


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        mLinks = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChange:) name:MEClientStoreCurrentUserDidChangeNotification object:nil];
    }

    return self;
}

- (id)initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBundle
{
    self = [super initWithNibName:aNibName bundle:aBundle];

    if (self)
    {
        mLinks = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChange:) name:MEClientStoreCurrentUserDidChangeNotification object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mLinks release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)loadView
{
    [super loadView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *sView;
    CGRect  sRect;

    sView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    [sView setBackgroundColor:[UIColor lightGrayColor]];
    [[self view] addSubview:sView];
    [sView release];

    mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 25)];
    [mTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mTitleLabel setTextColor:[UIColor blackColor]];
    [mTitleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [mTitleLabel setText:mTitle];
    [sView addSubview:mTitleLabel];
    [mTitleLabel release];

    sRect = [[self view] bounds];
    sRect.origin.y     = 25;
    sRect.size.height -= 25;

    mTableView = [[UITableView alloc] initWithFrame:sRect style:UITableViewStylePlain];
    [mTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [mTableView setDataSource:self];
    [mTableView setDelegate:self];
    [[self view] addSubview:mTableView];
    [mTableView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    mTitleLabel = nil;
    mTableView  = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [mTableView deselectRowAtIndexPath:[mTableView indexPathForSelectedRow] animated:YES];
}


- (void)visitLink:(MELink *)aLink
{
    if (aLink)
    {
        [mLinks removeObject:aLink];
        [mLinks insertObject:aLink atIndex:0];

        [mTableView reloadData];
        [mTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];

        [[self navigationController] popToRootViewControllerAnimated:NO];
        [[self navigationController] pushViewController:[self viewControllerForLink:aLink] animated:NO];

        [[self tabBarController] setSelectedViewController:[self navigationController]];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    return [mLinks count];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sCell = [METableViewCellFactory defaultCellForTableView:aTableView];
    MELink          *sLink = [mLinks objectAtIndex:[aIndexPath row]];

    [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [sCell setFont:[UIFont systemFontOfSize:15.0]];
    [sCell setText:[sLink urlDescription]];

    return sCell;
}


#pragma mark -
#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    [[self navigationController] pushViewController:[self viewControllerForLink:[mLinks objectAtIndex:[aIndexPath row]]] animated:YES];
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    NSString *sName;

    if (aUser)
    {
        sName = [aUser nickname];
    }
    else
    {
        sName = [[MEClientStore currentClient] userID];
    }

    [mTitle release];
    mTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@'s Visits", @""), sName];
    [mTitleLabel setText:mTitle];
}


#pragma mark -
#pragma mark MEClientStore Notifications


- (void)currentUserDidChange:(NSNotification *)aNotification
{
    MEClient *sClient = [MEClientStore currentClient];
    NSString *sUserID = [sClient userID];

    [mTitleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%@'s Visits", @""), sUserID]];
    [sClient getPersonWithUserID:sUserID delegate:self];

    [mLinks removeAllObjects];
    [mTableView reloadData];

    [[self navigationController] popToRootViewControllerAnimated:NO];
}


@end
