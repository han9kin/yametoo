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

+ (UITableViewCell *)tableViewCellForLoginUser;
+ (UITableViewCell *)tableViewCellForAddNewUser;

+ (UITableViewCell *)tableViewCellForPost;
+ (UIFont *)fontForTableCellForPostBody;
+ (UIFont *)fontForTableCellForPostTag;

@end
