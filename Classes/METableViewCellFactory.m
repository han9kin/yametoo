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


+ (UITableViewCell *)loginUserCellForTableView:(UITableView *)aTableView;
{
    UITableViewCell *sResult;
    UIImageView     *sFaceImageView;
    UIView          *sFrameView;
    UILabel         *sUserIDLabel;
    
    sResult = [aTableView dequeueReusableCellWithIdentifier:kTableLoginUserCellIdentifier];
    if (!sResult)
    {
        sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kTablePostCellIdentifier] autorelease];

        sFrameView = [[[UIImageView alloc] initWithFrame:CGRectMake(29, 9, 52, 52)] autorelease];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        [sFrameView setTag:kLoginUserCellFrameViewTag];
        
        sFaceImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 50, 50)] autorelease];
        [sFaceImageView setTag:kLoginUserCellFaceImageViewTag];
        
        sUserIDLabel = [[[UILabel alloc] initWithFrame:CGRectMake(90, 20, 180, 30)] autorelease];
        [sUserIDLabel setTag:kLoginUserCellUserIDLabelTag];
        [sUserIDLabel setFont:[UIFont boldSystemFontOfSize:17.0]];

        [[sResult contentView] addSubview:sFrameView];    
        [[sResult contentView] addSubview:sFaceImageView];
        [[sResult contentView] addSubview:sUserIDLabel];

//    [[sResult contentView] setBackgroundColor:[UIColor lightGrayColor]];
//    [sFaceImageView setBackgroundColor:[UIColor redColor]];
//    [sUserIDLabel setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    return sResult;
}


+ (UITableViewCell *)addNewUserCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sResult;

    sResult = [aTableView dequeueReusableCellWithIdentifier:kTableAddNewUserCellIdentifier];
    if (!sResult)
    {
        sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kTableAddNewUserCellIdentifier] autorelease];
    }
    
    return sResult;
}


+ (UITableViewCell *)postCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sResult;
    MEImageView     *sImageView;
    UIView          *sFrameView;
    UILabel         *sBodyLabel;
    UILabel         *sTagsLabel;
    UILabel         *sTimeLabel;
    UILabel         *sReplyLabel;
    
    sResult = [aTableView dequeueReusableCellWithIdentifier:kTablePostCellIdentifier];
     if (!sResult)
     {
        sResult = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kTablePostCellIdentifier] autorelease];

        sFrameView = [[[UIImageView alloc] initWithFrame:CGRectMake(7, 9, 46, 46)] autorelease];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        
        sImageView = [[[MEImageView alloc] initWithFrame:CGRectMake(8, 10, 44, 44)] autorelease];
        [sImageView setTag:kPostCellImageViewTag];
        
        sBodyLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        [sBodyLabel setTag:kPostCellBodyLabelTag];
        [sBodyLabel setLineBreakMode:UILineBreakModeCharacterWrap];
        [sBodyLabel setNumberOfLines:1000];
        [sBodyLabel setFont:[METableViewCellFactory fontForPostBody]];
        [sBodyLabel setTextColor:[UIColor darkGrayColor]];
        
        sTagsLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        [sTagsLabel setTag:kPostCellTagsLabelTag];
        [sTagsLabel setLineBreakMode:UILineBreakModeCharacterWrap];
        [sTagsLabel setNumberOfLines:1000];
        [sTagsLabel setFont:[METableViewCellFactory fontForPostTag]];
        [sTagsLabel setTextColor:[UIColor grayColor]];

        sTimeLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        [sTimeLabel setTag:kPostCellTimeLabelTag];
        [sTimeLabel setFont:[METableViewCellFactory fontForPostTag]];
        [sTimeLabel setTextColor:[UIColor grayColor]];

        sReplyLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        [sReplyLabel setTag:kPostCellReplyLabelTag];
        [sReplyLabel setFont:[METableViewCellFactory fontForPostTag]];
        [sReplyLabel setTextColor:[UIColor grayColor]];
        [sReplyLabel setTextAlignment:UITextAlignmentRight];
        
    //    [sBodyLabel  setBackgroundColor:[UIColor lightGrayColor]];    
    //    [sTagsLabel  setBackgroundColor:[UIColor lightGrayColor]];        
    //   [sTimeLabel  setBackgroundColor:[UIColor lightGrayColor]];
    //    [sReplyLabel setBackgroundColor:[UIColor lightGrayColor]];

        [[sResult contentView] addSubview:sBodyLabel];
        [[sResult contentView] addSubview:sTagsLabel];
        [[sResult contentView] addSubview:sTimeLabel];
        [[sResult contentView] addSubview:sReplyLabel];
        [[sResult contentView] addSubview:sFrameView];
        [[sResult contentView] addSubview:sImageView];
     }
    
    return sResult;
}


+ (UIFont *)fontForPostBody
{
    return [UIFont systemFontOfSize:14];
}


+ (UIFont *)fontForPostTag
{
    return [UIFont systemFontOfSize:10];
}


@end
