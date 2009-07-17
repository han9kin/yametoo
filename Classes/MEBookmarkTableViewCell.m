/*
 *  MEBookmarkTableViewCell.m
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 17.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MEBookmarkTableViewCell.h"
#import "MEClient.h"
#import "MELink.h"


@implementation MEBookmarkTableViewCell


+ (MEBookmarkTableViewCell *)cellForTableView:(UITableView *)aTableView
{
    MEBookmarkTableViewCell *sCell = (MEBookmarkTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"Bookmark"];

    if (!sCell)
    {
        sCell = [[[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Bookmark"] autorelease];
    }

    return sCell;
}

- (id)initWithStyle:(UITableViewCellStyle)aStyle reuseIdentifier:(NSString *)aReuseIdentifier
{
    self = [super initWithStyle:aStyle reuseIdentifier:aReuseIdentifier];

    if (self)
    {
        [[self contentView] setBackgroundColor:[UIColor colorWithRed:0.95 green:1.0 blue:1.0 alpha:1.0]];
    }

    return self;
}

- (void)dealloc
{
    [mLink removeObserver:self forKeyPath:@"type"];
    [mLink release];
    [super dealloc];
}


- (void)setLink:(MELink *)aLink
{
    [mLink removeObserver:self forKeyPath:@"type"];
    [mLink release];
    mLink = [aLink retain];
    [mLink addObserver:self forKeyPath:@"type" options:NSKeyValueObservingOptionNew context:NULL];

    [[self textLabel] setText:[aLink urlDescription]];
}


#pragma mark NSKeyValueObserving


- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary *)aChange context:(void *)aContext
{
    [[self textLabel] setText:[aObject urlDescription]];
}


@end
