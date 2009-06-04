/*
 *  MELink.h
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 04.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface MELink : NSObject
{
    NSString *mTitle;
    NSString *mURLString;
    NSString *mDescription;
}

@property(nonatomic, copy)     NSString *title;
@property(nonatomic, copy)     NSString *URLString;
@property(nonatomic, readonly) NSString *urlDescription;
@property(nonatomic, readonly) NSURL    *url;


- (void)appendTitle:(NSString *)aTitle;


@end
