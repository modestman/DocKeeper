//
//  DocumentsTableViewController.h
//  DocKeeper
//
//  Created by Admin on 04.04.16.
//  Copyright © 2016 Anton Glezman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface DocumentsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

- (IBAction)addNew:(UIBarButtonItem *)sender;
- (IBAction)exit:(UIBarButtonItem *)sender;
- (IBAction)resetPassword:(id)sender;

@end
