//
//  FMViewController.m
//  FMMoveTableView Sample Code
//
//  Created by Florian Mielke.
//  Copyright 2012 Florian Mielke. All rights reserved.
//  


#import "FMViewController.h"
#import "FMMoveTableView.h"
#import "FMMoveTableViewCell.h"
#import "StopWatchBrain.h"

#define TIMER_INTERVAL 0.05


@interface FMViewController ()
{
	NSDateFormatter *dateFormatter;
    UIColor *colorGreen;
    UIColor *colorRed;
}
@property (nonatomic, strong) NSMutableArray *watches; 
@property (nonatomic, weak) NSTimer *refreshTimer;
@end


@implementation FMViewController
@synthesize watches = _watches;
@synthesize refreshTimer;
@synthesize mainTableView;
@synthesize startAllLapButton;
@synthesize stopButton;
@synthesize resetButton;

bool hasStarted = false;


- (NSMutableArray *)watches
{
    if (_watches == nil) _watches = [[NSMutableArray alloc] init];
    return _watches;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //custom initialization
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss.S"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector (refreshCellLabels) userInfo:nil repeats:YES];
    
    colorGreen = [UIColor colorWithRed:0 green:0.6328125 blue:0.03125 alpha:1.0];
    colorRed = [UIColor colorWithRed:0.70703125 green:0 blue:0 alpha:1.0];
    
    //Make the navigation bar hidden on the Stopwatch view
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark -
#pragma mark Controller life cycle

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!hasStarted)
        return ([self.watches count] + 1);
    else {
        return [self.watches count];
    }
}


- (UITableViewCell *)tableView:(FMMoveTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return the "Type name" cell
    if (indexPath.row == [self.watches count] && !hasStarted) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AddStopwatchCell"];
        return cell;
        
    //return a stopwatch cell
    } else {
        FMMoveTableViewCell *cell = (FMMoveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"StopwatchCell"];
        
        if ([tableView indexPathIsMovingIndexPath:indexPath]) 
        {
            //make everything blank
            [cell prepareForMove]; 
        }
        else 
        {
            cell.brain = [self.watches objectAtIndex:indexPath.row];
            cell.name.text = [[self.watches objectAtIndex:indexPath.row] name];
            
            //make everything reappear
            [cell doneMoving]; 
            [cell setShouldIndentWhileEditing:NO];
            [cell setShowsReorderControl:NO];
        }
        
        return cell;
    }
}



#pragma mark -
#pragma mark Table view data source

- (void)moveTableView:(FMMoveTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    NSLog(@"\nfrom: %@\nto: %@\n", fromIndexPath, toIndexPath);
//    StopWatchBrain *watch = [self.watches objectAtIndex:fromIndexPath.row]; 
//    [self.watches removeObjectAtIndex:fromIndexPath.row];
//    [self.watches insertObject:watch atIndex:toIndexPath.row];
}

//this is actually my move tablviewcell function, because I need it to happen as things are moving along the table.
- (NSIndexPath *)moveTableView:(FMMoveTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	if ([sourceIndexPath section] != [proposedDestinationIndexPath section]) {
        [self.watches exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:proposedDestinationIndexPath.row];
		proposedDestinationIndexPath = sourceIndexPath;
	}
	return proposedDestinationIndexPath;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FMMoveTableViewCell *tempCell = (FMMoveTableViewCell *) [self.mainTableView cellForRowAtIndexPath:indexPath];
        
        // Delete the row from the data source FIRST
        [self.watches removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
        [self deepCleanCell:tempCell]; 
        
        if ([self tableIsEmpty]) {
            [self resetEverything];
            [self.mainTableView reloadData];
        }
        
    } 
}


