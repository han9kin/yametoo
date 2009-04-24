/*
 *  MEAttributedLayoutManager.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 24.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEAttributedString;
@class MEAttributedLabel;

@interface MEAttributedLayoutManager : NSObject
{
    NSMutableArray *mLayoutInfos;
    CGSize          mLayoutSize;
    CGFloat         mLayoutWidth;
}

@property(nonatomic, readonly) CGSize  layoutSize;
@property(nonatomic, readonly) CGFloat layoutWidth;


- (void)invalidate;

- (void)layoutAttributedString:(MEAttributedString *)aString forWidth:(CGFloat)aWidth;
- (void)layoutOnAttributedLabel:(MEAttributedLabel *)aLabel;

@end
