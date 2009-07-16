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
#import "MEImageView.h"
#import "MEImageButton.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"


enum
{
    kImageTag = 1,
    kTitleTag,
    kTextFieldTag,
    kCheckmarkTag,
    kLockIconTag,
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
        sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Default"] autorelease];
    }

    return sCell;

}


+ (UITableViewCell *)detailCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Detail"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Detail"] autorelease];
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
        sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextField"] autorelease];

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
        sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Switch"] autorelease];

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
        sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Button"] autorelease];

        [[sCell textLabel] setTextAlignment:UITextAlignmentCenter];
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
        sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"User"] autorelease];

        sImageView = [[MEImageView alloc] initWithFrame:CGRectMake(17, 7, 46, 46)];
        [sImageView setBorderColor:[UIColor lightGrayColor]];
        [sImageView setTag:kImageTag];
        [[sCell contentView] addSubview:sImageView];
        [sImageView release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 220, 59)];
        [sLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
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
    UITableViewCell *sCell;
    UILabel         *sLabel;
    UIImageView     *sImageView;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Client"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Client"] autorelease];

        [sCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];

        CGFloat sWidth = [[sCell contentView] bounds].size.width;

        sImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 14, 14)];
        [sImageView setTag:kCheckmarkTag];
        [sImageView setHidden:YES];
        [sImageView setImage:[UIImage imageNamed:@"checkmark_normal.png"]];
        [sImageView setHighlightedImage:[UIImage imageNamed:@"checkmark_highlighted.png"]];
        [[sCell contentView] addSubview:sImageView];
        [sImageView release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, sWidth - 60, 21)];
        [sLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [sLabel setTag:kTitleTag];
        [sLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [sLabel setHighlightedTextColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sImageView = [[UIImageView alloc] initWithFrame:CGRectMake(sWidth - 20, 14, 11, 15)];
        [sImageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [sImageView setTag:kLockIconTag];
        [sImageView setHidden:YES];
        [sImageView setImage:[UIImage imageNamed:@"locked_normal.png"]];
        [sImageView setHighlightedImage:[UIImage imageNamed:@"locked_highlighted.png"]];
        [[sCell contentView] addSubview:sImageView];
        [sImageView release];
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
        [[self textLabel] setTextColor:[UIColor lightGrayColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else
    {
        [[self textLabel] setTextColor:[UIColor blackColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
}


- (void)setTitleText:(NSString *)aText
{
    [(UILabel *)[[self contentView] viewWithTag:kTitleTag] setText:aText];
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


@end
