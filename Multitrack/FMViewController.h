//
//  FMViewController.h
//  FMMoveTableView Sample Code
//
//  Created by Florian Mielke.
//  Copyright 2012 Florian Mielke. All rights reserved.
//  


#import "FMMoveTableView.h"


@interface FMViewController : UIViewController <UITextFieldDelegate, FMMoveTableViewDataSource, FMMoveTableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet FMMoveTableView *mainTableView;
@property (nonatomic, weak) IBOutlet UIButton *startAllLapButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (nonatomic, weak) IBOutlet UIButton *resetButton;

- (IBAction)startAllLapPressed:(id)sender;
- (IBAction)stopPressed:(id)sender;
- (IBAction)resetPressed:(id)sender;

@end
