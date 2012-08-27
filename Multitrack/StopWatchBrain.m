//
//  StopWatchBrain.m
//  StopWatchRetry
//
//  Created by Tyler Hoffman on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StopWatchBrain.h"
#define REFRESH_RATE .05

@interface StopWatchBrain()
{
    int timerID;
    int position;
    bool running;
    bool counting;
}
@property (nonatomic, strong) NSDate *prevUpDATE;
@property (nonatomic, strong) NSDate *prevLapUpDATE;
@end

@implementation StopWatchBrain
@synthesize laps = _laps;
@synthesize timeElapsed;
@synthesize lapTimeElapsed;
@synthesize prevLapUpDATE;
@synthesize prevUpDATE;
@synthesize name;

- (id) init  {
    if ( self = [super init] ) {
        self.laps = [[NSMutableArray alloc] init];
		running = true;
		counting = false;
        position = 1;
    }
    return self;
}

-(void) update 
{
	self.timeElapsed = self.timeElapsed + [[NSDate date] timeIntervalSinceDate:self.prevLapUpDATE];
    self.lapTimeElapsed = self.lapTimeElapsed + [[NSDate date] timeIntervalSinceDate:self.prevLapUpDATE];
	self.prevLapUpDATE = [NSDate date];
	self.prevUpDATE = [NSDate date];
}

- (void) run:(id)ignored 
{
	while (running) 
	{
		self.prevLapUpDATE = [NSDate date];
		self.prevUpDATE = [NSDate date];
		
		while (counting) 
		{
			[self update];
			[NSThread sleepForTimeInterval:REFRESH_RATE];
		}
		[NSThread sleepForTimeInterval:REFRESH_RATE];
		
	}
}

- (void) stopTimer 
{
    counting = false;
}

- (void) lapTimer 
{
	if (counting) 
	{
		[self.laps addObject:[NSNumber numberWithDouble:self.lapTimeElapsed]];
		lapTimeElapsed = 0;
	}
}

- (void) resetTimer 
{
    counting = false;
    timeElapsed = 0.0;
    lapTimeElapsed = 0.0;
    position = 1;
    self.laps = nil;
}

- (void) startTimer 
{
	counting = true;
}

-(void) stopThread 
{
	running = false;
}

- (int) getTimerID 
{
    return timerID;
}

- (bool) isRunning 
{
    return running;
}
- (bool) isCounting 
{
    return counting;
}

- (int) getLapsCompleted
{
    return [self.laps count];
}

- (int) getWatchPosition 
{
    return position;
}

- (void) setWatchPosition:(int)pos
{
    position = pos;
}

- (double) getLapTime 
{
    return lapTimeElapsed;
}

- (NSComparisonResult)compare:(StopWatchBrain *)other {
    if (![self isCounting] && ![other isCounting]) {
        if ([self timeElapsed] > [other timeElapsed]) {
            return 1;
        } else if ([self timeElapsed] < [other timeElapsed]) {
            return -1;
        }
    } else {
        if ([self getLapsCompleted] < [other getLapsCompleted]) {
            return 1;
        } else if ([self getLapsCompleted] > [other getLapsCompleted]) {
            return -1;
        } else {
            if ([self getLapTime] < [other getLapTime]) {
                return 1;
            } else if ([self getLapTime] > [other getLapTime]) {
                return -1;
            } else {
                return 0;
            }
        }
    }
    return 0;
}

@end
