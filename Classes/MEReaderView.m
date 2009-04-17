/*
 *  MEReaderView.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEReaderView.h"
#import "METableViewCellFactory.h"
#import "MEReaderHeadView.h"


@implementation MEReaderView


- (void)initializeViews
{
    CGRect sBounds = [self bounds];
    
    mTableView = [[UITableView alloc] initWithFrame:sBounds style:UITableViewStylePlain];
    [mTableView setDataSource:self];
    [mTableView setDelegate:self];
    [mTableView setTableHeaderView:[MEReaderHeadView readerHeadView]];
    [mTableView setDelaysContentTouches:NO];
    
    [self addSubview:mTableView];
}


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        [self initializeViews];
    }

    return self;
}


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    
    if (self)
    {
        [self initializeViews];    
    }
    
    return self;
}


- (void)drawRect:(CGRect)aRect
{
    // Drawing code
}

        
- (void)dealloc
{
    [mTableView release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark TableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 3;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    NSString *sResult = nil;
    
    if (aSection == 0)
    {
        sResult = @"오늘";
    }
    else if (aSection == 1)
    {
        sResult = @"어제";
    }
    else if (aSection == 2)
    {
        sResult = @"그저께";
    }
    
    return sResult;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    NSInteger sResult;
    
    if (aSection == 0)
    {
        sResult = 5;
    }
    else if (aSection == 1)
    {
        sResult = 3;
    }
    else if (aSection == 2)
    {
        sResult = 10;
    }
    
    return sResult;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sResult = nil;
    
    sResult = [aTableView dequeueReusableCellWithIdentifier:kTablePostCellIdentifier];
    if (!sResult)
    {
        sResult = [METableViewCellFactory tableViewCellForPost];
    }
    
    return sResult;
}


#pragma mark -
#pragma mark TableView Delegate


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    CGFloat sResult = 0;
    
    sResult = 90;
    return sResult;
}


@end
