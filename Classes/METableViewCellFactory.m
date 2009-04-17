/*
 *  METableViewCellFactory.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "METableViewCellFactory.h"
#import "ObjCUtil.h"


@implementation METableViewCellFactory


SYNTHESIZE_SINGLETON_CLASS(METableViewCellFactory, sharedFactory);


- (id)init
{
    self = [super init];
    if (self)
    {
    
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark - Class Methods


+ (UITableViewCell *)tableViewCellForPost
{
    UITableViewCell *sResult;
    
    NSLog(@"tableViewCellForPost");
    
    sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kTablePostCellIdentifier] autorelease];
    return sResult;
}


@end
