//
//  FMMoveTableViewCell.m
//  FMFramework
//
//  Created by Florian Mielke.
//  Copyright 2012 Florian Mielke. All rights reserved.
//  


#import "FMMoveTableViewCell.h"

@implementation FMMoveTableViewCell
@synthesize totalTime;
@synthesize currentLap;
@synthesize name;
@synthesize position;
@synthesize coloredBox;
@synthesize  lapNumber;
@synthesize brain;
@synthesize lapLabel;


@synthesize lap0;
@synthesize lap1;
@synthesize lap2;
@synthesize lap3;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[self lap0] setHidden:YES];
    }
    return self;
}

- (void)prepareForMove
{
	[[self totalTime] setHidden:YES];
	[[self currentLap] setHidden:YES];
	[[self position] setHidden:YES];
    [[self name] setHidden:YES];
    [[self coloredBox] setHidden:YES];
    [[self lapNumber] setHidden:YES];
    [[self lap0] setHidden:YES];
    [[self lap1] setHidden:YES];
    [[self lap2] setHidden:YES];
    [[self lap3] setHidden:YES];
    [[self lapLabel] setHidden:YES];
}

-(void)doneMoving 
{
    [[self totalTime] setHidden:NO];
	[[self currentLap] setHidden:NO];
	[[self position] setHidden:NO];
    [[self name] setHidden:NO];
    [[self coloredBox] setHidden:NO];
    [[self lapNumber] setHidden:NO];
    [[self lap0] setHidden:NO];
    [[self lap1] setHidden:NO];
    [[self lap2] setHidden:NO];
    [[self lap3] setHidden:NO];
    [[self lapLabel] setHidden:NO];
}

@end