- (void) refreshCellLabels 
{
    //black magic
	for (int i=0; i<[self.watches count]; i++) {
		FMMoveTableViewCell * cell = (FMMoveTableViewCell *)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		
		NSTimeInterval timeElapsed = [[self.watches objectAtIndex:i] timeElapsed];
		NSTimeInterval lapTimeElapsed = [[self.watches objectAtIndex:i] lapTimeElapsed];
		
		NSDate * mainTimeAsDate = [NSDate dateWithTimeIntervalSince1970:(timeElapsed)];
		NSDate * lapTimeAsDate = [NSDate dateWithTimeIntervalSince1970:(lapTimeElapsed)];
		
		cell.totalTime.text = [dateFormatter stringFromDate:mainTimeAsDate];
		cell.currentLap.text = [dateFormatter stringFromDate:lapTimeAsDate];
        
        if ([[self.watches objectAtIndex:i] isCounting]) {
            if (![cell.coloredBox.backgroundColor isEqual:colorGreen]) 
                cell.coloredBox.backgroundColor = colorGreen;
        } else {
            if (![cell.coloredBox.backgroundColor isEqual:colorRed])
                cell.coloredBox.backgroundColor = colorRed;
        }
        
        cell.position.text = [NSString stringWithFormat:@"%d", [[self.watches objectAtIndex:i] getWatchPosition]];
        cell.lapNumber.text = [NSString stringWithFormat:@"%d", 1+[[self.watches objectAtIndex:i] getLapsCompleted]];
        
        int numLaps = [cell.brain.laps count];
        switch (numLaps) {
            case 0:
                [[cell lap0] setHidden:YES];
            case 1:
                [[cell lap1] setHidden:YES];
            case 2:
                [[cell lap2] setHidden:YES];
            case 3:
                [[cell lap3] setHidden:YES];
            default:
                break;
        }
	}
}


- (void) startAllLapPressed:(id)sender 
{
    //if the table is empty, stop and don't do anything
    if ([self tableIsEmpty]) {
    
    //if there are watches but none are counting...
    } else if (!hasStarted) {
        for (int i=0; i<[self.watches count]; ++i) {
            [[self.watches objectAtIndex:i] startTimer];
        }
        hasStarted = true;
        [self.startAllLapButton setTitle: @"Lap" forState: UIControlStateNormal];
        [self.mainTableView reloadData];
        
    //if the watches are already counting
    } else {
        [[self.watches objectAtIndex:0] lapTimer];
        [self updatePreviousLaps];
        [self sendTopRowToAppropriatePlace];
        [self updatePositions];
    }
}

- (void) updatePreviousLaps 
{
    StopWatchBrain *tempBrain = [self.watches objectAtIndex:0];
    FMMoveTableViewCell *tempCell = (FMMoveTableViewCell *) [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]; 
    
    NSMutableArray *timesAsStrings = [[NSMutableArray alloc] init];
    
    for (int i=0; i<4; ++i) {
        if ([[tempBrain laps] count] > i) {
            NSTimeInterval time = [[[tempBrain laps] objectAtIndex:[[tempBrain laps] count]-(i+1)] doubleValue];
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:(time)];
            NSString * str = [NSString stringWithFormat:@"%d - %@", [[tempBrain laps] count] - (i), [dateFormatter stringFromDate:date]];
            [timesAsStrings addObject:str];
        }
    }
    
    if ([timesAsStrings count] > 0) {
        [[tempCell lap0] setHidden:NO];
        tempCell.lap0.text = [timesAsStrings objectAtIndex:0];
    }
    
    if ([timesAsStrings count] > 1) {
        [[tempCell lap1] setHidden:NO];
        tempCell.lap1.text = [timesAsStrings objectAtIndex:1];
    }
    
    if ([timesAsStrings count] > 2) {
        [[tempCell lap2] setHidden:NO];
        tempCell.lap2.text = [timesAsStrings objectAtIndex:2];
    }
    
    if ([timesAsStrings count] > 3) {
        [[tempCell lap3] setHidden:NO];
        tempCell.lap3.text = [timesAsStrings objectAtIndex:3];
    }
    
    
}

