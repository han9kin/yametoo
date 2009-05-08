/*
 *  MEUserInfoViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEUserInfoViewController.h"
#import "MEUser.h"


@implementation MEUserInfoViewController


#pragma mark -
#pragma mark properties


@synthesize user = mUser;


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [mPhoneTextLabel     setText:NSLocalizedString(@"phone :", nil)];
    [mEmailTextLabel     setText:NSLocalizedString(@"e-mail :", nil)];
    [mMessengerTextLabel setText:NSLocalizedString(@"messenger :", nil)];
    [mHomepageTextLabel  setText:NSLocalizedString(@"homepage :", nil)];
    
    [mPhoneContLabel     setText:[mUser phoneNumber]];
    [mEmailContLabel     setText:[mUser email]];
    [mMessengerContLabel setText:[mUser messenger]];
    [mHomepageContLabel  setText:[mUser homepageURLString]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [mPhoneTextLabel     release];
    [mEmailTextLabel     release];
    [mMessengerTextLabel release];
    [mHomepageTextLabel  release];
    [mPhoneContLabel     release];
    [mEmailContLabel     release];
    [mMessengerContLabel release];
    [mHomepageContLabel  release];

    [mUser release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Actions


- (IBAction)closeButtonTapped:(id)aSender
{
    [[self view] removeFromSuperview];
    [self autorelease];
}


@end
