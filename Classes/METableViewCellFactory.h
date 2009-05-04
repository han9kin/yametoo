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

#define kPostCellIconImageViewTag       100
#define kPostCellBodyViewTag            200
#define kPostCellFaceImageViewTag       300
#define kPostCellAuthorNameLabelTag     400

#define kCommentCellBodyLabelTag        100
#define kCommentCellFaceImageViewTag    200
#define kCommentCellFrameViewTag        300


#define kPostCellBodyPadding            10


#define kTableLoginUserCellIdentifier   @"TableLoginUserCell"
#define kTableAddNewUserCellIdentifier  @"TableAddNewUserCell"

#define kTablePostCellIdentifier        @"TablePostCell"
#define kTableCommentCellIdentifier     @"TableCommentCell"


@interface METableViewCellFactory : NSObject
{

}

+ (UITableViewCell *)defaultCellForTableView:(UITableView *)aTableView;

+ (UITableViewCell *)loginUserCellForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)addNewUserCellForTableView:(UITableView *)aTableView;

+ (UITableViewCell *)postCellForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)postCellWithAuthorForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)commentCellForTableView:(UITableView *)aTableView;

@end
