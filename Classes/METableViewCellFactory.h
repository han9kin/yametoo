/*
 *  METableViewCellFactory.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


#define kTablePostCellIdentifier    @"TablePostCell"


@interface METableViewCellFactory : NSObject
{

}

+ (UITableViewCell *)tableViewCellForPost;

@end
