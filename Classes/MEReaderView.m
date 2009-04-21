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


#define kPostBodyWidth  250


@implementation MEReaderView


- (void)initializeVariables
{
    mPostArray = [[NSMutableArray alloc] init];
}


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


#pragma mark -
#pragma mark init/dealloc


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        [self initializeVariables];
        [self initializeViews];
    }

    return self;
}


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    
    if (self)
    {
        [self initializeVariables];
        [self initializeViews];    
    }
    
    return self;
}


- (void)dealloc
{
    [mPostArray release];
    [mTableView release];
    
    [super dealloc];
}


#pragma mark -


- (void)drawRect:(CGRect)aRect
{
    // Drawing code
}


#pragma mark -
#pragma mark Instance Methods


- (void)setUser:(MEUser *)aUser
{
    NSLog(@"MEReaderView setUser - %@", aUser);
    MEReaderHeadView *sHeaderView;

    [mUser autorelease];
    mUser = [aUser retain];

    sHeaderView = (MEReaderHeadView *)[mTableView tableHeaderView];
    [sHeaderView setNickname:[mUser nickname]];
}


- (void)setHiddenPostButton:(BOOL)aFlag
{
    MEReaderHeadView *sHeaderView;
    
    sHeaderView = (MEReaderHeadView *)[mTableView tableHeaderView];
    [sHeaderView setHiddenPostButton:aFlag];
}


- (void)addPost:(MEPost *)aPost
{
    NSDate          *sDate        = [aPost pubDate];
    NSDateFormatter *sFormatter   = [[[NSDateFormatter alloc] init] autorelease];
    NSString        *sPostDateStr;
    NSString        *sDateStr;
    NSMutableArray  *sPostsOfDay;
    BOOL             sIsAdded = NO;
    
    [sFormatter setDateStyle:kCFDateFormatterShortStyle];
    sPostDateStr = [sFormatter stringFromDate:sDate];
    
    for (sPostsOfDay in mPostArray)
    {
        if ([sPostsOfDay count] != 0)
        {
            MEPost *sPost = [sPostsOfDay objectAtIndex:0];
            sDateStr = [sFormatter stringFromDate:[sPost pubDate]];
            if ([sDateStr isEqualToString:sPostDateStr])
            {
                [sPostsOfDay addObject:aPost];
                sIsAdded = YES;
            }
        }
    }
    
    if (!sIsAdded)
    {
        sPostsOfDay = [NSMutableArray array];
        [sPostsOfDay addObject:aPost];
        [mPostArray addObject:sPostsOfDay];
    }
    
    [mTableView reloadData];
}


- (void)removeAllPosts
{
    [mPostArray removeAllObjects];
}


- (MEPost *)postForIndexPath:(NSIndexPath *)aIndexPath
{
    MEPost  *sResult = nil;
    NSArray *sPostArrayOfDay;
    
    if ([mPostArray count] > [aIndexPath section])
    {
        sPostArrayOfDay = [mPostArray objectAtIndex:[aIndexPath section]];
        if ([sPostArrayOfDay count] > [aIndexPath row])
        {
            sResult = [sPostArrayOfDay objectAtIndex:[aIndexPath row]];        
        }
    }
    
    return sResult;
}


- (MEPost *)titlePostForSection:(NSInteger)aSection
{
    MEPost  *sResult = nil;
    NSArray *sPostArrayOfDay;
    
    if ([mPostArray count] > aSection)
    {
        sPostArrayOfDay = [mPostArray objectAtIndex:aSection];
        if ([sPostArrayOfDay count] > 0)
        {
            sResult = [sPostArrayOfDay objectAtIndex:0];
        }
    }
    
    return sResult;
}


