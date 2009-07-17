/*
 *  MEIconListView.m
 *  yametoo
 *
 *  Created by cgkim on 09. 06. 11.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEIconListView.h"
#import "MEImageButton.h"
#import "MEUser.h"
#import "MEClientStore.h"
#import "MEPostIcon.h"


@implementation MEIconListView


@synthesize delegate   = mDelegate;


#pragma mark -


- (void)initVars
{
    NSInteger      sIndex;
    MEImageButton *sButton = nil;
    
    for (sIndex = 200; sIndex < 212; sIndex++)
    {
        sButton = (MEImageButton *)[self viewWithTag:sIndex];
        [sButton setBorderColor:[UIColor colorWithWhite:0.6 alpha:1.0]];
    }

    MEUser     *sUser      = [MEUser userWithUserID:[[MEClientStore currentClient] userID]];
    NSArray    *sPostIcons = [sUser postIcons];
    MEPostIcon *sPostIcon  = nil;
    NSInteger   sIconIndex;
    for (sPostIcon in sPostIcons)
    {
        sIconIndex = 200 + [sPostIcon iconIndex] - 1;
        sButton = (MEImageButton *)[self viewWithTag:sIconIndex];
        [sButton setImageWithURL:[sPostIcon iconURL]];
    }
}


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self)
    {
        [self initVars];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {

    }

    return self;
}


- (void)drawRect:(CGRect)aRect
{

}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (IBAction)buttonTapped:(id)aSender
{
    NSInteger sTag = [aSender tag];
    
    [mDelegate iconListView:self iconDidSelect:(sTag - 200) + 1];
    
    [self removeFromSuperview];
}


@end
