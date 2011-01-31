/*
 *  METableViewCellFactory.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@class MEClient;
@class MEUser;

@interface METableViewCellFactory : NSObject
{

}

+ (UITableViewCell *)defaultCellForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)detailCellForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)textFieldCellForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)switchCellForTableView:(UITableView *)aTableView target:(id)aTarget action:(SEL)aAction;
+ (UITableViewCell *)buttonCellForTableView:(UITableView *)aTableView;

+ (UITableViewCell *)userCellForTableView:(UITableView *)aTableView;
+ (UITableViewCell *)clientCellForTableView:(UITableView *)aTableView;

@end


@interface UITableViewCell (ContentAccessing)

- (void)setDisabled:(BOOL)aDisabled;

- (void)setTitleText:(NSString *)aText;

- (UITextField *)textField;
- (UISwitch *)switch;

- (void)setUser:(MEUser *)aUser;
- (void)setUserID:(NSString *)aUserID;
- (void)setClient:(MEClient *)aClient;

@end
