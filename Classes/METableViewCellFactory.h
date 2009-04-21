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
#define kLoginUserCellUserIDLabelTag    200
#define kPostCellBodyLabelTag           100
#define kPostCellTagsLabelTag           200
#define kPostCellImageViewTag           300


#define kTableLoginUserCellIdentifier   @"TableLoginUserCell"
#define kTablePostCellIdentifier        @"TablePostCell"


@interface METableViewCellFactory : NSObject
{

}

+ (UITableViewCell *)tableViewCellForLoginUser;
+ (UITableViewCell *)tableViewCellForPost;
+ (UIFont *)fontForTableCellForPostBody;
+ (UIFont *)fontForTableCellForPostTag;

@end
