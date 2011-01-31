/*
 *  MEAttributedLabel.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 21.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "MEAttributedLabel.h"
#import "MEAttributedString.h"
#import "MEAttributedLayoutManager.h"


@interface MEAttributedLabel (Private)
@end

@implementation MEAttributedLabel (Private)


#pragma mark laying out labels

@end


@implementation MEAttributedLabel

@dynamic attributedText;


- (void)dealloc
{
    [mText release];
    [super dealloc];
}

- (CGSize)sizeThatFits:(CGSize)aSize
{
    return [mText sizeForWidth:aSize.width];
}

- (void)layoutSubviews
{
    [mText sizeForWidth:[self bounds].size.width];
    [[mText layoutManager] layoutOnAttributedLabel:self];
}


- (MEAttributedString *)attributedText
{
    return mText;
}

- (void)setAttributedText:(MEAttributedString *)aText
{
    if (![mText isEqual:aText])
    {
        [mText release];
        mText = [aText copy];

        [self setNeedsLayout];
    }
}

@end