- (void) stopPressed:(id)sender 
{
    if (![self tableIsEmpty])
    {
        [[self.watches objectAtIndex:0] stopTimer];
        
        [self sendTopRowToAppropriatePlace];
        [self updatePositions];
    }
}

- (void) resetPressed:(id)sender
{
    if (![self tableIsEmpty]) 
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                          message:@"Delete all StopWatches too?"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Yes", @"No", nil];
        
        [message show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
        [self deepCleanTableView];
        [self resetEverything];
        [self.mainTableView reloadData];
    }
    else if([title isEqualToString:@"No"])
    {
        for (int i=0; i<[self.watches count]; ++i) {
            [[self.watches objectAtIndex:i] resetTimer]; 
        }
        hasStarted = NO;
        [self.startAllLapButton setTitle: @"Start All" forState: UIControlStateNormal];
        [self.mainTableView reloadData];
    }
    else if([title isEqualToString:@"Cancel"])
    {
        
    }
}

- (void) resetEverything 
{
    self.watches = nil;
    [self.mainTableView reloadData];
    hasStarted = NO;
    [self.startAllLapButton setTitle: @"Start All" forState: UIControlStateNormal];
}

- (void) deepCleanTableView
{
    for (int i=0; i<[self.watches count]; ++i) {
        FMMoveTableViewCell *tempCell = (FMMoveTableViewCell *) [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];            
        [self deepCleanCell:tempCell];
    }
}

- (void) deepCleanCell:(FMMoveTableViewCell *)cell 
{
    cell.totalTime.text = @"00:00.0";
    cell.currentLap.text = @"00:00.0";
    cell.name.text = @"Name";
    cell.position.text = @"1";
    cell.lapNumber.text = @"1";
    
    cell.brain = nil;
}

- (void) updatePositions 
{
    NSArray *temp = [self.watches sortedArrayUsingSelector:@selector(compare:)];
    
    int curPos = 1;
    for (int i=0; i<[self.watches count]; ++i) {
        if ([[temp objectAtIndex:i] getLapsCompleted] == 0)
            [[temp objectAtIndex:i] setWatchPosition:curPos];
        else 
            [[temp objectAtIndex:i] setWatchPosition:curPos++];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //hide keyboard
    [textField resignFirstResponder];
    
    //test against string with only white spaces
    NSString * test = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![test compare:@""])
    {
        textField.text = @"";
        return NO;
    } else {
        [self addWatch:textField.text];
        textField.text = @"";
        return YES;
    }
}


- (void)addWatch:(NSString *)nameOfRunner
{
	StopWatchBrain *toAdd = [[StopWatchBrain alloc] init];
    
    //compare new name against all old ones.
    BOOL found = NO;
    for (int i=0; i<[self.watches count]; ++i) {
        NSString * test = [[[self.watches objectAtIndex:i] name] lowercaseString];
        NSString * lowerNameOfRunner = [nameOfRunner lowercaseString];
        if ([test isEqualToString:lowerNameOfRunner]) {
            found = YES;
            break;
        }
    }
    
    //if duplicate, then show a message and make him do it over again.
    if (found) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Duplicate Name"
                                                          message:@"Please choose a different name"
                                                         delegate:self
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    
    toAdd.name = nameOfRunner;
	[self.watches addObject:toAdd];
    
    
    //start thread for the new StopWatchBrain
	[NSThread detachNewThreadSelector:@selector(run:) toTarget:toAdd withObject:nil];
	[self.mainTableView reloadData];
}

- (BOOL) tableIsEmpty {
    return [self.watches count] == 0;
}

- (void) sendTopRowToAppropriatePlace 
{
    StopWatchBrain *temp = [self.watches objectAtIndex:0];
    
    [self.watches removeObjectAtIndex:0];
    [self.watches insertObject:temp atIndex:[self.watches count]];
    
    [self.mainTableView beginUpdates];
    [self.mainTableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] toIndexPath:[NSIndexPath indexPathForRow:[self.watches count]-1 inSection:0]];
    [self.mainTableView endUpdates];
}

@end
