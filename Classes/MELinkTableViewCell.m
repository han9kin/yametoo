/*
 *  MELinkTableViewCell.m
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 05.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MELinkTableViewCell.h"
#import "MEClient.h"
#import "MELink.h"


@implementation MELinkTableViewCell

+ (MELinkTableViewCell *)cellForTableView:(UITableView *)aTableView
{
    MELinkTableViewCell *sCell = (MELinkTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"Link"];

    if (!sCell)
    {
        sCell = [[[MELinkTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Link"] autorelease];
    }

    return sCell;
}

- (id)initWithFrame:(CGRect)aFrame reuseIdentifier:(NSString *)aReuseIdentifier
{
    self = [super initWithFrame:aFrame reuseIdentifier:aReuseIdentifier];

    if (self)
    {
        [[self contentView] setBackgroundColor:[UIColor colorWithRed:0.95 green:1.0 blue:1.0 alpha:1.0]];

        mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, 34)];
        [mTitleLabel setBackgroundColor:[UIColor clearColor]];
        [mTitleLabel setTextColor:[UIColor orangeColor]];
        [mTitleLabel setHighlightedTextColor:[UIColor whiteColor]];
        [mTitleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [[self contentView] addSubview:mTitleLabel];
        [mTitleLabel release];

        mURLLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, [[self contentView] bounds].size.width - 120, 34)];
        [mURLLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [mURLLabel setBackgroundColor:[UIColor clearColor]];
        [mURLLabel setTextColor:[UIColor brownColor]];
        [mURLLabel setHighlightedTextColor:[UIColor whiteColor]];
        [mURLLabel setFont:[UIFont systemFontOfSize:14.0]];
        [[self contentView] addSubview:mURLLabel];
        [mURLLabel release];
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

    [mTitleLabel setText:[aLink title]];
    [mURLLabel setText:[aLink urlDescription]];
}


#pragma mark NSKeyValueObserving


- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary *)aChange context:(void *)aContext
{
    [mURLLabel setText:[aObject urlDescription]];
}


@end
