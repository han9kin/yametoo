/*
 *  MEPostIcon.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 27.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface MEPostIcon : NSObject
{
    NSInteger  mIconIndex;
    NSString  *mIconDescription;
    NSURL     *mIconURL;
}

@property(nonatomic, readonly) NSInteger  iconIndex;
@property(nonatomic, readonly) NSString  *iconDescription;
@property(nonatomic, readonly) NSURL     *iconURL;


- (id)initWithDictionary:(NSDictionary *)aDict;

@end
