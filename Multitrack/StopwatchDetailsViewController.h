//
//  StopwatchDetailsViewController.h
//  MultiStopwatch
//
//  Created by Tyler on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StopwatchDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *detailsTableView;
@end
