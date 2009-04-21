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


+ (UITableViewCell *)tableViewCellForLoginUser;
{
    UITableViewCell *sResult;
    UIImageView     *sFaceImageView;
    UILabel         *sUserIDLabel;
    
    sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kTablePostCellIdentifier] autorelease];
//    [[sResult contentView] setBackgroundColor:[UIColor lightGrayColor]];
    
    sFaceImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)] autorelease];
    [sFaceImageView setTag:kLoginUserCellFaceImageViewTag];
//    [sFaceImageView setBackgroundColor:[UIColor redColor]];
    
    sUserIDLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 20, 180, 30)] autorelease];
    [sUserIDLabel setTag:kLoginUserCellUserIDLabelTag];
    [sUserIDLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
//    [sUserIDLabel setBackgroundColor:[UIColor lightGrayColor]];

    [[sResult contentView] addSubview:sFaceImageView];
    [[sResult contentView] addSubview:sUserIDLabel];
    
    return sResult;
}


+ (UITableViewCell *)tableViewCellForPost
{
    UITableViewCell *sResult;
    UILabel         *sBodyLabel;
    
    sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kTablePostCellIdentifier] autorelease];
    
    sBodyLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    [sBodyLabel setTag:kPostCellBodyLabelTag];
    [sBodyLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [sBodyLabel setNumberOfLines:1000];
    [sBodyLabel setFont:[METableViewCellFactory fontForTableCellForPostBody]];
//    [sBodyLabel setBackgroundColor:[UIColor lightGrayColor]];

    [[sResult contentView] addSubview:sBodyLabel];
    
    return sResult;
}


+ (UIFont *)fontForTableCellForPostBody
{
    return [UIFont systemFontOfSize:14];
}


@end
