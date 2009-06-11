/*
 *  METableViewCellFactory.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSDate+MEAdditions.h"
#import "UIColor+MEAdditions.h"
#import "METableViewCellFactory.h"
#import "MEHighlightableImageView.h"
#import "MEImageView.h"
#import "MEImageButton.h"
#import "MEPostBodyView.h"
#import "MEAttributedLabel.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"
#import "MEPost.h"
#import "MECommentBackView.h"


enum
{
    kImageTag = 1,
    kTitleTag,
    kDetailTag,
    kTextFieldTag,
    kCheckmarkTag,
    kLockIconTag,

    kPostFaceImageTag,
    kPostIconTag,
    kPostAuthorLabelTag,
    kPostBodyTag,

    kCommentBackViewTag,
    kCommentFaceImageTag,
    kCommentBodyTag,
    kCommentAuthorTag,
    kCommentPubDateTag,
};


@implementation METableViewCellFactory


#pragma mark -
#pragma mark - Class Methods


+ (UITableViewCell *)defaultCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Default"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Default"] autorelease];
    }

    return sCell;

}


+ (UITableViewCell *)detailCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    UILabel         *sLabel;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Detail"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Detail"] autorelease];

        [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 43)];
        [sLabel setTag:kTitleTag];
        [sLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [sLabel setTextAlignment:UITextAlignmentLeft];
        [sLabel setTextColor:[UIColor blackColor]];
        [sLabel setHighlightedTextColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 43)];
        [sLabel setTag:kDetailTag];
        [sLabel setBackgroundColor:[UIColor clearColor]];
        [sLabel setFont:[UIFont systemFontOfSize:17.0]];
        [sLabel setTextAlignment:UITextAlignmentRight];
        [sLabel setTextColor:[UIColor selectedTextColor]];
        [sLabel setHighlightedTextColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];
    }

    return sCell;
}


+ (UITableViewCell *)textFieldCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    UILabel         *sLabel;
    UITextField     *sTextField;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"TextField"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"TextField"] autorelease];

        [sCell setSelectionStyle:UITableViewCellSelectionStyleNone];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 100, 21)];
        [sLabel setTag:kTitleTag];
        [sLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 6, 180, 31)];
        [sTextField setTag:kTextFieldTag];
        [sTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [sTextField setBorderStyle:UITextBorderStyleNone];
        [sTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [sTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [sTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [sTextField setEnablesReturnKeyAutomatically:YES];
        [[sCell contentView] addSubview:sTextField];
        [sTextField release];
    }

    return sCell;
}


+ (UITableViewCell *)switchCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    UISwitch        *sSwitch;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Switch"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Switch"] autorelease];

        [sCell setSelectionStyle:UITableViewCellSelectionStyleNone];

        sSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sCell setAccessoryView:sSwitch];
        [sSwitch release];
    }

    return sCell;
}


+ (UITableViewCell *)buttonCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Button"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Button"] autorelease];

        [sCell setTextAlignment:UITextAlignmentCenter];
    }

    return sCell;
}


#pragma mark -


+ (UITableViewCell *)userCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    UILabel         *sLabel;
    MEImageView     *sImageView;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"User"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"User"] autorelease];

        sImageView = [[MEImageView alloc] initWithFrame:CGRectMake(9, 9, 52, 52)];
        [sImageView setBorderColor:[UIColor lightGrayColor]];
        [sImageView setTag:kImageTag];
        [[sCell contentView] addSubview:sImageView];
        [sImageView release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 180, 69)];
        [sLabel setTag:kTitleTag];
        [sLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [sLabel setTextColor:[UIColor blackColor]];
        [sLabel setHighlightedTextColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];
    }

    return sCell;
}


+ (UITableViewCell *)clientCellForTableView:(UITableView *)aTableView
{
    UITableViewCell          *sCell;
    UILabel                  *sLabel;
    MEHighlightableImageView *sImageView;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Client"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Client"] autorelease];

        [sCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];

        sImageView = [[MEHighlightableImageView alloc] initWithFrame:CGRectMake(10, 15, 14, 14)];
        [sImageView setTag:kCheckmarkTag];
        [sImageView setHidden:YES];
        [sImageView setNormalImage:[UIImage imageNamed:@"checkmark_normal.png"]];
        [sImageView setHighlightedImage:[UIImage imageNamed:@"checkmark_highlighted.png"]];
        [[sCell contentView] addSubview:sImageView];
        [sImageView release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 210, 21)];
        [sLabel setTag:kTitleTag];
        [sLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [sLabel setHighlightedTextColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sImageView = [[MEHighlightableImageView alloc] initWithFrame:CGRectMake(245, 14, 11, 15)];
        [sImageView setTag:kLockIconTag];
        [sImageView setHidden:YES];
        [sImageView setNormalImage:[UIImage imageNamed:@"locked_normal.png"]];
        [sImageView setHighlightedImage:[UIImage imageNamed:@"locked_highlighted.png"]];
        [[sCell contentView] addSubview:sImageView];
        [sImageView release];
    }

    return sCell;
}


+ (UITableViewCell *)postCellForTableView:(UITableView *)aTableView withTarget:(id)aTarget
{
    UITableViewCell *sCell;
    MEImageButton   *sImageButton;
    MEPostBodyView  *sBodyView;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Post"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Post"] autorelease];

        sImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding - 1, kIconImageSize + 2, kIconImageSize + 2)];
        [sImageButton setBorderColor:[UIColor lightGrayColor]];
        [sImageButton setTag:kPostIconTag];
        [sImageButton addTarget:aTarget action:@selector(iconImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [[sCell contentView] addSubview:sImageButton];
        [sImageButton release];

        sBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding, 0, 0)];
        [sBodyView setTag:kPostBodyTag];
        [sBodyView setBackgroundColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sBodyView];
        [sBodyView release];
    }

    return sCell;
}


+ (UITableViewCell *)postCellWithAuthorForTableView:(UITableView *)aTableView withTarget:(id)aTarget
{
    UITableViewCell *sCell;
    UILabel         *sLabel;
    MEImageButton   *sImageButton;
    MEPostBodyView  *sBodyView;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"PostWithAuthor"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"PostWithAuthor"] autorelease];

        sImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding - 1, kIconImageSize + 2, kIconImageSize + 2)];
        [sImageButton setTag:kPostFaceImageTag];
        [sImageButton setBorderColor:[UIColor lightGrayColor]];
        [sImageButton addTarget:aTarget action:@selector(faceImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [[sCell contentView] addSubview:sImageButton];
        [sImageButton release];

        sImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding + 49, kIconImageSize + 2, kIconImageSize + 2)];
        [sImageButton setTag:kPostIconTag];
        [sImageButton setBorderColor:[UIColor lightGrayColor]];
        [sImageButton addTarget:aTarget action:@selector(iconImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [[sCell contentView] addSubview:sImageButton];
        [sImageButton release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding, 250, 15)];
        [sLabel setTag:kPostAuthorLabelTag];
        [sLabel setBackgroundColor:[UIColor whiteColor]];
        [sLabel setFont:[UIFont systemFontOfSize:12.0]];
        [sLabel setTextColor:[UIColor darkGrayColor]];
        [sLabel setHighlightedTextColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding + 20, 0, 0)];
        [sBodyView setTag:kPostBodyTag];
        [sBodyView setBackgroundColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sBodyView];
        [sBodyView release];
    }

    return sCell;
}


+ (UITableViewCell *)commentCellForTableView:(UITableView *)aTableView withTarget:(id)aTarget
{
    UITableViewCell   *sCell;
    MECommentBackView *sBackView;
    MEImageButton     *sImageButton;
    MEAttributedLabel *sBodyLabel;
    UILabel           *sLabel;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Comment"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Comment"] autorelease];

        [sCell setSelectionStyle:UITableViewCellSelectionStyleNone];

        sBackView = [[MECommentBackView alloc] initWithFrame:CGRectZero];
        [sBackView setTag:kCommentBackViewTag];
        [[sCell contentView] addSubview:sBackView];
        [sBackView release];

        sBodyLabel = [[MEAttributedLabel alloc] initWithFrame:CGRectZero];
        [sBodyLabel setTag:kCommentBodyTag];
        [[sCell contentView] addSubview:sBodyLabel];
        [sBodyLabel release];

        sImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(0, 0, kIconImageSize + 2, kIconImageSize + 2)];
        [sImageButton setBorderColor:[UIColor lightGrayColor]];
        [sImageButton setTag:kCommentFaceImageTag];
        [sImageButton addTarget:aTarget action:@selector(faceImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [[sCell contentView] addSubview:sImageButton];
        [sImageButton release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [sLabel setTag:kCommentAuthorTag];
        [sLabel setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.7]];
        [sLabel setFont:[UIFont systemFontOfSize:9]];
        [sLabel setTextColor:[UIColor whiteColor]];
        [sLabel setTextAlignment:UITextAlignmentCenter];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [sLabel setTag:kCommentPubDateTag];
        [sLabel setFont:[UIFont systemFontOfSize:10]];
        [sLabel setTextColor:[UIColor colorWithWhite:0.6 alpha:1.0]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];
    }

    return sCell;
}


@end


#pragma mark -
#pragma mark UITableViewCell Additions for Content Accessing


@implementation UITableViewCell (ContentAccessing)


- (void)setDisabled:(BOOL)aDisabled
{
    if (aDisabled)
    {
        [self setTextColor:[UIColor lightGrayColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else
    {
        [self setTextColor:[UIColor blackColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
}


- (void)setTitleText:(NSString *)aText
{
    [(UILabel *)[[self contentView] viewWithTag:kTitleTag] setText:aText];
}


- (void)setDetailText:(NSString *)aText
{
    [(UILabel *)[[self contentView] viewWithTag:kDetailTag] setText:aText];
}


- (UITextField *)textField;
{
    return (UITextField *)[[self contentView] viewWithTag:kTextFieldTag];
}


- (UISwitch *)switch
{
    return (UISwitch *)[self accessoryView];
}


#pragma mark -

- (void)setUser:(MEUser *)aUser
{
    [(MEImageView *)[[self contentView] viewWithTag:kImageTag] setImageWithURL:[aUser faceImageURL]];
    [(UILabel *)[[self contentView] viewWithTag:kTitleTag] setText:[aUser userID]];
}


- (void)setUserID:(NSString *)aUserID
{
    [(MEImageView *)[[self contentView] viewWithTag:kImageTag] setImageWithURL:nil];
    [(UILabel *)[[self contentView] viewWithTag:kTitleTag] setText:aUserID];
}


- (void)setClient:(MEClient *)aClient
{
    UILabel *sLabel     = (UILabel *)[[self contentView] viewWithTag:kTitleTag];
    UIView  *sCheckmark = [[self contentView] viewWithTag:kCheckmarkTag];
    UIView  *sLockIcon  = [[self contentView] viewWithTag:kLockIconTag];

    [sLabel setText:[aClient userID]];

    if (aClient == [MEClientStore currentClient])
    {
        [sCheckmark setHidden:NO];
        [sLabel setTextColor:[UIColor selectedTextColor]];
    }
    else
    {
        [sCheckmark setHidden:YES];
        [sLabel setTextColor:[UIColor blackColor]];
    }

    if ([aClient hasPasscode])
    {
        [sLockIcon setHidden:NO];
    }
    else
    {
        [sLockIcon setHidden:YES];
    }
}


- (void)setPost:(MEPost *)aPost
{
    UILabel        *sLabel;
    MEImageButton  *sImageButton;
    MEPostBodyView *sBodyView;

    sLabel = (UILabel *)[[self contentView] viewWithTag:kPostAuthorLabelTag];
    [sLabel setText:[[aPost author] nickname]];

    sImageButton = (MEImageButton *)[[self contentView] viewWithTag:kPostFaceImageTag];
    [sImageButton setUserInfo:[aPost author]];
    [sImageButton setImageWithURL:[[aPost author] faceImageURL]];

    sImageButton = (MEImageButton *)[[self contentView] viewWithTag:kPostIconTag];
    [sImageButton setUserInfo:aPost];
    [sImageButton setImageWithURL:[aPost iconURL]];

    sBodyView = (MEPostBodyView *)[[self contentView] viewWithTag:kPostBodyTag];
    [sBodyView setPost:aPost];
}


#pragma mark -
#pragma mark Comment Table Cell


- (void)setComment:(MEComment *)aComment isOwners:(BOOL)aOwners
{
    MECommentBackView *sBackView     = (MECommentBackView *)[[self contentView] viewWithTag:kCommentBackViewTag];
    MEImageButton     *sImageButton  = (MEImageButton *)[[self contentView] viewWithTag:kCommentFaceImageTag];
    MEAttributedLabel *sBodyLabel    = (MEAttributedLabel *)[[self contentView] viewWithTag:kCommentBodyTag];
    UILabel           *sAuthorLabel  = (UILabel *)[[self contentView] viewWithTag:kCommentAuthorTag];
    UILabel           *sPubDateLabel = (UILabel *)[[self contentView] viewWithTag:kCommentPubDateTag];
    CGRect             sBodyFrame;
    CGFloat            sCellHeight;

    if (aOwners)
    {
        [sImageButton setUserInfo:nil];
        [sImageButton setFrame:CGRectMake(265, 9, kIconImageSize + 2, kIconImageSize + 2)];
        [sBodyLabel setFrame:CGRectMake(10, 10, kCommentBodyWidth, 0)];
        [sAuthorLabel setFrame:CGRectMake(265, 41, kIconImageSize + 2, 14)];
    }
    else
    {
        [sImageButton setUserInfo:[aComment author]];
        [sImageButton setFrame:CGRectMake(9, 9, kIconImageSize + 2, kIconImageSize + 2)];
        [sBodyLabel setFrame:CGRectMake(70, 10, kCommentBodyWidth, 0)];
        [sAuthorLabel setFrame:CGRectMake(9, 41, kIconImageSize + 2, 14)];
    }

    [sImageButton setImageWithURL:[[aComment author] faceImageURL]];

    [sBodyLabel setAttributedText:[aComment body]];
    [sBodyLabel sizeToFit];

    [sAuthorLabel  setText:[[aComment author] nickname]];
    [sPubDateLabel setText:[[aComment pubDate] localizedDateTimeString]];

    sBodyFrame  = [sBodyLabel frame];
    sBodyFrame.size.height += 14;

    sCellHeight = 10;
    sCellHeight += (sBodyFrame.size.height > kIconImageSize) ? sBodyFrame.size.height : kIconImageSize;
    sCellHeight += 10;

    if (aOwners)
    {
        [sPubDateLabel setTextAlignment:UITextAlignmentLeft];
        [sPubDateLabel setFrame:CGRectMake(10, sCellHeight - 20, 200, 14)];
    }
    else
    {
        [sPubDateLabel setTextAlignment:UITextAlignmentRight];
        [sPubDateLabel setFrame:CGRectMake(sBodyFrame.origin.x + 40, sCellHeight - 20, 200, 14)];
    }

    [sBackView setFrame:CGRectMake(0, 0, 320, sCellHeight)];
}


- (void)setCommentBackgroundColor:(UIColor *)aColor
{
    MECommentBackView *sBackView     = (MECommentBackView *)[[self contentView] viewWithTag:kCommentBackViewTag];
    MEAttributedLabel *sBodyLabel    = (MEAttributedLabel *)[[self contentView] viewWithTag:kCommentBodyTag];
    UILabel           *sPubDateLabel = (UILabel *)[[self contentView] viewWithTag:kCommentPubDateTag];

    [sBackView setBackgroundColor:aColor];
    [sBodyLabel setBackgroundColor:aColor];
    [sPubDateLabel setBackgroundColor:aColor];
}


@end
