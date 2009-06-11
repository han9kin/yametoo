/*
 *  MEIconListView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 06. 11.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEIconListView;


@protocol MEIconListViewDelegate <NSObject>

- (void)iconListView:(MEIconListView *)aView iconDidSelect:(NSInteger)aIndex;

@end


@interface MEIconListView : UIView
{
    id<MEIconListViewDelegate> mDelegate;
}

@property(nonatomic, assign) id<MEIconListViewDelegate> delegate;

- (IBAction)buttonTapped:(id)aSender;

@end
