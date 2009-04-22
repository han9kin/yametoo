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
#import "MEImageView.h"


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
    MEImageView     *sImageView;
    UIView          *sFrameView;
    UILabel         *sBodyLabel;
    UILabel         *sTagsLabel;
    UILabel         *sTimeLabel;
    
    sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kTablePostCellIdentifier] autorelease];

    sFrameView = [[[UIImageView alloc] initWithFrame:CGRectMake(7, 9, 46, 46)] autorelease];
    [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
    
    sImageView = [[[MEImageView alloc] initWithFrame:CGRectMake(8, 10, 44, 44)] autorelease];
    [sImageView setTag:kPostCellImageViewTag];
    
    sBodyLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    [sBodyLabel setTag:kPostCellBodyLabelTag];
    [sBodyLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [sBodyLabel setNumberOfLines:1000];
    [sBodyLabel setFont:[METableViewCellFactory fontForTableCellForPostBody]];
    [sBodyLabel setTextColor:[UIColor darkGrayColor]];
//    [sBodyLabel setBackgroundColor:[UIColor lightGrayColor]];
    
    sTagsLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    [sTagsLabel setTag:kPostCellTagsLabelTag];
    [sTagsLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [sTagsLabel setNumberOfLines:1000];
    [sTagsLabel setFont:[METableViewCellFactory fontForTableCellForPostTag]];
    [sTagsLabel setTextColor:[UIColor grayColor]];
//    [sTagsLabel setBackgroundColor:[UIColor lightGrayColor]];    

    sTimeLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    [sTimeLabel setTag:kPostCellTimeLabelTag];
    [sTimeLabel setFont:[METableViewCellFactory fontForTableCellForPostTag]];
    [sTimeLabel setTextColor:[UIColor grayColor]];
//    [sTimeLabel setBackgroundColor:[UIColor lightGrayColor]];    
    
    [[sResult contentView] addSubview:sBodyLabel];
    [[sResult contentView] addSubview:sTagsLabel];
    [[sResult contentView] addSubview:sTimeLabel];
    [[sResult contentView] addSubview:sFrameView];
    [[sResult contentView] addSubview:sImageView];
    
    return sResult;
}


+ (UIFont *)fontForTableCellForPostBody
{
    return [UIFont systemFontOfSize:14];
}


+ (UIFont *)fontForTableCellForPostTag
{
    return [UIFont systemFontOfSize:10];
}


@end
