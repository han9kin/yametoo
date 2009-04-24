/*
 *  MEAttributedLabel.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 21.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEAttributedString;

@interface MEAttributedLabel : UIView
{
    MEAttributedString *mText;
}

@property(nonatomic, copy) MEAttributedString *attributedText;


@end
