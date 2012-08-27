//
//  FMMoveTableViewCell.h
//  FMFramework
//
//  Created by Florian Mielke.
//  Copyright 2012 Florian Mielke. All rights reserved.
//  

#import "StopWatchBrain.h"

@interface FMMoveTableViewCell : UITableViewCell
@property (nonatomic) StopWatchBrain *brain;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *currentLap;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UIView *coloredBox;
@property (weak, nonatomic) IBOutlet UILabel *lapNumber;
@property (weak, nonatomic) IBOutlet UILabel *lapLabel;


@property (weak, nonatomic) IBOutlet UILabel *lap0;
@property (weak, nonatomic) IBOutlet UILabel *lap1;
@property (weak, nonatomic) IBOutlet UILabel *lap2;
@property (weak, nonatomic) IBOutlet UILabel *lap3;

- (void)prepareForMove;
- (void)doneMoving;

@end
