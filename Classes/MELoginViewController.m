/*
 *  MELoginViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 20.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MELoginViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "METableViewCellFactory.h"


@implementation MELoginViewController

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
    
    NSLog(@"MELoginViewController viewDidLoad = %d", [self retainCount]);

/*    MEClient *sClient;
    NSArray  *sClients = [MEClientStore clients];
    for (sClient in sClients)
    {
        NSLog(@"%@", [sClient userID]);
    }*/
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
    NSLog(@"NMLoginViewController dealloc");
    [super dealloc];
}


#pragma mark -
#pragma mark TableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    NSString *sResult = nil;
    
    if (aSection == 0)
    {
        sResult = @"등록된 유저";
    }
    else if (aSection == 1)
    {
        sResult = @"유저 등록";
    }
    
    return sResult;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    NSInteger sResult;
    
    if (aSection == 0)
    {
        sResult = [[MEClientStore clients] count];
    }
    else
    {
        sResult = 1;
    }
    
    return sResult;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sResult = nil;
    
    if ([aIndexPath section] == 0)
    {
        UIImageView     *sFaceImageView;
        UILabel         *sUserIDLabel;
        NSArray         *sClients = [MEClientStore clients];
        MEClient        *sClient  = [sClients objectAtIndex:[aIndexPath row]];
        
        sResult = [aTableView dequeueReusableCellWithIdentifier:kTableLoginUserCellIdentifier];
        if (!sResult)
        {
            sResult = [METableViewCellFactory tableViewCellForLoginUser];
        }
        
        sFaceImageView = (UIImageView *)[[sResult contentView] viewWithTag:kLoginUserCellFaceImageViewTag];
        sUserIDLabel   = (UILabel *)    [[sResult contentView] viewWithTag:kLoginUserCellUserIDLabelTag];
        
        [sUserIDLabel setText:[sClient userID]];
    }
    else
    {
        sResult = [aTableView dequeueReusableCellWithIdentifier:@"add new user"];
        if (!sResult)
        {
            sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"add new user"] autorelease];
        }
        
        [sResult setText:@"Add new user..."];
    }
    
    return sResult;
}


#pragma mark -
#pragma mark TableView Delegate


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    CGFloat sResult = 0;
    
    if ([aIndexPath section] == 0)
    {
        sResult = 70;
    }
    else
    {
        sResult = 44;
    }
    
    return sResult;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    MEClient *sClient;    
    NSArray *sClients = [MEClientStore clients];
    
    if ([aIndexPath row] < [sClients count])
    {
        sClient = [sClients objectAtIndex:[aIndexPath row]];
        [MEClientStore setCurrentUserID:[sClient userID]];
    }
    
    [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];
}


@end
