/*
 *  METableViewCellFactory.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


#define kIconImageSize       44
#define kPostCellBodyPadding 10
#define kCommentBodyWidth    240


@class MEClient;
@class MEUser;
@class MEPost;
@class MEComment;

@interface METableViewCellFactory : NSObject
{

}

+ (UITableViewCell *)defaultCellForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)detailCellForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)textFieldCellForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)switchCellForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)buttonCellForTableView:(UITableView *)aTableView;

+ (UITableViewCell *)userCellForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)clientCellForTableView:(UITableView *)aTableView;

+ (UITableViewCell *)postCellForTableView:(UITableView *)aTableView withTarget:(id)aTarget;
+ (UITableViewCell *)postCellWithAuthorForTableView:(UITableView *)aTableView withTarget:(id)aTarget;
+ (UITableViewCell *)commentCellForTableView:(UITableView *)aTableView withTarget:(id)aTarget;

@end


@interface UITableViewCell (ContentAccessing)

- (void)setDisabled:(BOOL)aDisabled;

- (void)setTitleText:(NSString *)aText;
- (void)setDetailText:(NSString *)aText;

- (UITextField *)textField;
- (UISwitch *)switch;

- (void)setUser:(MEUser *)aUser;
- (void)setUserID:(NSString *)aUserID;
- (void)setClient:(MEClient *)aClient;
- (void)setPost:(MEPost *)aPost;
- (void)setComment:(MEComment *)aComment isOwners:(BOOL)aOwners;
- (void)setCommentBackgroundColor:(UIColor *)aColor;

@end