#pragma mark -
#pragma mark TableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    NSInteger sResult;

    sResult = [mPostArray count];
    if (sResult == 0)
    {
        sResult = 1;
    }
    
    return sResult;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    NSString        *sResult = nil;
    MEPost          *sTitlePost;
    NSDate          *sPubDate;
    NSDateFormatter *sFormatter = [[[NSDateFormatter alloc] init] autorelease];//initWithDateFormat:@"%d %b %Y" allowNaturalLanguage:NO] autorelease];
  
//    NSLog(@"locale id = %@", [NSLocale availableLocaleIdentifiers]);
    [sFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    [sFormatter setDateFormat:@"d LLL y"];
    
    sTitlePost = [self titlePostForSection:aSection];
    sPubDate   = [sTitlePost pubDate];
    sResult    = [[sFormatter stringFromDate:sPubDate] uppercaseString];
    
    return sResult;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    NSInteger sResult = 0;
    
    if ([mPostArray count] > 0)
    {
        sResult = [[mPostArray objectAtIndex:aSection] count];
    }
    
    return sResult;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sResult = nil;
    UILabel         *sBodyLabel;
    UILabel         *sTagsLabel;
    UIImageView     *sImageView;
    MEPost          *sPost;
    NSString        *sBody;
    NSString        *sTags;
    CGSize           sSize;
    UIImage         *sImage;
    CGFloat          sYPos = 10;
    
    sResult = [aTableView dequeueReusableCellWithIdentifier:kTablePostCellIdentifier];
    if (!sResult)
    {
        sResult = [METableViewCellFactory tableViewCellForPost];
    }
    sBodyLabel = (UILabel *)[[sResult contentView] viewWithTag:kPostCellBodyLabelTag];
    sTagsLabel = (UILabel *)[[sResult contentView] viewWithTag:kPostCellTagsLabelTag];
    sImageView = (UIImageView *)[[sResult contentView] viewWithTag:kPostCellImageViewTag];
    
    sPost      = [self postForIndexPath:aIndexPath];
    sBody      = [sPost body];
    sTags      = [sPost tagsString];
    sImage     = ([sPost me2PhotoImage]) ? [sPost me2PhotoImage] : [sPost kindIconImage];
    
    [sImageView setImage:sImage];
    
    sSize      = [sBody sizeWithFont:[sBodyLabel font]
                   constrainedToSize:CGSizeMake(kPostBodyWidth, 10000)
                       lineBreakMode:UILineBreakModeCharacterWrap];
    [sBodyLabel setText:sBody];
    [sBodyLabel setFrame:CGRectMake(60, sYPos, sSize.width, sSize.height)];
    
    sYPos     += (sSize.height + 5);

    sSize      = [sTags sizeWithFont:[sTagsLabel font]
                 constrainedToSize:CGSizeMake(kPostBodyWidth, 10000)
                     lineBreakMode:UILineBreakModeCharacterWrap];
    [sTagsLabel setText:sTags];
    [sTagsLabel setFrame:CGRectMake(60, sYPos, sSize.width, sSize.height)];
    
    sYPos     += sSize.height;
    
    return sResult;
}


#pragma mark -
#pragma mark TableView Delegate


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    CGFloat   sResult = 0;
    MEPost   *sPost   = [self postForIndexPath:aIndexPath];
    NSString *sBody   = [sPost body];
    NSString *sTags   = [sPost tagsString];
    CGSize    sSize;

    sResult += 10;
    sSize    = [sBody sizeWithFont:[METableViewCellFactory fontForTableCellForPostBody]
                 constrainedToSize:CGSizeMake(kPostBodyWidth, 10000)
                     lineBreakMode:UILineBreakModeCharacterWrap];
    sResult += (sSize.height + 5);
    sSize    = [sTags sizeWithFont:[METableViewCellFactory fontForTableCellForPostTag]
                 constrainedToSize:CGSizeMake(kPostBodyWidth, 10000)
                     lineBreakMode:UILineBreakModeCharacterWrap];
    sResult += sSize.height;
    sResult += 10;
    
    sResult  = (sResult < 70) ? 70 : sResult;

    return sResult;
}


@end
