/*
 *  METableViewCellFactory.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


#define kLoginUserCellFaceImageViewTag  100
#define kLoginUserCellFrameViewTag      200
#define kLoginUserCellUserIDLabelTag    300

#define kPostCellBodyLabelTag           100
#define kPostCellTagsLabelTag           200
#define kPostCellTimeLabelTag           300
#define kPostCellReplyLabelTag          400
#define kPostCellImageViewTag           500


#define kTableLoginUserCellIdentifier   @"TableLoginUserCell"
#define kTableAddNewUserCellIdentifier  @"TableAddNewUserCell"

#define kTablePostCellIdentifier        @"TablePostCell"


@interface METableViewCellFactory : NSObject
{

}

+ (UITableViewCell *)loginUserCellForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)addNewUserCellForTableView:(UITableView *)aTableView;

+ (UITableViewCell *)postCellForTableView:(UITableView *)aTableView;

+ (UIFont *)fontForPostBody;
+ (UIFont *)fontForPostTag;

@end
