//
//  StopWatchBrain.h
//  StopWatchRetry
//
//  Created by Tyler Hoffman on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopWatchBrain : NSObject

@property NSTimeInterval timeElapsed;
@property NSTimeInterval lapTimeElapsed;
@property (nonatomic, strong) NSMutableArray *laps;
@property NSString *name;


- (void) run:(id)ignored;
- (void) stopTimer;
- (void) lapTimer;
- (void) startTimer; 
- (void) stopThread;
- (void) resetTimer;

//helper
- (int) getTimerID;
- (int) getLapsCompleted;
- (bool) isRunning;
- (bool) isCounting;
- (int) getWatchPosition;
- (void) setWatchPosition:(int)pos;
- (double) getLapTime;

@end
