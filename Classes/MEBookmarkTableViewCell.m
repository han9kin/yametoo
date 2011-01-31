/*
 *  MEBookmarkTableViewCell.m
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 17.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "MEBookmarkTableViewCell.h"
#import "MEBookmark.h"


@implementation MEBookmarkTableViewCell


+ (MEBookmarkTableViewCell *)cellForTableView:(UITableView *)aTableView
{
    MEBookmarkTableViewCell *sCell = (MEBookmarkTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"Bookmark"];

    if (!sCell)
    {
        sCell = [[[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Bookmark"] autorelease];

        [[sCell textLabel] setFont:[UIFont systemFontOfSize:17.0]];
    }

    return sCell;
}

- (void)dealloc
{
    [mBookmark removeObserver:self forKeyPath:@"title"];
    [mBookmark release];
    [super dealloc];
}


- (void)setBookmark:(MEBookmark *)aBookmark
{
    [mBookmark removeObserver:self forKeyPath:@"title"];
    [mBookmark release];

    [[self textLabel] setText:[aBookmark title]];

    mBookmark = [aBookmark retain];
    [mBookmark addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}


#pragma mark NSKeyValueObserving


- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary *)aChange context:(void *)aContext
{
    [[self textLabel] setText:[aObject title]];
}


@end
